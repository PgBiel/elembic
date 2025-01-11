#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: types, field

#let missing() = {}
#let std-color = color
#let boxed-parser-req(value, color: missing, inner: missing, some-extra-thing: missing) = {
  let res = (:)
  if value != missing {
    assert(type(value) == int, message: "field 'value' of type 'boxed': must be int, got " + e.types.typename(value))
    res.value = value
  }
  if color != missing {
    assert(type(color) == std-color, message: "field 'color' of type 'boxed': color must be a color, got " + e.types.typename(color))
    res.color = color
  }
  if inner != missing {
    assert(type(inner) in (str, content, type(none)), message: "field 'inner' of type 'boxed': must be content, got " + e.types.typename(inner))
    res.inner = [#inner]
  }
  if some-extra-thing != missing {
    res.some-extra-thing = 10
  }

  res
}
#let boxed-parser-not-req(color: missing, inner: missing, some-extra-thing: missing) = {
  boxed-parser-req(missing, color: color, inner: inner, some-extra-thing: some-extra-thing)
}

#let boxed = types.declare(
  "boxed",
  fields: (
    field("value", int, required: true),
    field("color", color, default: red),
    field("inner", content, default: [Hello!]),
  ),
  parse-args: (args, include-required: false) => {
    if include-required {
      boxed-parser-req(..args)
    } else {
      boxed-parser-not-req(..args)
    }
  },
  prefix: "mypkg"
)

#assert.eq(e.fields(boxed(100)), (value: 100, color: red, inner: [Hello!]))
#assert.eq(e.fields(boxed(100, color: blue)), (value: 100, color: blue, inner: [Hello!]))
#assert.eq(e.fields(boxed(100, color: blue, inner: "a")), (value: 100, color: blue, inner: [a]))
#assert.eq(e.fields(boxed(100, color: blue, inner: "a", some-extra-thing: 900)), (value: 100, color: blue, inner: [a], some-extra-thing: 10))
