// Typst-native types.
#import "base.typ": type-key, base-typeinfo, ok, err

// Generic typeinfo for a native type.
// PROPERTY: if type key is native, then output has the native type,
// and input has a list of native types that can be cast to it.
#let generic-typeinfo(native-type) = {
  assert(type(native-type) == type(str), message: "internal error: not a type")

  (
    ..base-typeinfo,
    (type-key): "native",
    name: str(native-type),
    input: (native-type,),
    output: (native-type,),
    castable: x => type(x) == native-type,
    cast: x => x,
  )
}

// For native types which can be cast from others.
#let generic-typeinfo-multiple(native-type, cast: none, ..others) = {
  assert(others.named() == (:), message: "internal error: unexpected named arguments")
  assert(others.pos().all(x => type(x) == type(str)), message: "internal error: all other types should be types")
  assert(cast != none, message: "internal error: expected cast override")

  let others = others.pos()
  (
    ..generic-typeinfo(native-type),
    input: (native-type, ..others),
    castable: x => type(x) == native-type or type(x) in others,
    cast: cast
  )
}

#let content_ = generic-typeinfo-multiple(
  content,
  str,
  cast: x => [#x]
)

#let float_ = generic-typeinfo-multiple(
  float,
  int,
  cast: float,
)

#let str_ = generic-typeinfo(str)
#let bool_ = generic-typeinfo(bool)
#let array_ = generic-typeinfo(array)
#let dict_ = generic-typeinfo(dictionary)
#let int_ = generic-typeinfo(int)
#let color_ = generic-typeinfo(color)
#let gradient_ = generic-typeinfo(gradient)
#let datetime_ = generic-typeinfo(datetime)
#let duration_ = generic-typeinfo(duration)
#let function_ = generic-typeinfo(function)
#let type_ = generic-typeinfo(type)
#let none_ = generic-typeinfo(type(none))
#let auto_ = generic-typeinfo(type(auto))

// Return the typeinfo for a native type.
#let typeinfo(t) = {
  if t == content {
    ok(content_)
  } else if t == int {
    ok(int_)
  } else if t == bool {
    ok(bool_)
  } else if t == float {
    ok(float_)
  } else if t == type(none) {
    ok(none_)
  } else if t == type(auto) {
    ok(auto_)
  } else if t == dictionary {
    ok(dict_)
  } else if t == array {
    ok(array_)
  } else if t == str {
    ok(str_)
  } else if t == color {
    ok(color_)
  } else if t == gradient {
    ok(gradient_)
  } else if t == datetime {
    ok(datetime_)
  } else if t == duration {
    ok(duration_)
  } else if t == function {
    ok(function_)
  } else if t == type {
    ok(type_)
  } else {
    err("no preexisting typeinfo definition for type '" + str(t) + "', please use 'types.exact(type here)' instead to indicate it cannot be cast to.")
  }
}

// Return the default for a native type.
#let default(t) = {
  if t == type(0) {
    ok(0)
  } else if t == type("") {
    ok("")
  } else if t == type(1pt + black) {
    ok(1pt + black)
  } else if t == type(0pt) {
    ok(0pt)
  } else if t == type(0pt + 0%) {
    ok(0pt + 0%)
  } else if t == type(0%) {
    ok(0%)
  } else if t == type(none) {
    ok(none)
  } else if t == type(auto) {
    ok(auto)
  } else if t == type(0.0) {
    ok(0.0)
  } else if t == type(()) {
    ok(())
  } else if t == type((:)) {
    ok((:))
  } else if t == arguments {
    ok(arguments())
  } else if t == bytes {
    ok(bytes(()))
  } else if t == version {
    ok(version(0, 0, 0))
  } else if t == type([]) {
    ok([])
  } else {
    err("native type '" + str(t) + "' has no known default, please specify an explicit 'default: value' or set 'required: true' for the field.")
  }
}
