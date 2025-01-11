#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: field

#let count = counter("adb")

#let wock-factory = e.element.declare.with(
  display: it => {
    assert.eq(it.color, red)
    assert.eq(it.inner, [Hello!])
    (it.test)()
  },
  fields: (
    field("color", color, default: red),
    field("inner", content, default: [Hello!]),
    field("test", function, default: () => {}),
    field("resolved-value", int, doc: "A magical resolved value", synthesized: true)
  ),
  synthesize: it => {
    it.resolved-value = count.get().first()
    it
  },
  prefix: ""
)
#let wock = wock-factory("wock")

#let unchecked-wock = wock-factory("unchecked-wock", typecheck: false)

#show e.selector(wock): it => {
  count.step()
  it
}

#wock(test: () => count.get().first() == 0)
#wock(test: () => count.get().first() == 1)
#wock(test: () => count.get().first() == 2)

// We can match on synthesized fields
#e.select(wock.with(resolved-value: 3), three-wock => {
  show three-wock: none

  wock(test: () => context panic())
})

#e.select(unchecked-wock.with(resolved-value: 3), three-unchecked-wock => {
  show three-unchecked-wock: none

  unchecked-wock(test: () => context panic())
})

#show e.selector(wock): it => {
  assert.eq(e.data(it).fields.resolved-value, 3)
  it
}

#wock()
