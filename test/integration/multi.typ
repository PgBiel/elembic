#import "/src/lib.typ" as e: field

#let wibble = e.element.declare(
  "wibble",
  display: it => {
    text(it.color)[#it.inner]
  },
  fields: (
    field("color", color, default: red),
    field("inner", content, default: [Wibble!])
  ),
  prefix: ""
)

#let wobble = e.element.declare(
  "wobble",
  display: it => {
    rect(fill: it.fill, it.inner)
  },
  fields: (
    field("fill", color, default: orange),
    field("inner", content, default: [Wobble...])
  ),
  prefix: ""
)

#wibble()
#wobble()

#[
  #show: e.set_(wibble, color: blue)

  #wibble()
  #wobble()

  #show: e.set_(wobble, fill: yellow)

  #wibble()
  #wobble()

  #e.get(get => assert.eq(get(wibble).color, blue))
  #e.get(get => assert.eq(get(wobble).fill, yellow))

  #[
    #show: e.set_(wibble, inner: [Buh bye!])

    #e.get(get => assert.eq(get(wibble).inner, [Buh bye!]))
    #e.get(get => get(wibble))

    #[
      #show: e.set_(wobble, inner: [Dance!])
      #e.get(get => assert.eq(get(wobble).inner, [Dance!]))
      #e.get(get => get(wobble))

      #wobble()
    ]

    #wibble()
  ]

  #[
    #show: e.set_(wibble, color: green)
    #e.get(get => assert.eq(get(wibble).color, green))
  ]

  #e.get(get => assert.eq(get(wibble).color, blue))
  #wibble()

  #wibble(color: yellow)

  #wibble(inner: [Okay])
]

#wibble()
#wobble()

---

#[
  #show selector.or(rect, e.selector(wibble), e.selector(wobble)): it => {
    let (body, fields, func) = e.data(it)
    if func == rect {
      [*We have a rect:* #body]
    } else if func == wibble {
      [We have a wibble of color #fields.at("color"), inner #fields.at("inner"), and body #body]
    } else {
      let (body, fields, func) = e.data(it)
      if func == wobble {
        [We have a wobble of fill #fields.at("fill"), inner #fields.at("inner") and body #body]
      } else {
        panic("Unknown element")
      }
    }
  }

  #rect(fill: blue.lighten(50%))[weee]

  #wibble(color: red, inner: [Wonderful])

  #wobble(fill: green, inner: [Lastful])
]

#wibble()
#wobble()

---

*Querying:*

#context {
  let wibbles = query(e.selector(wibble)).map(e.data)
  let colors = wibbles.map(e => e.fields.at("color", default: none)).dedup()
  [There are #wibbles.len() wibbles. We have #colors.len() colors: #colors]
}

#context {
  let wobbles = query(e.selector(wobble)).map(e.data)
  let fills = wobbles.map(e => e.fields.at("fill", default: none)).dedup()
  [There are #wobbles.len() wobbles. We have #fills.len() colors: #fills]
}

#pagebreak(weak: true)

= Show-set

#set text(11pt)

#wibble()
#wobble()

#[
  #show e.selector(wibble): set text(2em)
  Normal
  #wibble(inner: [Big])
  #wobble(inner: [Normal])
]

#[
  #show e.selector(wobble): set text(2em)
  Normal
  #wibble(inner: [Normal])
  #wobble(inner: [Big])
]

#wibble()
#wobble()

#(e.data(wibble).where)(color: green, green-wibble => (e.data(wibble).where)(color: blue, blue-wibble => (e.data(wobble).where)(fill: green, green-wobble => [
  #show green-wibble: set text(6pt)
  #show blue-wibble: set text(22pt)
  #show green-wobble: set text(32pt)

  #wibble()

  #wibble(color: green)
  #wibble(color: blue)
  #wobble(fill: green)

  #wibble(color: green, inner: context { assert.eq(text.size, 6pt) })
  #wibble(color: blue, inner: context { assert.eq(text.size, 22pt) })
  #wobble(fill: green, inner: context { assert.eq(text.size, 32pt) })
])))

#wibble(color: green)
#wibble(color: blue)
#wobble(fill: green)

#wibble(color: green, inner: context { assert.eq(text.size, 11pt) })
#wibble(color: blue, inner: context { assert.eq(text.size, 11pt) })
#wobble(fill: green, inner: context { assert.eq(text.size, 11pt) })
