#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: field

#let wock = e.element.declare(
  "wock",
  display: it => {
    (it.run)(it)
  },
  fields: (
    field("color", color, default: red),
    field("inner", content, default: [Hello!]),
    field("run", function, default: () => {})
  ),
  count: c => c.update(t => t + 2),
  prefix: ""
)

#wock(run: it => {
  assert.eq(e.counter(wock).get().first(), 2)
})

#wock(run: it => {
  assert.eq(e.counter(wock).get().first(), 4)
})

#context assert.eq(e.counter(wock).get().first(), 4)
