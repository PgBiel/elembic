/// Ensure we can revoke a reset

#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: element, field, types

#let (wock, wock-e) = element(
  "wock",
  it => {
    rect(stroke: it.border, fill: it.color, height: 5pt, width: it.size * 0.05pt)
  },
  fields: (
    field("color", color, default: red),
    field("size", int, default: 100),
    field("border", types.exact(stroke), default: black + 1pt)
  )
)

#show: e.set_(wock-e, color: yellow)
#show: e.set_(wock-e, border: red + 2pt)

#(wock-e.get)(d => assert.eq(d.color, yellow))
#(wock-e.get)(d => assert.eq(d.border, red + 2pt))

#show: e.named("scary", e.reset())

#(wock-e.get)(d => assert.eq(d.color, red))
#(wock-e.get)(d => assert.eq(d.border, black + 1pt))

#show: e.named("house", e.revoke("scary"))

#(wock-e.get)(d => assert.eq(d.color, yellow))
#(wock-e.get)(d => assert.eq(d.border, red + 2pt))

#show: e.revoke("house")

#(wock-e.get)(d => assert.eq(d.color, red))
#(wock-e.get)(d => assert.eq(d.border, black + 1pt))
