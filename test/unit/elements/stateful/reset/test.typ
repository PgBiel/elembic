/// Test 'reset' usage

#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: element, field, types

#show: e.stateful.toggle(true)

#let (wock, wock-e) = element(
  "wock",
  display: it => {
    rect(stroke: it.border, fill: it.color, height: 5pt, width: it.size * 0.05pt)
  },
  fields: (
    field("color", color, default: red),
    field("size", int, default: 100),
    field("border", types.exact(stroke), default: black + 1pt)
  )
)

#show: e.stateful.set_(wock-e, color: yellow)
#show: e.stateful.set_(wock-e, border: red + 2pt)

#(wock-e.get)(d => assert.eq(d.color, yellow))
#(wock-e.get)(d => assert.eq(d.border, red + 2pt))

#show: e.stateful.reset()

#(wock-e.get)(d => assert.eq(d.color, red))
#(wock-e.get)(d => assert.eq(d.border, black + 1pt))
