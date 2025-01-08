/// Test 'reset' usage

#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: field, types

#show: e.stateful.enable()

#let wock = e.element.declare(
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

#show: e.stateful.set_(wock, color: yellow)
#show: e.stateful.set_(wock, border: red + 2pt)

#e.get(get => assert.eq(get(wock).color, yellow))
#e.get(get => assert.eq(get(wock).border, red + 2pt))

#show: e.stateful.reset()

#e.get(get => assert.eq(get(wock).color, red))
#e.get(get => assert.eq(get(wock).border, black + 1pt))
