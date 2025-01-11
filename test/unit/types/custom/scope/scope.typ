#let value = 50

#let do-math(a, b) = a + b

#import "/src/lib.typ" as e: field

#let subperson = e.types.declare(
  "subperson",
  fields: (
    field("name", str, required: true),
    field("age", int, required: true),
    field("border", stroke, default: 5pt),
  ),
  prefix: "mypkg"
)

#let subwock = e.element.declare(
  "subwock",
  display: it => {
    assert.eq(it.color, blue)
    assert.eq(it.inner, [Hello!])
  },
  fields: (
    field("color", color, default: red),
    field("inner", content, default: [Hello!])
  ),
  prefix: ""
)
