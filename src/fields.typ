#import "types/base.typ"
#import "types/types.typ"

#let field-key = "__field"
#let fields-key = "__fields"

#let current-field-version = 1

// Specifies an element field's properties.
#let field(
  name,
  type_,
  required: false,
  named: auto,
  default: auto,
) = {
  assert(type(name) == str, message: "field: Field name must be a string, not " + str(type(name)))

  let error-prefix = "field '" + name + "': "
  assert(type(required) == bool, message: error-prefix + "'required' must be a boolean")
  assert(named == auto or type(named) == bool, message: error-prefix + "'named' must be a boolean or auto")
  let typeinfo = {
    let (success, value) = types.validate(type_)
    assert(success, message: if not success { error-prefix + value } else { "" })
    value
  }

  if not required and default == auto {
    let (success, value) = types.default(typeinfo)
    assert(success, message: if not success { error-prefix + value } else { "" })

    default = value
  }

  let accepted-default = if required {
    // This value should be ignored in that case
    auto
  } else {
    types.force-cast(default, typeinfo, error-prefix: error-prefix, hint: "given default for field had an incompatible type")
  }

  if named == auto {
    // Pos arg is generally required
    named = not required
  }

  (
    (field-key): true,
    version: current-field-version,
    name: name,
    typeinfo: typeinfo,
    default: accepted-default,
    required: required,
    named: named,
  )
}

// ARG PARSING CODE GENERATION
// Assuming 'pos' are positional args and 'named' are named args
// {n} is field number
// t{n} has field typeinfo and f{n} has field name

// How to retrieve a required named field?
#let required-named-field-template = ```typ

  value = named.remove(f{n})
  casted = {cast}
  result.insert(f{n}, casted)
```.text

// How to retrieve an optional named field?
#let optional-named-field-template = ```typ

  if f{n} in named {
    value = named.remove(f{n})
    casted = {cast}
    result.insert(f{n}, casted)
  }
```.text

// How to retrieve a required positional field?
#let required-pos-field-template = ```typ

  value = pos.pop()
  casted = {cast}
  result.insert(f{n}, casted)
```.text

// How to retrieve an optional positional field?
#let optional-pos-field-template = ```typ

  if pos.len() != 0 {
    value = pos.pop()
    casted = {cast}
    result.insert(f{n}, casted)
  }
```.text

// Prologue for 'parse-args-required' function
// This function receives arguments which are then parsed into a 'result'
// dictionary containing fields. Required fields are enforced and must be
// present. This is used for an element's constructor.
#let parse-args-required-prologue = ```typc
let parse-args-required(args) = {
  let pos = args.pos().rev()
  let named = args.named()
  let value = none
  let casted = none
  let result = (:)

  if pos.len() < {required} {
    // Plural
    let s = if {required} - pos.len() == 1 { "" } else { "s" }

    assert(false, message: "element '" + name + "': missing positional field" + s + " " + required-pos-names.slice(pos.len()).map(f => "'" + f + "'").join(", "))
  }

  if pos.len() > {total} {
    assert(false, message: "element '" + name + "': too many positional arguments, expected {total}")
  }

```.text

#let parse-args-required-epilogue = ```typc

  if named != (:) {
    let field-name = named.keys().first()

    assert(false, message: "element '" + name + "': unknown named field '" + field-name + "'")
  }

  result
}

parse-args-required
```.text

#let parse-args-not-required-prologue = ```typc
let parse-args-not-required(args) = {
  let pos = args.pos().rev()
  let named = args.named()
  let value = none
  let casted = none
  let result = (:)

  if pos.len() > {optional} {
    assert(false, message: "element '" + name + "': too many positional arguments, expected {optional}\nhint: only optional fields are accepted here")
  }
```.text

#let parse-args-not-required-epilogue = ```typc

  if named != (:) {
    let field-name = named.keys().first()

    assert(false, message: "element '" + name + "': unknown named field '" + field-name + "'")
  }

  result
}

parse-args-not-required
```.text

#let check-for-missing-required-names-template = ```typc

  if {condition} {
    let missing-fields = required-named-names.filter(f => f not in named)
    let s = if missing-fields.len() == 1 { "" } else { "s" }

    assert(false, message: "element '" + name + "': missing required named field" + s + " " + missing-fields.map(f => "'" + f + "'").join(", "))
  }
```.text

#let check-for-present-required-names-template = ```typc

  if {condition} {
    let present-fields = required-named-names.filter(f => f in named)
    let s = if present-fields.len() == 1 { "" } else { "s" }
    let are = if present-fields.len() == 1 { "is" } else { "are" }

    assert(false, message: "element '" + name + "': the field" + s + " " + present-fields.map(f => "'" + f + "'").join(", ") + " " + are + " required and cannot be specified here")
  }
```.text

#let force-cast-template = `force-cast(value, t{n}, error-prefix: "field '" + f{n} + "' of element '" + name + "': ")`.text

#let native-typecast-template = ```typc
if type(value) not in t{n}.input {
    assert(false, message: "field '" + f{n} + "' of element '" + name + "': expected " + t{n}.name + ", found " + str(type(value)))
  } else {
    {value}
  }
```.text

#let generate-parser-for-field(required, named, typeinfo, n) = {
  let casted = if typeinfo.at(base.type-key) == "native" {
    native-typecast-template.replace("{value}", if typeinfo.input.len() > 1 {
      let native-type = typeinfo.output.first()
      if native-type == content {
        "[#value]"
      } else {
        "(t{n}.cast)(value)"
      }
    } else {
      "value"
    })
  } else {
    force-cast-template
  }

  if required {
    if named {
      required-named-field-template
    } else {
      required-pos-field-template
    }
  } else if named {
    optional-named-field-template
  } else {
    optional-pos-field-template
  }.replace("{cast}", casted).replace("{n}", str(n))
}

#let parse-fields(fields, name: "") = {
  let required-pos-fields = ()
  let optional-pos-fields = ()
  let required-named-fields = ()
  let required-named-field-indices = ()
  let all-fields = (:)

  let field-parsers-with-required = ""
  let field-parsers-without-required = ""

  let function-scope = (name: name)
  let n = 0
  for field in fields {
    assert(type(field) == dictionary and field.at(field-key, default: none) == true, message: "element.fields: Invalid field received, please use the 'e.fields.field' constructor.")
    assert(field.named or not field.required or optional-pos-fields == (), message: "element.fields: field '" + field.name + "' cannot be positional and required and appear after other positional but optional fields. Ensure there are only optional fields after the first positional optional field.")
    assert(field.name not in all-fields, message: "element.fields: duplicate field name '" + field.name + "'")

    if field.required {
      if field.named {
        required-named-field-indices.push(str(n))
        required-named-fields.push(field)
      } else {
        required-pos-fields.push(field)
      }
    } else if not field.named {
      optional-pos-fields.push(field)
    }

    let field-parser = generate-parser-for-field(field.required, field.named, field.typeinfo, n)
    field-parsers-with-required += field-parser
    if not field.required {
      field-parsers-without-required += field-parser
    }

    function-scope.insert("t" + str(n), field.typeinfo)
    function-scope.insert("f" + str(n), field.name)
    all-fields.insert(field.name, field)

    n += 1
  }

  let check-for-missing-required-names = ""
  let check-for-present-required-names = ""

  if required-named-field-indices != () {
    // "field1" not in named or "field2" not in named
    let conditional-escaped-required-names-not-present = required-named-field-indices.map(f => "f" + f + " not in named").join(" or ")
    // "field1" in named or "field2" in named
    let conditional-escaped-required-names-present = required-named-field-indices.map(f => "f" + f + " in named").join(" or ")

    check-for-missing-required-names = check-for-missing-required-names-template.replace("{condition}", conditional-escaped-required-names-not-present)

    check-for-present-required-names = check-for-present-required-names-template.replace("{condition}", conditional-escaped-required-names-present)
  }

  let required-pos-fields-amount = required-pos-fields.len()
  let optional-pos-fields-amount = optional-pos-fields.len()
  let total-pos-fields-amount = required-pos-fields-amount + optional-pos-fields-amount
  let parse-args-required-src = (
    parse-args-required-prologue.replace("{required}", str(required-pos-fields-amount)).replace("{total}", str(total-pos-fields-amount))
    + check-for-missing-required-names
    + field-parsers-with-required
    + parse-args-required-epilogue
  )

  let parse-args-not-required-src = (
    parse-args-not-required-prologue.replace("{optional}", str(optional-pos-fields-amount))
    + check-for-present-required-names
    + field-parsers-without-required
    + parse-args-not-required-epilogue
  )

  // assert(false,  message: parse-args-required-src)
  // assert(false,  message: parse-args-not-required-src)

  function-scope += (
    required-pos-names: required-pos-fields.map(f => f.name),
    required-named-names: required-named-fields.map(f => f.name),
    force-cast: types.force-cast,
  )

  let parse-args-required = eval(parse-args-required-src, scope: function-scope)
  let parse-args-not-required = eval(parse-args-not-required-src, scope: function-scope)

  (
    (fields-key): true,
    version: current-field-version,
    required-pos-fields: required-pos-fields,
    optional-pos-fields: optional-pos-fields,
    required-named-fields: required-named-fields,
    all-fields: all-fields,
    parse-args-required: parse-args-required,
    parse-args-not-required: parse-args-not-required,
  )
}
