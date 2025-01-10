#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: field

#let wock = e.element.declare(
  "wock",
  display: it => {
    (it.run)(it)
  },
  fields: (
    field("level", int, default: 1),
    field("run", function, default: () => {})
  ),
  count: c => it => c.step(level: it.level),
  prefix: ""
)

#wock(run: it => {
  assert.eq(e.counter(wock).get(), (1,))
})
#wock(run: it => {
  assert.eq(e.counter(wock).get(), (2,))
})
#wock(level: 2, run: it => {
  assert.eq(e.counter(wock).get(), (2, 1))
})
#wock(level: 2, run: it => {
  assert.eq(e.counter(wock).get(), (2, 2))
})
#wock(level: 3, run: it => {
  assert.eq(e.counter(wock).get(), (2, 2, 1))
})

#context assert.eq(e.counter(wock).get(), (2, 2, 1))
