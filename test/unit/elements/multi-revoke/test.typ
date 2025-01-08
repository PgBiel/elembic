#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: field, types

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

#let dock = e.element.declare(
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
  #show: e.named("coolness", e.set_(wock, color: cool-color))
  #show: e.named("docks", e.set_(dock, color: cool-color))
  #show: e.named("datums", e.apply(
    e.set_(wock, border: blue + 2pt),
    e.set_(dock, size: 300)
  ))

  #e.get(get => assert.eq(get(wock).color, cool-color))
  #e.get(get => assert.eq(get(dock).color, cool-color))
  #e.get(get => assert.eq(get(wock).border, blue + 2pt))
  #e.get(get => assert.eq(get(dock).size, 300))

  #show: e.revoke("coolness")

  // First color change revoked
  #e.get(get => assert.ne(get(wock).color, cool-color))
  #e.get(get => assert.eq(get(dock).color, cool-color))
  #e.get(get => assert.eq(get(wock).border, blue + 2pt))
  #e.get(get => assert.eq(get(dock).size, 300))

  #show: e.revoke("datums")

  // Other changes also revoked **to both elements**,
  // except the second color change
  #e.get(get => assert.ne(get(wock).color, cool-color))
  #e.get(get => assert.eq(get(dock).color, cool-color))
  #e.get(get => assert.ne(get(wock).border, blue + 2pt))
  #e.get(get => assert.ne(get(dock).size, 300))

  #show: e.revoke("docks")

  // Second color change also revoked now
  #e.get(get => assert.ne(get(wock).color, cool-color))
  #e.get(get => assert.ne(get(dock).color, cool-color))
  #e.get(get => assert.ne(get(wock).border, blue + 2pt))
  #e.get(get => assert.ne(get(dock).size, 300))
]
