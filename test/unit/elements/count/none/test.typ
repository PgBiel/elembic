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
  count: none,
  prefix: ""
)

#wock(run: it => {
  assert.eq(e.counter(wock).get().first(), 0)
})

#wock(run: it => {
  assert.eq(e.counter(wock).get().first(), 0)
})

#context assert.eq(e.counter(wock).get().first(), 0)
