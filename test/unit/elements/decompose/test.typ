#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: field

#let wock = e.element.declare(
  "wock",
  display: it => {
    square(width: 6pt, fill: it.color)[#it.inner]
  },
  fields: (
    field("color", color, default: red),
    field("inner", content, default: [])
  )
)

#let w = wock(inner: [Updated])

#show: e.set_(wock, color: blue)
#show e.selector(wock): it => {
  let (body, fields) = e.data(it)
  assert.eq(fields.color, blue)
  assert.eq(fields.inner, [Updated])
}

#let (fields,) = e.data(w)
#assert("color" not in fields)
#assert.eq(fields.inner, [Updated])

#w
