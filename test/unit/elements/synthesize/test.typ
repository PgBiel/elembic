#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: field

#let count = counter("adb")

#let wock = e.element.declare(
  "wock",
  display: it => {
    assert.eq(it.color, red)
    assert.eq(it.inner, [Hello!])
    (it.test)()
  },
  fields: (
    field("color", color, default: red),
    field("inner", content, default: [Hello!]),
    field("test", function, default: () => {})
  ),
  synthesize: it => {
    it.resolved-value = count.get().first()
    it
  }
)

#show e.selector(wock): it => {
  count.step()
  it
}

#wock(test: () => count.get().first() == 0)
#wock(test: () => count.get().first() == 1)
#wock(test: () => count.get().first() == 2)

#show e.selector(wock): it => {
  assert.eq(e.data(it).fields.resolved-value, 3)
  it
}

#wock()
