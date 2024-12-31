#let field-key = "__field"
#let fields-key = "__fields"
#let field-type-key = "__field_type"

#let current-field-version = 1

// A result to indicate success and return a value.
#let ok(value) = {
  (true, value)
}

// A result to indicate failure, with an error value indicating what happened.
#let err(error) = {
  (false, error)
}

// Whether this result was successful.
#let is-ok(result) = {
  type(result) == array and result.len() == 2 and result.first() == true
}

// Returns the value as 'ok' if it had the given type, otherwise returns 'err'
// (with 'none' by default).
#let type-assert(value, type_: none, error: none) = {
  if type(value) == type_ {
    ok(value)
  } else {
    err(error)
  }
}

// Returns the name of the value's type as a string.
#let type-name-of(value) = {
  // TODO: Custom element name
  str(type(value))
}

#let native-typeinfo(native-type) = {
  ok((
    (field-type-key): "native",
    version: current-field-version,
    original: native-type,
    name: str(native-type),
    accept: type-assert.with(type_: native-type, error: none)
  ))
}

#let default-for-type(type_) = {
  if type(type_.original) == type {
    let native-type = type_.original
    if native-type == type(0) {
      ok(0)
    } else if native-type == type("") {
      ok("")
    } else if native-type == type(1pt + black) {
      ok(1pt + black)
    } else if native-type == type(0pt) {
      ok(0pt)
    } else if native-type == type(0pt + 0%) {
      ok(0pt + 0%)
    } else if native-type == type(0%) {
      ok(0%)
    } else if native-type == type(none) {
      ok(none)
    } else if native-type == type(auto) {
      ok(auto)
    } else if native-type == type(0.0) {
      ok(0.0)
    } else if native-type == type(()) {
      ok(())
    } else if native-type == type((:)) {
      ok((:))
    } else if native-type == arguments {
      ok(arguments())
    } else if native-type == bytes {
      ok(bytes(()))
    } else if native-type == version {
      ok(version(0, 0, 0))
    } else if native-type == type([]) {
      ok([])
    } else {
      err("native type '" + type_.name + "' has no known default, please specify an explicit 'default: value' or set 'required: true' for the field.")
    }
  } else if type_.at(field-type-key) == "union" {
    if type_.original.len() == 2 and type(none) in type_.original {
      // Default is 'none'
      return ok(none)
    }
    if type_.original.len() == 2 and type(auto) in type_.original {
      // Default is 'auto'
      return ok(auto)
    }

    err("union type '" + type_.name + "' has no known default, please specify an explicit 'default: value' or set 'required: true' for the field.")
  } else {
    err("type '" + type_.name + "' has no known default, please specify an explicit 'default: value' or set 'required: true' for the field.")
  }
}

// Valid formats:
// 1. Native type
// 2. Typeinfo dictionary with
//    (
//       __field_type: "native" / "element" / "union",
//       version: 1,
//       original: none | type | element structure,
//       name: "type name",
//       accept: value => ok(parsed value) or err(error message)
//    )
//
// Returns ok(typeinfo), or err(error) if the cast failed.
#let validate-field-type(field-type, prefix: "") = {
  if prefix != "" {
    prefix += ": "
  }

  // TODO: Support custom elements
  if type(field-type) == function {
    err("A function is not a valid type; maybe you meant to pass a custom element's structure instead.")
  } else if type(field-type) != type and (type(field-type) != dictionary or field-type.at(field-type-key, default: none) == none) {
    err("Received invalid type: " + repr(field-type) + if field-type in (none, auto) { "\n(hint: write 'type(none)' or 'type(auto)' to only accept none or auto, respectively)" } else { "" })
  } else if type(field-type) == type {
    native-typeinfo(field-type)
  } else {
    ok(field-type)
  }
}

// Specifies that any from a given selection of types is accepted.
#let union(..args) = {
  let types = args.pos()
  assert(types != (), message: "fields.union: please specify at least one type")

  let typeinfos = types.map(type_ => {
    let (res, typeinfo-or-err) = validate-field-type(type_, prefix: "fields.union")
    assert(res, message: if not res { typeinfo-or-err } else { "" })

    typeinfo-or-err
  })

  let name = typeinfos.map(t => t.name).join(", ", last: " or ")

  (
    (field-type-key): "union",
    version: current-field-version,
    original: types,
    name: name,
    accept: value => {
      for typeinfo in typeinfos {
        let result = (typeinfo.accept)(value)
        if is-ok(result) {
          return ok(result.at(1))
        }
      }

      err(none)
    }
  )
}

// An optional type.
#let option(type_) = union(type(none), type_)

// A type which can be 'auto'.
#let smart(type_) = union(type(auto), type_)

// Try to accept value via given typeinfo or error
#let unwrap-type-accept(value, typeinfo, error-prefix: "", hint: none) = {
  let result = (typeinfo.accept)(value)

  if is-ok(result) {
    result.at(1)
  } else {
    let message = "expected " + typeinfo.name + ", found " + type-name-of(value)
    let given-hint = if hint == none { "" } else { "\nhint: " + hint }
    let typeinfos-hint = if type(result) == array and result.len() == 2 and type(result.at(1)) == str { "\nhint: " + result.at(1) } else { "" }

    assert(false, message: error-prefix + message + given-hint + typeinfos-hint)
  }
}

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
    let (res, value) = validate-field-type(type_, prefix: error-prefix)
    assert(res, message: if not res { error-prefix + value } else { "" })
    value
  }

  if not required and default == auto {
    let (res, value) = default-for-type(typeinfo)
    assert(res, message: if not res { error-prefix + value } else { "" })

    default = value
  }

  let accepted-default = if required {
    // This value should be ignored in that case
    auto
  } else {
    unwrap-type-accept(default, typeinfo, error-prefix: error-prefix, hint: "given default for field had an incompatible type")
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

#let parse-fields(fields) = {
  let required-pos-fields = ()
  let optional-pos-fields = ()
  let required-named-fields = ()
  let all-fields = (:)

  for field in fields {
    assert(type(field) == dictionary and field.at(field-key, default: none) == true, message: "element.fields: Invalid field received, please use the 'e.fields.field' constructor.")
    assert(field.named or not field.required or optional-pos-fields == (), message: "element.fields: field '" + field.name + "' cannot be positional and required and appear after other positional but optional fields. Ensure there are only optional fields after the first positional optional field.")
    assert(field.name not in all-fields, message: "element.fields: duplicate field name '" + field.name + "'")

    if field.required {
      if field.named {
        required-named-fields.push(field)
      } else {
        required-pos-fields.push(field)
      }
    } else if not field.named {
      optional-pos-fields.push(field)
    }

    all-fields.insert(field.name, field)
  }

  (
    (fields-key): true,
    version: current-field-version,
    required-pos-fields: required-pos-fields,
    optional-pos-fields: optional-pos-fields,
    required-named-fields: required-named-fields,
    all-fields: all-fields
  )
}
