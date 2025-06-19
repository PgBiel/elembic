#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: field

#let wock = e.element.declare(
  "wock",
  display: it => {},
  fields: (
    field("color", color, default: red),
    field("inner", content, default: [])
  ),
  prefix: ""
)

#[
  #let test-counter = counter("counter")

  #show e.selector(wock): it => {
    if e.fields(it) != none and e.fields(it).inner == [Worked] {
      test-counter.step()
    }
    it
  }
  #show e.selector(wock): it => {
    test-counter.step()
    it
    test-counter.step()
  }
  #wock(inner: [Worked])

  #context assert.eq(test-counter.get().first(), 3)
]

#[
  #let test-counter = counter("counter2")

  #show <lbl>: it => {
    if e.fields(it) != none and e.fields(it).inner == [Worked] {
      test-counter.step()
    }
    it
  }
  #show <lbl>: it => {
    test-counter.step()
    it
    test-counter.step()
  }
  #wock(inner: [Worked], label: <lbl>)

  #context assert.eq(test-counter.get().first(), 3)
]

#[
  #let test-counter = counter("counter3")

  #show: e.show_(wock, it => {
    if e.fields(it) != none and e.fields(it).inner == [Worked] {
      test-counter.step()
    }
    it
  })
  #show: e.show_(wock, it => {
    test-counter.step()
    it
    test-counter.step()
  })
  #wock(inner: [Worked], label: <lbl>)

  #context assert.eq(test-counter.get().first(), 3)
]

#[
  #let test-counter = counter("counter4")

  #e.select(wock, prefix: "testing", wock-sel => {
    show wock-sel: it => {
      if e.fields(it) != none and e.fields(it).inner == [Worked] {
        test-counter.step()
      }
      it
    }
    show wock-sel: it => {
      test-counter.step()
      it
      test-counter.step()
    }
    wock(inner: [Worked], label: <lbl>)
  })

  #context assert.eq(test-counter.get().first(), 3)
]
