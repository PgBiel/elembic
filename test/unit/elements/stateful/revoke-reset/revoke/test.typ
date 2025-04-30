#import "/test/unit/base.typ": template
#show: template

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
  ),
  prefix: ""
)

#[
  #let cool-color = luma(89)
  // Name a single set rule
  #show: e.named("coolness", e.stateful.set_(wock, color: cool-color))
  // Name a group
  #show: e.named("datums", e.stateful.apply(
    e.set_(wock, border: blue + 2pt),
    e.set_(wock, size: 300)
  ))

  #e.get(get => assert.eq(get(wock).color, cool-color))
  #e.get(get => assert.eq(get(wock).border, blue + 2pt))
  #e.get(get => assert.eq(get(wock).size, 300))

  #wock()

  #show: e.stateful.revoke("coolness")

  // Color change revoked
  #e.get(get => assert.ne(get(wock).color, cool-color))
  #e.get(get => assert.eq(get(wock).border, blue + 2pt))
  #e.get(get => assert.eq(get(wock).size, 300))

  #wock()

  #[
    #show: e.stateful.revoke("datums")

    // Both color change and other changes revoked
    #e.get(get => assert.ne(get(wock).color, cool-color))
    #e.get(get => assert.ne(get(wock).border, blue + 2pt))
    #e.get(get => assert.ne(get(wock).size, 300))

    #wock()
  ]

  // 'datums' no longer revoked
  #e.get(get => assert.ne(get(wock).color, cool-color))
  #e.get(get => assert.eq(get(wock).border, blue + 2pt))
  #e.get(get => assert.eq(get(wock).size, 300))

  #wock()
]
