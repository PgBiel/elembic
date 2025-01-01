// Typst-native types.
#import "base.typ": type-key, base-typeinfo, ok, err

#let native-base = (
  ..base-typeinfo,
  (type-key): "native",
  cast: x => x,
)

// Generic typeinfo for a native type.
// PROPERTY: if type key is native, then output has the native type,
// and input has a list of native types that can be cast to it.
#let generic-typeinfo(native-type) = {
  assert(type(native-type) == type(str), message: "internal error: not a type")

  (
    ..native-base,
    name: str(native-type),
    input: (native-type,),
    output: (native-type,),
    castable: x => type(x) == native-type,
  )
}

// Castable types

#let content_ = (
  ..native-base,
  name: str(content),
  input: (content, str),
  output: (content,),
  castable: x => type(x) == str or type(x) == content,
  cast: x => [#x],
)
#let float_ = (
  ..native-base,
  name: str(float),
  input: (float, int),
  output: (float,),
  castable: x => type(x) == float or type(x) == int,
  cast: float,
)

// Simples types (no casting)

#let str_ = (
  ..native-base,
  name: str(str),
  input: (str,),
  output: (str,),
  castable: x => type(x) == str,
)
#let bool_ = (
  ..native-base,
  name: str(bool),
  input: (bool,),
  output: (bool,),
  castable: x => type(x) == bool,
)
#let array_ = (
  ..native-base,
  name: str(array),
  input: (array,),
  output: (array,),
  castable: x => type(x) == array,
)
#let dict_ = (
  ..native-base,
  name: str(dictionary),
  input: (dictionary,),
  output: (dictionary,),
  castable: x => type(x) == dictionary,
)
#let int_ = (
  ..native-base,
  name: str(int),
  input: (int,),
  output: (int,),
  castable: x => type(x) == int,
)
#let color_ = (
  ..native-base,
  name: str(color),
  input: (color,),
  output: (color,),
  castable: x => type(x) == color,
)
#let gradient_ = (
  ..native-base,
  name: str(gradient),
  input: (gradient,),
  output: (gradient,),
  castable: x => type(x) == gradient,
)
#let datetime_ = (
  ..native-base,
  name: str(datetime),
  input: (datetime,),
  output: (datetime,),
  castable: x => type(x) == datetime,
)
#let duration_ = (
  ..native-base,
  name: str(duration),
  input: (duration,),
  output: (duration,),
  castable: x => type(x) == duration,
)
#let function_ = (
  ..native-base,
  name: str(function),
  input: (function,),
  output: (function,),
  castable: x => type(x) == function,
)
#let type_ = (
  ..native-base,
  name: str(type),
  input: (type,),
  output: (type,),
  castable: x => type(x) == type,
)

// None / auto

#let none_ = (
  ..native-base,
  name: "none",
  input: (type(none),),
  output: (type(none),),
  castable: x => x == none,
)
#let auto_ = (
  ..native-base,
  name: "auto",
  input: (type(auto),),
  output: (type(auto),),
  castable: x => x == auto,
)

// Return the typeinfo for a native type.
#let typeinfo(t) = {
  let out = if t == content {
    content_
  } else if t == int {
    int_
  } else if t == bool {
    bool_
  } else if t == float {
    float_
  } else if t == type(none) {
    none_
  } else if t == type(auto) {
    auto_
  } else if t == dictionary {
    dict_
  } else if t == array {
    array_
  } else if t == str {
    str_
  } else if t == color {
    color_
  } else if t == gradient {
    gradient_
  } else if t == datetime {
    datetime_
  } else if t == duration {
    duration_
  } else if t == function {
    function_
  } else if t == type {
    type_
  } else {
    return (false, "no preexisting typeinfo definition for type '" + str(t) + "', please use 'types.exact(type here)' instead to indicate it cannot be cast to.")
  }

  (true, out)
}

// Return the default for a native type.
#let default(t) = {
  let out = if t == type(0) {
    0
  } else if t == type("") {
    ""
  } else if t == type(1pt + black) {
    1pt + black
  } else if t == type(0pt) {
    0pt
  } else if t == type(0pt + 0%) {
    0pt + 0%
  } else if t == type(0%) {
    0%
  } else if t == type(none) {
    none
  } else if t == type(auto) {
    auto
  } else if t == type(0.0) {
    0.0
  } else if t == type(()) {
    ()
  } else if t == type((:)) {
    (:)
  } else if t == arguments {
    arguments()
  } else if t == bytes {
    bytes(())
  } else if t == version {
    version(0, 0, 0)
  } else if t == type([]) {
    []
  } else {
    return (false, "native type '" + str(t) + "' has no known default, please specify an explicit 'default: value' or set 'required: true' for the field.")
  }

  (true, out)
}
