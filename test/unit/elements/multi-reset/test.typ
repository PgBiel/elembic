/// Reset with multiple elements, as well as filtering for a specific element

#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: element, field, types

#let (wibble, wibble-e) = element(
  "wibble",
  display: it => {
    rect(stroke: it.border, fill: it.color, height: 5pt, width: it.size * 0.05pt)
  },
  fields: (
    field("color", color, default: red),
    field("size", int, default: 100),
    field("border", types.exact(stroke), default: black + 1pt)
  )
)

#let (wobble, wobble-e) = element(
  "wobble",
  display: it => {
    rect(stroke: it.border, fill: it.color, height: 5pt, width: it.size * 0.05pt)
  },
  fields: (
    field("color", color, default: red),
    field("size", int, default: 100),
    field("border", types.exact(stroke), default: black + 1pt)
  )
)

#show: e.set_(wibble-e, color: yellow)
#show: e.set_(wobble-e, border: red + 2pt)

#(wibble-e.get)(d => assert.eq(d.color, yellow))
#(wobble-e.get)(d => assert.eq(d.border, red + 2pt))

#show: e.named("scary", e.reset())

#(wibble-e.get)(d => assert.eq(d.color, red))
#(wobble-e.get)(d => assert.eq(d.border, black + 1pt))

#show: e.revoke("scary")

#(wibble-e.get)(d => assert.eq(d.color, yellow))
#(wobble-e.get)(d => assert.eq(d.border, red + 2pt))

#show: e.reset(wobble-e)

#(wibble-e.get)(d => assert.eq(d.color, yellow))
#(wobble-e.get)(d => assert.eq(d.border, black + 1pt))
