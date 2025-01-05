// The type system used by fields.
#import "base.typ" as base: type-key, ok, err
#import "native.typ"

// The default value for a type.
#let default(type_) = {
  if type_.default == () {
    let prefix = if type_.at(type-key) in ("native", "union") { type_.at(type-key) + " " } else { "" }
    err(prefix + "type '" + type_.name + "' has no known default, please specify an explicit 'default: value' or set 'required: true' for the field")
  } else {
    ok(type_.default.first())
  }
}

// Literal type
// Only accepted if value is equal to the literal.
// Input and output are equal to the value.
//
// Uses base typeinfo information for information such as casts and whatnot.
#let literal(value) = {
  let type_ = base.typeof(value)
  let (res, typeinfo-or-err) = if type(type_) == type {
    native.typeinfo(type_)
  } else {
    // TODO: Custom types
    (true, type_)
  }
  assert(res, message: if not res { "types.literal: " + typeinfo-or-err } else { "" })

  base.literal(value, typeinfo-or-err)
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
    (false, "A function is not a valid type. (You can use 'types.literal(func)' to only accept a particular function.)")
  } else if type_ == none or type_ == auto {
    // Accept none or auto to mean their types
    native.typeinfo(type(type_))
  } else if type(type_) not in (dictionary, array, content) {
    // Automatically accept literals
    (true, literal(type_))
  } else {
    (false, "Received invalid type: " + repr(type_) + "\n  hint: use 'types.literal(value)' to indicate only that particular value is valid")
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
  } else {
    let value-type = type(value)
    if value-type == dictionary and base.custom-type-key in value {
      value-type = value.at(base.custom-type-key)
    }

    if kind == "literal" and typeinfo.cast == none {
      if value == typeinfo.data.value and value-type in typeinfo.input and (typeinfo.data.typeinfo.check == none or (typeinfo.data.typeinfo.check)(value)) {
        (true, value)
      } else {
        (false, generate-cast-error(value, typeinfo))
      }
    } else if (
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
  let (res, type_) = validate(type_)
  if not res {
    assert(false, message: "types.exact: " + type_)
  }

  let key = if type(type_) == dictionary { type_.at(type-key, default: none) } else { none }
  if key == "union" {
    // exact(union(A, B)) === union(exact(A), exact(B))
    union(..type_.data.map(exact))
  } else if type(type_) == type or key == "native" {
    // exact(float) => can only pass float, not int
    let native-type = if key == "native" { type_.data } else { type_ }
    (
      ..native.generic-typeinfo(native-type),
      default: if type_.default != () and type(type_.default.first()) == native-type { type_.default } else { () }
    )
  } else if key == "literal" {
    // exact(literal) => literal with base type modified to exact(base type)
    assert(type(type_.data.value) not in (dictionary, array), message: "types.exact: exact literal types for custom types, dictionaries and arrays are not supported\n  hint: consider customizing the check function to recursively check fields if the performance is acceptable")

    base.literal(type_.data.value, exact(type_.data.typeinfo))
  } else if key == "any" or key == "never" {
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
