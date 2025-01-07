#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: element, field

#let count = counter("adb")

#let (wock, wock-e) = element(
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

#show wock-e.sel: it => {
  count.step()
  it
}

#wock(test: () => count.get().first() == 0)
#wock(test: () => count.get().first() == 1)
#wock(test: () => count.get().first() == 2)

#show wock-e.sel: it => {
  assert.eq(e.data(it).fields.resolved-value, 3)
  it
}

#wock()
