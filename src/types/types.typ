// The type system used by fields.
#import "base.typ" as base: type-key, ok, err
#import "native.typ"

// The default value for a type.
#let default(type_) = {
  if type_.at(type-key) == "native" {
    let native-type = type_.input.at(0)
    native.default(native-type)
  } else if type_.at(type-key) == "union" {
    if native.none_ == type_.data.at(0) {
      // Default is 'none'
      return ok(none)
    }
    if native.auto_ == type_.data.at(0) {
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
    (true, type_)
  } else if type(type_) == function {
    (false, "A function is not a valid type.")
  } else {
    (false, "Received invalid type: " + repr(type_) + if type_ in (none, auto) { "\n(hint: write 'type(none)' or 'type(auto)' to only accept none or auto, respectively)" } else { "" })
  }
}

// Error when a value doesn't conform to a certain cast
#let generate-cast-error(value, typeinfo, hint: none) = {
  let message = if base.typeof(value) not in typeinfo.input {
    (
      "expected "
      + typeinfo.input.map(t => if type(t) == dictionary and type-key in t { t.name } else { str(t) }).join(", ", last: " or ")
      + ", found "
      + base.type-name-of(value)
    )
  } else if typeinfo.at("error", default: none) != none {
    (typeinfo.error)(value)
  } else {
    "typecheck for " + typeinfo.name + " failed"
  }
  let given-hint = if hint == none { "" } else { "\n  hint: " + hint }

  message + given-hint
}

// Try to accept value via given typeinfo or return error
// Returns ok(value) a.k.a. (true, value) on success
// Returns err(value) a.k.a. (false, value) on error
#let cast(value, typeinfo) = {
  let kind = typeinfo.at(type-key)
  if kind == "any" {
    (true, value)
  } else if kind == "literal" {
    if value == typeinfo.data {
      (true, value)
    } else {
      (false, generate-cast-error(value, typeinfo))
    }
  } else {
    let value-type = type(value)
    if value-type == dictionary and base.custom-type-key in value {
      value-type = value.at(base.custom-type-key)
    }

    if (
      value-type not in typeinfo.input
      or typeinfo.check != none and not (typeinfo.check)(value)
    ) {
      (false, generate-cast-error(value, typeinfo))
    } else if typeinfo.cast == none {
      (true, value)
    } else if kind == "native" and typeinfo.data == content {
      (true, [#value])
    } else {
      (true, (typeinfo.cast)(value))
    }
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

// An optional type (can be 'none').
#let option(type_) = union(type(none), type_)

// A type which can be 'auto'.
#let smart(type_) = union(type(auto), type_)

// Force the type to only accept its outputs (disallow casting).
// Also disables folding.
#let exact(type_) = {
  let key = if type(type_) == dictionary { type_.at(type-key, default: none) } else { none }
  if key == "union" {
    // exact(union(A, B)) === union(exact(A), exact(B))
    union(..type_.data.map(exact))
  } else if type(type_) == type or key == "native" {
    // exact(float) => can only pass float, not int
    let native-type = if key == "native" { type_.data } else { type_ }
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
    panic("unexpected type '" + str(type(type_)) + "', please provide an actual type")
  }
}
