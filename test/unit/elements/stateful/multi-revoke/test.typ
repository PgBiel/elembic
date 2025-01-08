#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: element, field, types
#import "/src/element.typ" as elos

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
  #show: e.named("coolness", e.stateful.set_(wock, color: cool-color))
  #show: e.named("docks", e.stateful.set_(dock, color: cool-color))
  #show: e.named("datums", e.stateful.apply(
    e.stateful.set_(wock, border: blue + 2pt),
    e.stateful.set_(dock, size: 300)
  ))

  #(wock-e.get)(w => assert.eq(w.color, cool-color))
  #(dock-e.get)(d => assert.eq(d.color, cool-color))
  #(wock-e.get)(w => assert.eq(w.border, blue + 2pt))
  #(dock-e.get)(d => assert.eq(d.size, 300))

  #show: e.stateful.revoke("coolness")

  // First color change revoked
  #(wock-e.get)(w => assert.ne(w.color, cool-color))
  #(dock-e.get)(d => assert.eq(d.color, cool-color))
  #(wock-e.get)(w => assert.eq(w.border, blue + 2pt))
  #(dock-e.get)(d => assert.eq(d.size, 300))

  #show: e.stateful.revoke("datums")

  // Other changes also revoked **to both elements**,
  // except the second color change
  #(wock-e.get)(w => assert.ne(w.color, cool-color))
  #(dock-e.get)(d => assert.eq(d.color, cool-color))
  #(wock-e.get)(w => assert.ne(w.border, blue + 2pt))
  #(dock-e.get)(d => assert.ne(d.size, 300))

  #show: e.stateful.revoke("docks")

  // Second color change also revoked now
  #(wock-e.get)(w => assert.ne(w.color, cool-color))
  #(dock-e.get)(d => assert.ne(d.color, cool-color))
  #(wock-e.get)(w => assert.ne(w.border, blue + 2pt))
  #(dock-e.get)(d => assert.ne(d.size, 300))
]
