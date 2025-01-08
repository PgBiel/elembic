/// Ensure 'revoke' only affects names before it

#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: element, field, types

#show: e.stateful.enable()

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

#[
  #let cool-color = luma(89)

  #show: e.stateful.revoke("coolness")

  // This shouldn't be affected
  #show: e.named("coolness", e.stateful.set_(wock, color: cool-color))

  #(wock-e.get)(d => assert.eq(d.color, cool-color))
]

#[
  #let cool-color = luma(89)

  // This should be affected
  #show: e.named("before and after", e.stateful.set_(wock, size: 900))

  #show: e.stateful.revoke("before and after")

  // This shouldn't be affected
  #show: e.named("before and after", e.stateful.set_(wock, color: cool-color))

  #(wock-e.get)(d => assert.ne(d.size, 900))
  #(wock-e.get)(d => assert.eq(d.color, cool-color))
]
