#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: field, types

#show: e.stateful.enable()

#let wock = e.element.declare(
  "wock",
  display: it => {
    (it.run)(it)
  },
  fields: (
    field("color", color, default: red),
    field("inner", content, default: [Hello!]),
    field("run", function, default: panic),
  ),
  prefix: ""
)

#wock(run: it => assert.eq(it.color, red))

#show: e.stateful.set_(wock, color: blue)
#wock(run: it => assert.eq(it.color, blue))

#[
  #show: e.stateful.set_(wock, color: yellow)
  #wock(run: it => assert.eq(it.color, yellow))
]

#wock(run: it => assert.eq(it.color, blue))
