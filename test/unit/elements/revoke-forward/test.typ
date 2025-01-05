/// Ensure 'revoke' only affects names before it

#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: element, field, types

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

  #show: e.revoke("coolness")

  // This shouldn't be affected
  #show: e.named("coolness", e.set_(wock-e, color: cool-color))

  #(wock-e.get)(d => assert.eq(d.color, cool-color))
]

#[
  #let cool-color = luma(89)

  // This should be affected
  #show: e.named("before and after", e.set_(wock-e, size: 900))

  #show: e.revoke("before and after")

  // This shouldn't be affected
  #show: e.named("before and after", e.set_(wock-e, color: cool-color))

  #(wock-e.get)(d => assert.ne(d.size, 900))
  #(wock-e.get)(d => assert.eq(d.color, cool-color))
]
