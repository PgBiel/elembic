#import "types/types.typ"

#let field-key = "__field"
#let fields-key = "__fields"

#let current-field-version = 1

#let _missing() = {}

// Specifies an element field's properties.
#let field(
  name,
  type_,
  required: false,
  named: auto,
  default: _missing,
) = {
  assert(type(name) == str, message: "field: Field name must be a string, not " + str(type(name)))

  let error-prefix = "field '" + name + "': "
  assert(type(required) == bool, message: error-prefix + "'required' must be a boolean")
  assert(named == auto or type(named) == bool, message: error-prefix + "'named' must be a boolean or auto")
  let typeinfo = {
    let (res, value) = types.validate(type_)
    assert(res, message: if not res { error-prefix + value } else { "" })
    value
  }

  if not required and default == _missing {
    let (res, value) = types.default(typeinfo)
    assert(res, message: if not res { error-prefix + value } else { "" })

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
