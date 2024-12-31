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

#let parse-fields(fields, name: "") = {
  let required-pos-fields = ()
  let optional-pos-fields = ()
  let required-named-fields = ()
  let all-fields = (:)

  let parse-required-pos-fields = ""
  let parse-optional-pos-fields-with-required = ""
  let parse-optional-pos-fields-without-required = ""
  let parse-required-named-fields-with-required = ""
  let parse-required-named-fields-without-required = ""
  let parse-non-required-named-fields = ""

  let escaped-required-names = ()

  let function-scope = (name: name)
  let i = 0
  let j = 0
  let n = 0
  for field in fields {
    assert(type(field) == dictionary and field.at(field-key, default: none) == true, message: "element.fields: Invalid field received, please use the 'e.fields.field' constructor.")
    assert(field.named or not field.required or optional-pos-fields == (), message: "element.fields: field '" + field.name + "' cannot be positional and required and appear after other positional but optional fields. Ensure there are only optional fields after the first positional optional field.")
    assert(field.name not in all-fields, message: "element.fields: duplicate field name '" + field.name + "'")

    let escaped-name = repr(field.name).trim("\"", repeat: false)
    if field.required {
      if field.named {
        required-named-fields.push(field)

        escaped-required-names.push("\"" + escaped-name + "\"")

        // No need for an 'if', we will check for all required names at once first
        parse-required-named-fields-with-required += "\n" + ```typ
    value = named.remove("{f}")
    result.insert("{f}", force-cast(value, typeinfo{n}, error-prefix: "field '{f}' of element '" + name + "': "))
```.text.replace("{n}", str(n)).replace("{f}", escaped-name)

        parse-required-named-fields-without-required += "\n" + ```typ
    if "{f}" in named {
      assert(false, message: "element '" + name + "': field '{f}' cannot be specified here\nhint: only optional fields are accepted here")
    }
```.text.replace("{f}", escaped-name)
      } else {
        parse-required-pos-fields += "\n" + ```typ
    value = pos.pop()
    result.insert("{f}", force-cast(value, typeinfo{n}, error-prefix: "field '{f}' of element '" + name + "': "))
```.text.replace("{n}", str(n)).replace("{f}", escaped-name)
        required-pos-fields.push(field)
        i += 1
      }
    } else if not field.named {
      let index = i + j
      optional-pos-fields.push(field)
      let get-field-code = "\n" + ```typ
    if pos.len() != 0 {
      value = pos.pop()
      result.insert("{f}", force-cast(value, typeinfo{n}, error-prefix: "field '{f}' of element '" + name + "': "))
    }
```.text.replace("{n}", str(n)).replace("{f}", escaped-name)

      parse-optional-pos-fields-with-required += get-field-code
      parse-optional-pos-fields-without-required += get-field-code
      j += 1
    } else {
      parse-non-required-named-fields += "\n" + ```typ
    if "{f}" in named {
      value = named.remove("{f}")
      result.insert("{f}", force-cast(value, typeinfo{n}, error-prefix: "field '{f}' of element '" + name + "': "))
    }
```.text.replace("{n}", str(n)).replace("{f}", escaped-name)
    }

    function-scope.insert("typeinfo" + str(n), field.typeinfo)
    all-fields.insert(field.name, field)

    n += 1
  }

  let check-for-missing-required-names = ""
  let check-for-present-required-names = ""

  if escaped-required-names != () {
    // "field1" not in named or "field2" not in named
    let conditional-escaped-required-names-not-present = escaped-required-names.map(f => f + " not in named").join(" or ")
    // "field1" in named or "field2" in named
    let conditional-escaped-required-names-present = escaped-required-names.map(f => f + " in named").join(" or ")

    check-for-missing-required-names = ```typ
      if {condition} {
        let missing-fields = required-named-names.filter(f => f not in named)
        let s = if missing-fields.len() == 1 { "" } else { "s" }

        assert(false, message: "element '" + name + "': missing required named field" + s + " " + missing-fields.map(f => "'" + f + "'").join(", "))
      }
  ```.text.replace("{condition}", conditional-escaped-required-names-not-present)

    check-for-present-required-names = ```typ
    if {condition} {
      let present-fields = required-named-names.filter(f => f in named)
      let s = if present-fields.len() == 1 { "" } else { "s" }
      let are = if present-fields.len() == 1 { "is" } else { "are" }

      assert(false, message: "element '" + name + "': the field" + s + " " + present-fields.map(f => "'" + f + "'").join(", ") + " " + are + " required and cannot be specified here")
    }
```.text.replace("{condition}", conditional-escaped-required-names-present)
  }

  let required-pos-fields-amount = required-pos-fields.len()
  let optional-pos-fields-amount = optional-pos-fields.len()
  let total-pos-fields-amount = required-pos-fields-amount + optional-pos-fields-amount
  let parse-function-required = ```typ
  (args) => {
    let pos = args.pos().rev()
    let named = args.named()
    let value = none
    let result = (:)

    if pos.len() < {required} {
      // Plural
      let s = if {required} - pos.len() == 1 { "" } else { "s" }

      assert(false, message: "element '" + name + "': missing positional field" + s + " " + required-pos-names.slice(pos.len()).map(f => "'" + f + "'").join(", "))
    }

    if pos.len() > {total} {
      assert(false, message: "element '" + name + "': too many positional arguments, expected {total}")
    }
```.text.replace("{required}", str(required-pos-fields-amount)).replace("{total}", str(total-pos-fields-amount))

  parse-function-required += "\n" + check-for-missing-required-names
  parse-function-required += "\n" + parse-required-pos-fields
  parse-function-required += "\n" + parse-optional-pos-fields-with-required
  parse-function-required += "\n" + parse-required-named-fields-with-required
  parse-function-required += "\n" + parse-non-required-named-fields

  parse-function-required += "\n" + ```typ
    if named != (:) {
      let field-name = named.keys().first()

      assert(false, message: "element '" + name + "': unknown named field '" + field-name + "'")
    }

    result
  }
```.text


  let parse-function-not-required = ```typ
  (args) => {
    let pos = args.pos().rev()
    let named = args.named()
    let value = none
    let result = (:)

    if pos.len() > {optional} {
      assert(false, message: "element '" + name + "': too many positional arguments, expected {optional}\nhint: only optional fields are accepted here")
    }
```.text.replace("{optional}", str(optional-pos-fields-amount))

  parse-function-not-required += "\n" + check-for-present-required-names
  parse-function-not-required += "\n" + parse-optional-pos-fields-without-required
  // Not needed: we check all at once
  // parse-function-not-required += "\n" + parse-required-named-fields-without-required
  parse-function-not-required += "\n" + parse-non-required-named-fields

  parse-function-not-required += "\n" + ```typ
    if named != (:) {
      let field-name = named.keys().first()

      assert(false, message: "element '" + name + "': unknown named field '" + field-name + "'")
    }

    result
  }
```.text

  // assert(false,  message: parse-function-required)
  // assert(false,  message: parse-function-not-required)

  function-scope += (
    required-pos-names: required-pos-fields.map(f => f.name),
    required-named-names: required-named-fields.map(f => f.name),
    force-cast: types.force-cast,
  )

  let parse-args-required = eval(parse-function-required, scope: function-scope)
  let parse-args-not-required = eval(parse-function-not-required, scope: function-scope)

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
