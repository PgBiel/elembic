#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: field

#show circle: block.with(above: 0pt, below: 3pt)
#show rect: block.with(above: 0pt, below: 3pt)

#show: e.stateful.enable()

#let wibble = e.element.declare(
  "wibble",
  display: it => {
    it.inner
  },
  fields: (
    field("color", color, default: red),
    field("inner", content, default: [])
  ),
  prefix: ""
)

#let wobble = e.element.declare(
  "wobble",
  display: it => {
    it.inner
  },
  fields: (
    field("fill", color, default: orange),
    field("inner", content, default: [])
  ),
  prefix: ""
)

#set text(11pt)

#e.select(wibble.with(color: green), wibble.with(color: blue), wobble.with(fill: green), (green-wibble, blue-wibble, green-wobble) => [
  #show green-wibble: set text(6pt)
  #show blue-wibble: set text(22pt)
  #show green-wobble: set text(32pt)

  #wibble(color: green, inner: context { assert.eq(text.size, 6pt) })
  #wibble(color: blue, inner: context { assert.eq(text.size, 22pt) })
  #wobble(fill: green, inner: context { assert.eq(text.size, 32pt) })
  #wobble(fill: orange, inner: context { assert.eq(text.size, 11pt) })

  #[
    #show: e.set_(wobble, fill: green)
    #wobble(inner: context { assert.eq(text.size, 32pt) })
  ]

  #[
    #show: e.stateful.set_(wobble, fill: green)
    #wobble(inner: context { assert.eq(text.size, 32pt) })
  ]
])))

#wibble(color: green, inner: context { assert.eq(text.size, 11pt) })
#wibble(color: blue, inner: context { assert.eq(text.size, 11pt) })
#wobble(fill: green, inner: context { assert.eq(text.size, 11pt) })
