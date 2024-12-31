// The type system used by fields.
#import "base.typ" as base: type-key, ok, err
#import "native.typ"

// The default value for a type.
#let default(type_) = {
  if type_.at(type-key) == "native" {
    let native-type = type_.input.at(0)
    native.default(native-type)
  } else if type_.at(type-key) == "union" {
    if type_.input.len() == 2 and native.none_ == type_.input.at(0) {
      // Default is 'none'
      return ok(none)
    }
    if type_.input.len() == 2 and native.auto_ == type_.input.at(0) {
      // Default is 'auto'
      return ok(auto)
    }

    err("union type '" + type_.name + "' has no known default, please specify an explicit 'default: value' or set 'required: true' for the field")
  } else {
    err("type '" + type_.name + "' has no known default, please specify an explicit 'default: value' or set 'required: true' for the field")
  }
}

// Obtain the typeinfo for a type.
//
// Returns ok(typeinfo), or err(error) if there is no corresponding typeinfo.
#let validate(type_) = {
  // TODO: Support custom elements
  if type(type_) == type {
    native.typeinfo(type_)
  } else if type(type_) == dictionary and type-key in type_ {
    ok(type_)
  } else if type(type_) == function {
    err("A function is not a valid type; maybe you meant to pass a custom element's structure instead.")
  } else {
    err("Received invalid type: " + repr(type_) + if type_ in (none, auto) { "\n(hint: write 'type(none)' or 'type(auto)' to only accept none or auto, respectively)" } else { "" })
  }
}

// Try to accept value via given typeinfo or throw
#let force-cast(value, typeinfo, error-prefix: "", hint: none) = {
  if (typeinfo.castable)(value) {
    (typeinfo.cast)(value)
  } else {
    let message = "expected " + if typeinfo.at(type-key) == "union" { typeinfo.input.map(t => t.name).join(", ", last: " or ") } else { typeinfo.name } + ", found " + base.type-name-of(value)
    let given-hint = if hint == none { "" } else { "\nhint: " + hint }

    assert(false, message: error-prefix + message + given-hint)
  }
}

// Specifies that any from a given selection of types is accepted.
#let union(..args) = {
  let types = args.pos()
  assert(types != (), message: "types.union: please specify at least one type")

  let typeinfos = types.map(type_ => {
    let (res, typeinfo-or-err) = validate(type_)
    assert(res, message: if not res { "types.union: " + typeinfo-or-err } else { "" })

    typeinfo-or-err
  })

  base.union(typeinfos)
}

// An optional type.
#let option(type_) = union(type(none), type_)

// A type which can be 'auto'.
#let smart(type_) = union(type(auto), type_)

// Force the type to only accept its outputs (disallow casting).
#let exact(type_) = {
  let key = if type(type_) == dictionary { type_.at(type-key, default: none) } else { none }
  if key == "union" {
    // exact(union(A, B)) === union(exact(A), exact(B))
    union(..type_.output.map(t => exact(t)))
  } else if type(type_) == type or key == "native" {
    // exact(float) => can only pass float, not int
    let native-type = if key == "native" { type_.output.first() } else { type_ }
    native.generic-typeinfo(native-type)
  } else if key == "literal" or key == "any" or key == "never" {
    // exact(literal) => literal (input == output)
    // exact(any) => any (same)
    // exact(never) => never (same)
    type_
  } else if key != none {
    // Unknown
    // TODO: Custom types / elements and the sort
    type_
  } else {
    panic("unexpected type '" + type(type_) + "', please provide an actual type")
  }
}