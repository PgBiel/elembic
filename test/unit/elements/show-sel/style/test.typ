#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: field

#let wock = e.element.declare(
  "wock",
  display: it => it.inner,
  fields: (
    field("color", color, default: red),
    field("inner", content, default: [])
  ),
  prefix: ""
)

#[
  #show e.selector(wock): it => {
    set text(red)
    it
  }
  #show e.selector(wock): it => {
    set text(yellow)
    it
  }

  // Yes, it kind of inverts it...
  #wock(inner: context assert.eq(text.fill, yellow))
]

#[
  #show e.selector(wock): it => {
    set text(red)
    it
  }
  #show e.selector(wock): it => {
    set text(yellow)
    it
    [some joining...]
  }

  #wock(inner: context assert.eq(text.fill, red))
]

#[
  #let test-counter = counter("counter2")

  #show <lbl>: it => {
    set text(red)
    it
  }
  #show <lbl>: it => {
    set text(yellow)
    it
  }
  #wock(inner: context assert.eq(text.fill, yellow), label: <lbl>)
]

#[
  #show: e.show_(wock, it => {
    set text(red)
    it
  })
  #show: e.show_(wock, it => {
    set text(yellow)
    it
  })

  // This one does it right.
  #wock(inner: context assert.eq(text.fill, red), label: <lbl>)
]

#[
  #e.select(wock, prefix: "testing", wock-sel => {
    show wock-sel: it => {
      set text(red)
      it
    }
    show wock-sel: it => {
      set text(yellow)
      it
    }
    wock(inner: context assert.eq(text.fill, yellow), label: <lbl>)
  })
]
