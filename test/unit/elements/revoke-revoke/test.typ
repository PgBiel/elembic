#import "/test/unit/base.typ": template
#show: template

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
  // Name a single set rule
  #show: e.named("coolness", e.set_(wock-e, color: cool-color))
  // Name a group
  #show: e.named("datums", e.apply(
    e.set_(wock-e, border: blue + 2pt),
    e.set_(wock-e, size: 300)
  ))

  #(wock-e.get)(d => assert.eq(d.color, cool-color))
  #(wock-e.get)(d => assert.eq(d.border, blue + 2pt))
  #(wock-e.get)(d => assert.eq(d.size, 300))

  #wock()

  #show: e.named("revoker", e.revoke("coolness"))

  // Color change revoked
  #(wock-e.get)(d => assert.ne(d.color, cool-color))
  #(wock-e.get)(d => assert.eq(d.border, blue + 2pt))
  #(wock-e.get)(d => assert.eq(d.size, 300))

  #wock()

  #[
    #show: e.revoke("datums")

    // Both color change and other changes revoked
    #(wock-e.get)(d => assert.ne(d.color, cool-color))
    #(wock-e.get)(d => assert.ne(d.border, blue + 2pt))
    #(wock-e.get)(d => assert.ne(d.size, 300))

    #wock()
  ]

  // 'datums' no longer revoked
  #(wock-e.get)(d => assert.ne(d.color, cool-color))
  #(wock-e.get)(d => assert.eq(d.border, blue + 2pt))
  #(wock-e.get)(d => assert.eq(d.size, 300))

  #[
    #show: e.revoke("revoker")

    // 'coolness' no longer revoked
    #(wock-e.get)(d => assert.eq(d.color, cool-color))
    #(wock-e.get)(d => assert.eq(d.border, blue + 2pt))
    #(wock-e.get)(d => assert.eq(d.size, 300))
  ]

  // 'coolness' revoked again
    #(wock-e.get)(d => assert.ne(d.color, cool-color))
    #(wock-e.get)(d => assert.eq(d.border, blue + 2pt))
    #(wock-e.get)(d => assert.eq(d.size, 300))

  #wock()
]
