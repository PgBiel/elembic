#import "/src/lib.typ": element

#let (wibble, set-wibble, get-wibble, show-wibble, wibble-sel) = element(
  "wibble",
  (color: red, inner: [Wibble!]) => {
    text(color)[#inner]
  }
)

#let (wobble, set-wobble, get-wobble, show-wobble, wobble-sel) = element(
  "wobble",
  (fill: orange, inner: [Wobble...]) => {
    rect(fill: fill, inner)
  }
)

#wibble()
#wobble()

#[
  #show: set-wibble(color: blue)

  #wibble()
  #wobble()

  #show: set-wobble(fill: yellow)

  #wibble()
  #wobble()

  #get-wibble(v => assert.eq(v.at("color"), blue))
  #get-wobble(v => assert.eq(v.at("fill"), yellow))

  #[
    #show: set-wibble(inner: [Buh bye!])

    #get-wibble(v => assert.eq(v.at("inner"), [Buh bye!]))
    #get-wibble(v => v)

    #[
      #show: set-wobble(inner: [Dance!])
      #get-wobble(v => assert.eq(v.at("inner"), [Dance!]))
      #get-wobble(v => v)

      #wobble()
    ]

    #wibble()
  ]

  #[
    #show: set-wibble(color: green)
    #get-wibble(v => assert.eq(v.at("color"), green))
  ]

  #get-wibble(v => assert.eq(v.at("color"), blue))
  #wibble()

  #wibble(color: yellow)

  #wibble(inner: [Okay])
]

#wibble()
#wobble()

---

#[
  #show selector.or(rect, wibble-sel, wobble-sel): it => {
    let (body, fields) = show-wibble(it)
    if fields == none and it.func() == rect {
      [*We have a rect:* #body]
    } else if fields != none {
      [We have a wibble of color #fields.at("color"), inner #fields.at("inner"), and body #body]
    } else {
      let (body, fields) = show-wobble(it)
      if fields != none {
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
  let wibbles = query(wibble-sel).map(show-wibble)
  let colors = wibbles.map(e => e.fields.at("color", default: none)).dedup()
  [There are #wibbles.len() wibbles. We have #colors.len() colors: #colors]
}

#context {
  let wobbles = query(wobble-sel).map(show-wobble)
  let fills = wobbles.map(e => e.fields.at("fill", default: none)).dedup()
  [There are #wobbles.len() wobbles. We have #fills.len() colors: #fills]
}
