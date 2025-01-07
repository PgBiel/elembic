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
// - default: empty array (no default) or singleton array => default value for this type
// - fold: none, auto (equivalent to (a, b) => a + b but more efficient) or function (prev, next) => folded value:
//         determines how to combine two consecutive values of this type in the stylechain
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
  default: (),
  fold: none,
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
//
// Uses base typeinfo information for information such as casts and whatnot.
#let literal(value, typeinfo) = {
  let represented = "'" + if type(value) == str { value } else { repr(value) } + "'"
  let value-type = typeof(value)

  let check = if typeinfo.check == none { x => x == value } else { x => x == value and (typeinfo.check)(x) }

  (
    ..typeinfo,
    (type-key): "literal",
    name: "literal " + represented,
    data: (value: value, typeinfo: typeinfo, represented: represented),
    check: check,
    error: _ => "given value wasn't equal to literal " + represented,
    default: (value,),
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
  let check = if typeinfos.all(t => t.check == none) {
    // If there are no checks, just checking inputs is enough
    none
  } else {
    let checked-types = typeinfos.filter(t => t.check != none)
    let unchecked-inputs = typeinfos.filter(t => t.check == none).map(t => t.input).sum(default: ()).dedup()
    if input.all(t => t in unchecked-inputs) {
      // Unchecked types include all possible input types, so some check will always succeed
      none
    } else if checked-types.all(t => t.at(type-key) == "literal") {
      let values-inputs-and-checks = checked-types.map(t => (t.data.value, t.input, t.data.typeinfo.check))
      x => {
        let typ = type(x)
        if typ == dictionary and custom-type-key in typ {
          // Custom type must be checked differently in inputs
          typ = typ.at(custom-type-key)
        }
        typ in unchecked-inputs or values-inputs-and-checks.any(((v, i, check)) => typ in i and x == v and (check == none or check(x)))
      }
    } else {
      // If any check succeeds and the value has the correct input type, OK
      let checks-and-inputs = checked-types.map(t => (t.input, t.check))
      x => {
        let typ = type(x)
        if typ == dictionary and custom-type-key in typ {
          // Custom type must be checked differently in inputs
          typ = typ.at(custom-type-key)
        }
        // If one of the types without checks accepts this type as an input then we don't need
        // to run any checks!
        typ in unchecked-inputs or checks-and-inputs.any(((inp, check)) => typ in inp and check(x))
      }
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
      casting-types != ()
      and casting-types.all(t => t.at(type-key) == "native" and t.data in (float, content))
      and typeinfos.find(t => t.input.any(i => i in first-casting-type.input)) == first-casting-type
      and (casting-types.len() == 1 or typeinfos.find(t => t.input.any(i => i in casting-types.at(1).input)) == casting-types.at(1))
    ) {
      if casting-types.len() >= 2 {  // just float and content
        x => if type(x) == int { float(x) } else if type(x) in (str, symbol) [#x] else { x }
      } else if first-casting-type.data == float {  // just float
        x => if type(x) == int { float(x) } else { x }
      } else { // just content
        x => if type(x) in (str, symbol) { [#x] } else { x }
      }
    } else {
      // Generic case
      x => {
        let typ = type(x)
        if typ == dictionary and custom-type-key in typ {
          // Custom type must be checked differently in inputs
          typ = typ.at(custom-type-key)
        }
        let typeinfo = typeinfos.find(t => typ in t.input and (t.check == none or (t.check)(x)))
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
  } else if typeinfos.all(t => t.at(type-key) == "literal") {
    let literals = typeinfos.map(t => str(t.data.represented)).join(", ", last: " or ")
    let message = "given value wasn't equal to literals " + literals
    x => message
  } else {
    let error-types = typeinfos.filter(t => t.error != none)
    x => {
      "all typechecks for union failed" + error-types.map(t => "\n  hint (" + t.name + "): " + (t.error)(x)).sum(default: "")
    }
  }

  let is-option = typeinfos.first().at(type-key) == "native" and typeinfos.first().data == type(none)
  let is-smart = typeinfos.first().at(type-key) == "native" and typeinfos.first().data == type(auto)

  let default = if is-option or is-smart {
    // Default of 'none' for option(...)
    // Default of 'auto' for smart(...)
    typeinfos.first().default
  } else {
    ()
  }

  // Match built-in behavior by only folding option(T) or smart(T) if T can fold and the inner isn't explicitly none/auto
  let fold = if typeinfos.len() == 2 and typeinfos.at(1).fold != none {
    let other-typeinfo = typeinfos.at(1)
    let other-fold = other-typeinfo.fold
    if is-option {
      if other-fold == auto {
        (outer, inner) => if inner != none and outer != none { outer + inner } else { inner }
      } else {
        (outer, inner) => if inner != none and outer != none { other-fold(outer, inner) } else { inner }
      }
    } else if is-smart {
      if other-fold == auto {
        (outer, inner) => if inner != auto and outer != auto { outer + inner } else { inner }
      } else {
        (outer, inner) => if inner != auto and outer != auto { other-fold(outer, inner) } else { inner }
      }
    } else {
      none
    }
  } else {
    // TODO: We could consider folding an arbitrary union iff the outputs are all disjoint,
    // so we can easily distinguish the typeinfo for an output based on the type.
    // Otherwise, can't do much if e.g. an int could be typeinfo A (say, positive integer)
    // or typeinfo B (say, negative integer) because checks apply to inputs and not outputs
    // (unless, of course, there is no casting).
    none
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
    error: error,
    default: default,
    fold: fold,
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

// Wrap a typeinfo with some other data.
// Mostly unchecked variant of 'types.wrap'.
#let wrap(typeinfo, overrides) = {
  (
    (..typeinfo, (type-key): "wrapped", data: (base: typeinfo, extra: none))
    + for (key, default) in base-typeinfo {
      if key == type-key {
        continue
      }

      if key in overrides {
        let override = overrides.at(key)
        if type(override) == function {
          override = override(typeinfo.at(key, default: default))
        }

        if key == "data" {
          (data: (base: typeinfo, extra: override))
        } else {
          ((key): override)
        }
      }
    }
  )
}

// A particular collection of types.
#let collection(name, base, parameters, check: none, cast: none, error: none, ..args) = {
  if check == none {
    check = base.check
  }

  if cast == none {
    cast = base.cast
  }

  if check == none and error == none {
    error = base.error
  }

  let other-args = args.named()
  let default = if "default" in other-args {
    other-args.default
  } else {
    base.default
  }

  (
    ..base,
    (type-key): "collection",
    name: name + if parameters != () { " of " + parameters.map(t => t.name).join(", ", last: " and ") },
    data: (base: base, parameters: parameters),
    check: check,
    cast: cast,
    error: error,
    default: default,
  )
}

// Returns the name of the value's type as a string.
#let type-name-of(value) = {
  // TODO: Custom element name
  str(type(value))
}
