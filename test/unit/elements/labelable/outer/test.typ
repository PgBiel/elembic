#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: field

#let wock = e.element.declare(
  "wock",
  display: it => {},
  fields: (
    field("color", color, default: red),
    field("inner", content, default: [Hello!])
  ),
  labelable: true,
  prefix: ""
)
#show: e.prepare()

#[
  #let show-counter-1 = counter("show-counter-1")

  #show <badbad>: it => {
    let fields = e.fields(it)
    assert("label" not in fields) // incomplete...
    assert.eq(fields.color, blue)

    show-counter-1.step()
    it
  }

  #show: e.show_(wock.with(label: <badbad>), it => {
    let fields = e.fields(it)
    assert.eq(fields.label, <badbad>)

    show-counter-1.step()
    it
  })

  #show: e.show_(wock, it => {
    show-counter-1.step()
    it
  })
  #show e.selector(wock): it => it + show-counter-1.step()

  #wock(color: blue) <badbad>
  #context assert.eq(show-counter-1.get().first(), 4)
]

#e.select(wock.with(label: <blorb>), prefix: "sel1", blorb => {
  show blorb: it => {
    let fields = e.fields(it)
    assert.eq(fields.color, green)
    assert.eq(fields.label, <blorb>)
  }

  [#wock(color: green) <blorb>]
})

#wock(color: blue, label: none)

#[
  #let show-counter-2 = counter("show-counter-2")
  #let show-counter-3 = counter("show-counter-3")
  #show: e.show_(wock.with(label: <unused>), it => show-counter-2.step())
  #show: e.show_(wock.with(label: <real>), it => show-counter-3.step())
  #wock(label: <real>) <unused>

  #context assert.eq(show-counter-2.get().first(), 0)
  #context assert.eq(show-counter-3.get().first(), 1)
]

#[
  #show e.selector(wock): it => {
    assert("label" not in e.fields(it))
    it
  }
  #wock(color: green)
]

#[
  #show e.selector(wock): it => {
    assert("label" not in e.fields(it))
    it
  }
  #wock(color: blue, label: none)
]
