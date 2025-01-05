#import "/src/lib.typ" as e: element, field, types

#let (wock, wock-e) = element(
  "wock",
  display: it => {
    text(it.color)[#it.inner]
  },
  fields: (
    field("color", color, default: red),
    field("inner", content, default: [Hello!])
  )
)

#e.decompose([])

#wock()

#let w = wock(color: blue)
#assert.eq(e.decompose(w).fields, (color: blue))

#[
  #show: e.set_(wock-e, color: blue)

  #wock()

  #(wock-e.get)(v => assert.eq(v.color, blue))
  #(wock-e.get)(v => assert.eq(v.inner, [Hello!]))

  #[
    #show: e.set_(wock-e, inner: [Buh bye!])

    #(wock-e.get)(v => assert.eq(v.at("inner"), [Buh bye!]))
    #(wock-e.get)(v => v)

    #wock()
  ]

  #[
    #show: e.set_(wock-e, color: green)
    #(wock-e.get)(v => assert.eq(v.at("color"), green))
  ]

  #(wock-e.get)(v => assert.eq(v.at("color"), blue))
  #wock()

  #wock(color: yellow)

  #wock(inner: [Okay])
]

#wock()

#pagebreak(weak: true)

= Show rules

#wock()

#[
  #show wock-e.sel: it => {
    let (body, fields) = e.decompose(it)
    [The color is #fields.at("color")]

    assert(fields.at("color") in (red, blue))
  }

  #wock(color: blue)

  #wock(color: red)
]

#wock(color: green)

---

#[
  #show selector.or(rect, wock-e.sel): it => {
    let (body, fields, func) = e.decompose(it)
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
  let wocks = query(wock-e.sel).map(e.decompose)
  let colors = wocks.map(e => e.fields.at("color", default: none)).dedup()
  [There are #wocks.len() wocks. We have #colors.len() colors: #colors]
}

#pagebreak(weak: true)

= Show-set

#set text(11pt)

#wock()

#[
  #show wock-e.sel: set text(2em)
  Normal
  #wock(inner: [Big])
]

#wock()

#(wock-e.where)(color: green, green-wock => (wock-e.where)(color: blue, blue-wock => [
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
