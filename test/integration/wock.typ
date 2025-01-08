#import "/src/lib.typ" as e: field, types

#let wock = e.element.declare(
  "wock",
  display: it => {
    text(it.color)[#it.inner]
  },
  fields: (
    field("color", color, default: red),
    field("inner", content, default: [Hello!])
  ),
  prefix: ""
)

#e.data([])

#wock()

#let w = wock(color: blue)
#assert.eq(e.data(w).fields, (color: blue))

#[
  #show: e.set_(wock, color: blue)

  #wock()

  #e.get(get => assert.eq(get(wock).color, blue))
  #e.get(get => assert.eq(get(wock).inner, [Hello!]))

  #[
    #show: e.set_(wock, inner: [Buh bye!])

    #e.get(get => assert.eq(get(wock).at("inner"), [Buh bye!]))
    #e.get(get => get(wock))

    #wock()
  ]

  #[
    #show: e.set_(wock, color: green)
    #e.get(get => assert.eq(get(wock).at("color"), green))
  ]

  #e.get(get => assert.eq(get(wock).at("color"), blue))
  #wock()

  #wock(color: yellow)

  #wock(inner: [Okay])
]

#wock()

#pagebreak(weak: true)

= Show rules

#wock()

#[
  #show e.selector(wock): it => {
    let (body, fields) = e.data(it)
    [The color is #fields.at("color")]

    assert(fields.at("color") in (red, blue))
  }

  #wock(color: blue)

  #wock(color: red)
]

#wock(color: green)

---

#[
  #show selector.or(rect, e.selector(wock)): it => {
    let (body, fields, func) = e.data(it)
    if func == rect {
      [*We have a rect:* #body]
    } else if func == wock {
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
  let wocks = query(e.selector(wock)).map(e.data)
  let colors = wocks.map(e => e.fields.at("color", default: none)).dedup()
  [There are #wocks.len() wocks. We have #colors.len() colors: #colors]
}

#pagebreak(weak: true)

= Show-set

#set text(11pt)

#wock()

#[
  #show e.selector(wock): set text(2em)
  Normal
  #wock(inner: [Big])
]

#wock()

#(e.data(wock).where)(color: green, green-wock => (e.data(wock).where)(color: blue, blue-wock => [
  #show green-wock: set text(6pt)
  #show blue-wock: set text(22pt)

  #wock()

  #wock(color: green)
  #wock(color: blue)

  #wock(color: green, inner: context { assert.eq(text.size, 6pt) })
  #wock(color: blue, inner: context { assert.eq(text.size, 22pt) })
]))

#wock(color: green)
#wock(color: blue)

#wock(color: green, inner: context { assert.eq(text.size, 11pt) })
#wock(color: blue, inner: context { assert.eq(text.size, 11pt) })
