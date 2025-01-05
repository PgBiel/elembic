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

#let (dock, dock-e) = element(
  "dock",
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
  #show: e.named("coolness", e.set_(wock-e, color: cool-color))
  #show: e.named("docks", e.set_(dock-e, color: cool-color))
  #show: e.named("datums", e.apply(
    e.set_(wock-e, border: blue + 2pt),
    e.set_(dock-e, size: 300)
  ))

  #(wock-e.get)(w => assert.eq(w.color, cool-color))
  #(dock-e.get)(d => assert.eq(d.color, cool-color))
  #(wock-e.get)(w => assert.eq(w.border, blue + 2pt))
  #(dock-e.get)(d => assert.eq(d.size, 300))

  #show: e.revoke("coolness")

  // First color change revoked
  #(wock-e.get)(w => assert.ne(w.color, cool-color))
  #(dock-e.get)(d => assert.eq(d.color, cool-color))
  #(wock-e.get)(w => assert.eq(w.border, blue + 2pt))
  #(dock-e.get)(d => assert.eq(d.size, 300))

  #show: e.revoke("datums")

  // Other changes also revoked **to both elements**,
  // except the second color change
  #(wock-e.get)(w => assert.ne(w.color, cool-color))
  #(dock-e.get)(d => assert.eq(d.color, cool-color))
  #(wock-e.get)(w => assert.ne(w.border, blue + 2pt))
  #(dock-e.get)(d => assert.ne(d.size, 300))

  #show: e.revoke("docks")

  // Second color change also revoked now
  #(wock-e.get)(w => assert.ne(w.color, cool-color))
  #(dock-e.get)(d => assert.ne(d.color, cool-color))
  #(wock-e.get)(w => assert.ne(w.border, blue + 2pt))
  #(dock-e.get)(d => assert.ne(d.size, 300))
]
