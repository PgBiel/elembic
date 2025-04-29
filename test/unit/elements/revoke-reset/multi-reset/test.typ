/// Reset with multiple elements, as well as filtering for a specific element

#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: field, types

#let wibble = e.element.declare(
  "wibble",
  display: it => {
    rect(stroke: it.border, fill: it.color, height: 5pt, width: it.size * 0.05pt)
  },
  fields: (
    field("color", color, default: red),
    field("size", int, default: 100),
    field("border", types.exact(stroke), default: black + 1pt)
  ),
  prefix: ""
)

#let wobble = e.element.declare(
  "wobble",
  display: it => {
    rect(stroke: it.border, fill: it.color, height: 5pt, width: it.size * 0.05pt)
  },
  fields: (
    field("color", color, default: red),
    field("size", int, default: 100),
    field("border", types.exact(stroke), default: black + 1pt)
  ),
  prefix: ""
)

#show: e.set_(wibble, color: yellow)
#show: e.set_(wobble, border: red + 2pt)

#e.get(get => assert.eq(get(wibble).color, yellow))
#e.get(get => assert.eq(get(wobble).border, red + 2pt))

#show: e.named("scary", e.reset())

#e.get(get => assert.eq(get(wibble).color, red))
#e.get(get => assert.eq(get(wobble).border, black + 1pt))

#show: e.revoke("scary")

#e.get(get => assert.eq(get(wibble).color, yellow))
#e.get(get => assert.eq(get(wobble).border, red + 2pt))

#show: e.reset(wobble)

#e.get(get => assert.eq(get(wibble).color, yellow))
#e.get(get => assert.eq(get(wobble).border, black + 1pt))
