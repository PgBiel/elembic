#import "/test/unit/base.typ": template
#show: template

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

#[
  #let cool-color = luma(89)
  // Name a single set rule
  #show: e.named("coolness", e.set_(wock, color: cool-color))
  // Name a group
  #show: e.named("datums", e.apply(
    e.set_(wock, border: blue + 2pt),
    e.set_(wock, size: 300)
  ))

  #e.get(get => assert.eq(get(wock).color, cool-color))
  #e.get(get => assert.eq(get(wock).border, blue + 2pt))
  #e.get(get => assert.eq(get(wock).size, 300))

  #wock()

  #show: e.named("revoker", e.revoke("coolness"))

  // Color change revoked
  #e.get(get => assert.ne(get(wock).color, cool-color))
  #e.get(get => assert.eq(get(wock).border, blue + 2pt))
  #e.get(get => assert.eq(get(wock).size, 300))

  #wock()

  #[
    #show: e.revoke("datums")

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

  #[
    #show: e.revoke("revoker")

    // 'coolness' no longer revoked
    #e.get(get => assert.eq(get(wock).color, cool-color))
    #e.get(get => assert.eq(get(wock).border, blue + 2pt))
    #e.get(get => assert.eq(get(wock).size, 300))
  ]

  // 'coolness' revoked again
    #e.get(get => assert.ne(get(wock).color, cool-color))
    #e.get(get => assert.eq(get(wock).border, blue + 2pt))
    #e.get(get => assert.eq(get(wock).size, 300))

  #wock()
]
