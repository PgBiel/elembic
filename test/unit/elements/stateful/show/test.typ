#import "/test/unit/base.typ": template
#show: template

#import "/src/lib.typ" as e: element, field

#show: e.stateful.enable()

#let (wock, wock-e) = element(
  "wock",
  display: it => {
    square(width: 6pt, fill: it.color)[#it.inner]
  },
  fields: (
    field("color", color, default: red),
    field("inner", content, default: [])
  )
)

#show wock-e.sel: it => {
  let (body, fields) = e.data(it)
  assert.eq(fields.color, red)
  assert.eq(fields.inner, [Updated])
  circle(radius: 3pt, fill: fields.color)
}
#wock(inner: [Updated])
