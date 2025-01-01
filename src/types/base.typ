// The shared fundamentals of the type system.
#let type-key = "__type"
#let type-version = 1

// To be used by any custom types in the future
#let custom-type-key = "__custom_type"

// Typeinfo structure:
// - type-key: kind of type
// - version: 1
// - name: type name
// - input: list of native types / custom types of input
// - output: list of native types / custom types of output
// - data: data specific for this type key
// - check: none (only check inputs) or function x => bool
// - cast: none (input is unchanged) or function to convert input to output
// - error: none or function x => string to customize check failure message
#let base-typeinfo = (
  (type-key): "base",
  version: type-version,
  name: "unknown",
  input: (),
  output: (),
  data: none,
  check: none,
  cast: none,
  error: none,
)

// Top type
// input and output have "any".
#let any = (
  ..base-typeinfo,
  (type-key): "any",
  name: "any",
  input: ("any",),
  output: ("any",),
)

// Bottom type
// input and output are empty.
#let never = (
  ..base-typeinfo,
  (type-key): "never",
  name: "never",
  input: (),
  output: (),
)

// Get the type of a value.
// This is usually 'type(value)', unless value has a custom type.
#let typeof(value) = {
  let value-type = type(value)
  if value-type == dictionary and custom-type-key in value {
    value-type = value.at(custom-type-key)
  }
  value-type
}

// Literal type
// Only accepted if value is equal to the literal.
// Input and output are equal to the value.
#let literal(value) = {
  let represented = "'" + if type(value) == str { value } else { repr(value) } + "'"
  let value-type = typeof(value)

  (
    ..base-typeinfo,
    (type-key): "literal",
    name: "literal " + represented,
    input: (value-type,),
    output: (value-type,),
    data: value,
    check: x => x == value,
    error: _ => "given value wasn't equal to literal '" + repr(value) + "'"
  )
}

// Union type (one of many)
// Data is the list of typeinfos.
// Accepted if the value corresponds to one of the given types.
// Does not check the validity of typeinfos.
#let union(typeinfos) = {
  // Flatten nested unions
  let typeinfos = typeinfos.map(t => if t.at(type-key) == "union" { t.data } else { (t,) }).sum(default: ()).dedup()
  if typeinfos == () {
    // No inputs accepted...
    return never
  }
  if typeinfos.len() == 1 {
    // Simplify union if there's nothing else
    return typeinfos.first()
  }
  if typeinfos.any(x => x.at(type-key) == "any") {
    // Union with 'any' is just any
    return any
  }

  let name = typeinfos.map(t => t.name).join(", ", last: " or ")
  let input = typeinfos.map(t => t.input).sum(default: ()).dedup()
  let output = typeinfos.map(t => t.output).sum(default: ()).dedup()

  // Try to optimize checks as much as possible
  let check = if typeinfos.any(t => t.check == none) {
    // If any type has no checks, then conversion will always succeed somehow
    none
  } else {
    let checked-types = typeinfos.filter(t => t.check != none)
    if checked-types.all(t => t.at(type-key) == "literal") {
      let values = checked-types.map(t => t.data)
      x => x in values
    } else {
      // If any check succeeds, OK
      let checks = checked-types.map(t => t.check)
      x => checks.any(check => check(x))
    }
  }

  // Try to optimize casts
  let cast = if typeinfos.all(t => t.cast == none) {
    none
  } else {
    let casting-types = typeinfos.filter(t => t.cast != none)
    let first-casting-type = casting-types.first()
    if (
      // If the casting types are all native, and none of the types before them
      // accept their "cast-from" types, then we can fast track to a simple check:
      // if within the 'cast-from' types, then cast, otherwise don't.
      casting-types.all(t => t.at(type-key) == "native" and t.data in (float, content))
      and typeinfos.find(t => t.input.any(i => i in first-casting-type.input)) == first-casting-type
      and casting-types.len() == 1 or typeinfos.find(t => t.input.any(i => i in casting-types.at(1).input)) == casting-types.at(1)
    ) {
      if casting-types.len() >= 2 {  // just float and content
        x => if type(x) == int { float(x) } else if type(x) == str [#x] else { x }
      } else if first-casting-type.data == float {  // just float
        x => if type(x) == int { float(x) } else { x }
      } else { // just content
        x => if type(x) == str { [#x] } else { x }
      }
    } else {
      // Generic case
      x => {
        let typ = type(x)
        if typ == dictionary and custom-type-key in typ {
          // Custom type must be checked differently in inputs
          typ = typ.at(custom-type-key)
        }
        let typeinfo = typeinfos.find(t => typ in t.input and t.check == none or (t.check)(x))
        if typeinfo.cast == none {
          x
        } else {
          (typeinfo.cast)(x)
        }
      }
    }
  }

  let error = if typeinfos.all(t => t.error == none) {
    none
  } else {
    let error-types = typeinfos.filter(t => t.error != none)
    x => {
      "all typechecks for union failed" + error-types.map(t => "\n  hint (" + t.name + "): " + (t.error)(x)).sum(default: "")
    }
  }

  (
    ..base-typeinfo,
    (type-key): "union",
    name: name,
    data: typeinfos,
    input: input,
    output: output,
    check: check,
    cast: cast,
    error: error
  )
}

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

// Returns the name of the value's type as a string.
#let type-name-of(value) = {
  // TODO: Custom element name
  str(type(value))
}
