#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: field

#let wock = e.element.declare(
  "wock",
  display: it => {
    (it.run)(it)
  },
  fields: (
    field("depth", int, default: 1),
    field("offset", int, default: 0),
    field("run", function, default: () => {})
  ),
  synthesize: it => {
    it.level = it.depth + it.offset
    it
  },
  count: c => it => c.step(level: it.level),
  prefix: ""
)

#wock(run: it => {
  assert.eq(e.counter(wock).get(), (1,))
})
#wock(run: it => {
  assert.eq(e.counter(wock).get(), (2,))
})
#wock(depth: 2, run: it => {
  assert.eq(e.counter(wock).get(), (2, 1))
})
#wock(offset: 1, run: it => {
  assert.eq(e.counter(wock).get(), (2, 2))
})
#wock(depth: 2, offset: 1, run: it => {
  assert.eq(e.counter(wock).get(), (2, 2, 1))
})

#context assert.eq(e.counter(wock).get(), (2, 2, 1))
