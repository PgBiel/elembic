/// Test 'reset' usage

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
  ),
  prefix: ""
)

#show: e.named("abc", "ghi", e.set_(wock, color: yellow))
#show: e.named("abc", "def", e.set_(wock, border: red + 2pt))

#e.get(get => assert.eq(get(wock).color, yellow))
#e.get(get => assert.eq(get(wock).border, red + 2pt))

#[
  #show: e.revoke("abc")

  #e.get(get => assert.eq(get(wock).color, red))
  #e.get(get => assert.eq(get(wock).border, black + 1pt))
]

#[
  #show: e.revoke("def")

  #e.get(get => assert.eq(get(wock).color, yellow))
  #e.get(get => assert.eq(get(wock).border, black + 1pt))
]

#[
  #show: e.revoke("ghi")

  #e.get(get => assert.eq(get(wock).color, red))
  #e.get(get => assert.eq(get(wock).border, red + 2pt))
]

#[
  #show: e.named("rrr", "yyy", e.reset())

  #e.get(get => assert.eq(get(wock).color, red))
  #e.get(get => assert.eq(get(wock).border, black + 1pt))

  #[
    #show: e.revoke("rrr")

    #e.get(get => assert.eq(get(wock).color, yellow))
    #e.get(get => assert.eq(get(wock).border, red + 2pt))
  ]
  #[
    #show: e.revoke("yyy")

    #e.get(get => assert.eq(get(wock).color, yellow))
    #e.get(get => assert.eq(get(wock).border, red + 2pt))
  ]
]

#[
  #show: e.named("rrr", "yyy", e.revoke("abc"))

  #e.get(get => assert.eq(get(wock).color, red))
  #e.get(get => assert.eq(get(wock).border, black + 1pt))

  #[
    #show: e.revoke("rrr")

    #e.get(get => assert.eq(get(wock).color, yellow))
    #e.get(get => assert.eq(get(wock).border, red + 2pt))
  ]
  #[
    #show: e.revoke("yyy")

    #e.get(get => assert.eq(get(wock).color, yellow))
    #e.get(get => assert.eq(get(wock).border, red + 2pt))
  ]
]
