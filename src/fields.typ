#import "types/base.typ": type-key
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
    let (success, value) = types.cast(default, typeinfo)
    if not success {
      assert(false, message: error-prefix + value + "\n  hint: given default for field had an incompatible type")
    }

    value
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

// Generates an argument parser function with the given general error
// prefix (for listing missing fields) and per-field error prefix function
// (for an invalid field; receives the field name).
//
// Parse arguments into a dictionary of fields and their casted values.
// By default, include required arguments and error if they are missing.
// Setting 'include-required' to false will error if they are present
// instead.
#let generate-arg-parser(fields: none, general-error-prefix: "", field-error-prefix: _ => "") = {
  assert(type(fields) == dictionary and fields-key in fields, message: "generate-arg-parser: please use 'parse-fields' to generate the fields input.")
  assert(type(general-error-prefix) == str, message: "generate-arg-parser: 'general-error-prefix' must be a string")
  assert(type(field-error-prefix) == function, message: "generate-arg-parser: 'field-error-prefix' must be a function receiving field name and returning string")

  let (required-pos-fields, optional-pos-fields, required-named-fields, all-fields) = fields
  let required-pos-fields-amount = required-pos-fields.len()
  let optional-pos-fields-amount = optional-pos-fields.len()
  let total-pos-fields-amount = required-pos-fields-amount + optional-pos-fields-amount
  let all-pos-fields = required-pos-fields + optional-pos-fields

  let parse-args(args, include-required: true) = {
    let result = (:)

    let pos = args.pos()
    if include-required and pos.len() < required-pos-fields-amount {
      // Plural
      let s = if required-pos-fields-amount - pos.len() == 1 { "" } else { "s" }

      assert(false, message: general-error-prefix + "missing positional field" + s + " " + fields.required-pos-fields.slice(pos.len()).map(f => "'" + f.name + "'").join(", "))
    }

    let expected-arg-amount = if include-required { total-pos-fields-amount } else { optional-pos-fields-amount }

    if pos.len() > expected-arg-amount {
      let excluding-required-hint = if include-required { "" } else { "\nhint: only optional fields are accepted here" }
      assert(false, message: general-error-prefix + "too many positional arguments, expected " + str(expected-arg-amount) + excluding-required-hint)
    }

    let pos-fields = if include-required { all-pos-fields } else { optional-pos-fields }
    let i = 0
    for value in pos {
      let pos-field = pos-fields.at(i)
      let typeinfo = pos-field.typeinfo
      let kind = typeinfo.at(type-key)
      let casted = value

      if kind != "any" {
        if kind == "literal" {
          if value != typeinfo.data {
            assert(false, message: field-error-prefix(pos-field.name, name) + types.generate-cast-error(value, typeinfo))
          }
        } else {
          let value-type = type(value)
          if value-type == dictionary and custom-type-key in value {
            value-type = value.at(custom-type-key)
          }
          if (
            value-type not in typeinfo.input
            or typeinfo.check != none and not (typeinfo.check)(value)
          ) {
            assert(false, message: field-error-prefix(pos-field.name, name) + types.generate-cast-error(value, typeinfo))
          }

          if typeinfo.cast != none {
            casted = if kind == "native" and typeinfo.data == content {
              [#value]
            } else {
              (typeinfo.cast)(value)
            }
          }
        }
      }

      result.insert(pos-field.name, casted)

      i += 1
    }

    let named-args = args.named()

    for (field-name, value) in named-args {
      let field = all-fields.at(field-name, default: none)
      if field == none or not field.named {
        let expected-pos-hint = if field == none or field.named { "" } else { "\nhint: this field must be specified positionally" }

        assert(false, message: general-error-prefix + "unknown named field '" + field-name + "'" + expected-pos-hint)
      }

      if not include-required and field.required {
        assert(false, message: field-error-prefix(field-name, name) + "this field cannot be specified here\nhint: only optional fields are accepted here")
      }

      let typeinfo = field.typeinfo
      let kind = typeinfo.at(type-key)
      let casted = value

      if kind != "any" {
        if kind == "literal" {
          if value != typeinfo.data {
            assert(false, message: field-error-prefix(field-name, name) + types.generate-cast-error(value, typeinfo))
          }
        } else {
          let value-type = type(value)
          if value-type == dictionary and custom-type-key in value {
            value-type = value.at(custom-type-key)
          }
          if (
            value-type not in typeinfo.input
            or typeinfo.check != none and not (typeinfo.check)(value)
          ) {
            assert(false, message: field-error-prefix(field-name, name) + types.generate-cast-error(value, typeinfo))
          }

          if typeinfo.cast != none {
            casted = if kind == "native" and typeinfo.data == content {
              [#value]
            } else {
              (typeinfo.cast)(value)
            }
          }
        }
      }

      result.insert(field-name, casted)
    }

    if include-required {
      let missing-fields = required-named-fields.filter(f => f.name not in named-args)
      if missing-fields != () {
        let s = if missing-fields.len() == 1 { "" } else { "s" }

        assert(false, message: general-error-prefix + "missing required named field" + s + " " + missing-fields.map(f => "'" + f.name + "'").join(", "))
      }
    }

    result
  }

  parse-args
}
