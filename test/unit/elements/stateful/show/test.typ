#import "/test/unit/base.typ": template
#show: template

#import "/src/lib.typ" as e: element, field

#show: e.stateful.toggle(true)

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

#show wock-e.sel: it => {
  let (body, fields) = e.decompose(it)
  assert.eq(fields.color, red)
  assert.eq(fields.inner, [Updated])
  circle(radius: 3pt, fill: fields.color)
}
#wock(inner: [Updated])
