#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: element, field, types

#show: e.stateful.toggle(true)

#let (wock, wock-e) = element(
  "wock",
  it => {
    (it.run)(it)
  },
  fields: (
    field("color", color, default: red),
    field("inner", content, default: [Hello!]),
    field("run", function, default: panic),
  )
)

#wock(run: it => assert.eq(it.color, red))

#show: e.stateful.set_(wock-e, color: blue)
#wock(run: it => assert.eq(it.color, blue))

#[
  #show: e.stateful.set_(wock-e, color: yellow)
  #wock(run: it => assert.eq(it.color, yellow))
]

#wock(run: it => assert.eq(it.color, blue))
