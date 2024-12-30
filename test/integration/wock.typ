#import "/src/lib.typ": element

#let (wock, set-wock, get-wock, show-wock, wock-sel) = element(
  "wock",
  (color: red, inner: [Hello!]) => {
    text(color)[#inner]
  }
)

#wock()

#[
  #show: set-wock(color: blue)

  #wock()

  #get-wock(v => assert.eq(v.at("color"), blue))

  #[
    #show: set-wock(inner: [Buh bye!])

    #get-wock(v => assert.eq(v.at("inner"), [Buh bye!]))
    #get-wock(v => v)

    #wock()
  ]

  #[
    #show: set-wock(color: green)
    #get-wock(v => assert.eq(v.at("color"), green))
  ]

  #get-wock(v => assert.eq(v.at("color"), blue))
  #wock()

  #wock(color: yellow)

  #wock(inner: [Okay])
]

#wock()

#pagebreak(weak: true)

= Show rules

#wock()

#[
  #show wock-sel: it => {
    let (body, fields) = show-wock(it)
    [The color is #fields.at("color")]

    assert(fields.at("color") in (red, blue))
  }

  #wock(color: blue)

  #wock(color: red)
]

#wock(color: green)

---

#[
  #show selector.or(rect, wock-sel): it => {
    let (body, fields) = show-wock(it)
    if fields == none and it.func() == rect {
      [*We have a rect:* #body]
    } else if fields != none {
      [We have a wock of color #fields.at("color"), inner #fields.at("inner"), and body #body]
    } else {
      panic("Bad")
    }
  }

  #rect(fill: blue.lighten(50%))[weee]

  #wock(color: red, inner: [Wonderful])
]

#wock()

---

*Querying:*

#context {
  let wocks = query(wock-sel).map(show-wock)
  let colors = wocks.map(e => e.fields.at("color", default: none)).dedup()
  [There are #wocks.len() wocks. We have #colors.len() colors: #colors]
}
