// The shared fundamentals of the type system.
#let type-key = "__type"
#let type-version = 1

// Typeinfo structure:
// - type-key: kind of type
// - version: 1
// - name: type name
// - input: list of type names
#let base-typeinfo = (
  (type-key): "base",
  version: type-version,
)

// Top type
// input and output have "any".
#let any = (
  ..base-typeinfo,
  (type-key): "any",
  name: "any",
  input: ("any",),
  output: ("any",),
  castable: _ => true,
  cast: x => x
)

// Bottom type
// input and output are empty.
#let never = (
  ..base-typeinfo,
  (type-key): "never",
  name: "never",
  input: (),
  output: (),
  castable: _ => false,
  cast: x => panic("cannot cast to 'never'")
)

// Literal type
// Only accepted if value is equal to the literal.
#let literal(value) = {
  let represented = "'" + if type(value) == str { value } else { repr(value) } + "'"

  (
    ..base-typeinfo,
    (type-key): "literal",
    name: "literal " + represented,
    input: (represented,),
    output: (represented,),
    castable: x => x == value,
    cast: x => x,
  )
}

// Union type (one of many)
// Accepted if the value corresponds to one of the given types.
// Does not check the validity of typeinfos.
#let union(typeinfos) = {
  let name = typeinfos.map(t => t.name).join(", ", last: " or ")
  // Flatten nested unions
  let input = typeinfos.map(t => if t.at(type-key) == "union" { t.inputs } else { (t,) }).sum(default: ()).dedup()
  let casts = input.map(t => (t.castable, t.cast))

  (
    ..base-typeinfo,
    (type-key): "union",
    name: name,
    input: input,
    output: input,
    castable: x => casts.any(((castable, _)) => castable(x)),
    cast: value => {
      for (castable, cast) in casts {
        if castable(value) {
          return cast(value)
        }
      }
      panic("expected value to be castable")
    }
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
