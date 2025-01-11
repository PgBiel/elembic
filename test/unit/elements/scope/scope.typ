#let value = 50

#let do-math(a, b) = a + b

#import "/src/lib.typ" as e: field

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
