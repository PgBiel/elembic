#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: field
#let wock = e.element.declare(
  "wock",
  display: it => {},
  fields: (
    field("run", function, doc: "What to run", required: true),
    field("color", color, doc: "The color", default: red),
    field("inner", content, doc: "Inner stuff", default: [Hello!]),
  ),
  prefix: ""
)

#wock(it => {
  assert.eq(it.color, red)
  assert.eq(it.inner, [Hello!])
})

#let wock-data = e.data(wock)
#assert.eq(wock-data.all-fields.run.doc, "What to run")
#assert.eq(wock-data.all-fields.color.doc, "The color")
#assert.eq(wock-data.all-fields.inner.doc, "Inner stuff")
