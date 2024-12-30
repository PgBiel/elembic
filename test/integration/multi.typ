#import "/src/lib.typ" as e: element, fields
#import fields: field

#let (wibble, wibble-e) = element(
  "wibble",
  it => {
    text(it.color)[#it.inner]
  },
  fields: (
    field("color", color, default: red),
    field("inner", content, default: [Wibble!])
  )
)

#let (wobble, wobble-e) = element(
  "wobble",
  it => {
    rect(fill: it.fill, it.inner)
  },
  fields: (
    field("fill", color, default: orange),
    field("inner", content, default: [Wobble...])
  )
)

#wibble()
#wobble()

#[
  #show: e.set_(wibble-e, color: blue)

  #wibble()
  #wobble()

  #show: e.set_(wobble-e, fill: yellow)

  #wibble()
  #wobble()

  #(wibble-e.get)(v => assert.eq(v.at("color"), blue))
  #(wobble-e.get)(v => assert.eq(v.at("fill"), yellow))

  #[
    #show: e.set_(wibble-e, inner: [Buh bye!])

    #(wibble-e.get)(v => assert.eq(v.at("inner"), [Buh bye!]))
    #(wibble-e.get)(v => v)

    #[
      #show: e.set_(wobble-e, inner: [Dance!])
      #(wobble-e.get)(v => assert.eq(v.at("inner"), [Dance!]))
      #(wobble-e.get)(v => v)

      #wobble()
    ]

    #wibble()
  ]

  #[
    #show: e.set_(wibble-e, color: green)
    #(wibble-e.get)(v => assert.eq(v.at("color"), green))
  ]

  #(wibble-e.get)(v => assert.eq(v.at("color"), blue))
  #wibble()

  #wibble(color: yellow)

  #wibble(inner: [Okay])
]

#wibble()
#wobble()

---

#[
  #show selector.or(rect, wibble-e.sel, wobble-e.sel): it => {
    let (body, fields, func) = e.show_(it)
    if func == rect {
      [*We have a rect:* #body]
    } else if func == wibble {
      [We have a wibble of color #fields.at("color"), inner #fields.at("inner"), and body #body]
    } else {
      let (body, fields, func) = e.show_(it)
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
  let wibbles = query(wibble-e.sel).map(e.show_)
  let colors = wibbles.map(e => e.fields.at("color", default: none)).dedup()
  [There are #wibbles.len() wibbles. We have #colors.len() colors: #colors]
}

#context {
  let wobbles = query(wobble-e.sel).map(e.show_)
  let fills = wobbles.map(e => e.fields.at("fill", default: none)).dedup()
  [There are #wobbles.len() wobbles. We have #fills.len() colors: #fills]
}

#pagebreak(weak: true)

= Show-set

#set text(11pt)

#wibble()
#wobble()

#[
  #show wibble-e.sel: set text(2em)
  Normal
  #wibble(inner: [Big])
  #wobble(inner: [Normal])
]

#[
  #show wobble-e.sel: set text(2em)
  Normal
  #wibble(inner: [Normal])
  #wobble(inner: [Big])
]

#wibble()
#wobble()

#(wibble-e.where)(color: green, green-wibble => (wibble-e.where)(color: blue, blue-wibble => (wobble-e.where)(fill: green, green-wobble => [
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
