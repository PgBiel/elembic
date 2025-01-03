#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: element, field

#let (wock, wock-e) = element(
  "wock",
  it => {
    square(width: 6pt, fill: it.color)[#it.inner]
  },
  fields: (
    field("color", color, default: red),
    field("inner", content, default: [])
  )
)

#let w = wock(inner: [Updated])

#show: e.set_(wock-e, color: blue)
#show wock-e.sel: it => {
  let (body, fields) = e.decompose(it)
  assert.eq(fields.color, blue)
  assert.eq(fields.inner, [Updated])
}

#let (fields,) = e.decompose(w)
#assert("color" not in fields)
#assert.eq(fields.inner, [Updated])

#w
