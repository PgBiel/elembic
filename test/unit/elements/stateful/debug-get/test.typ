// Test debug-get (retrieves the full style chain).
#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: field

#let wock = e.element.declare(
  "wock",
  display: it => {
    assert.eq(it.color, blue)
    assert.eq(it.inner, [Hello!])
  },
  fields: (
    field("color", color, default: red),
    field("inner", content, default: [Hello!])
  ),
  prefix: ""
)

#show: e.stateful.enable()
#show: e.stateful.set_(wock, color: blue)

#context {
  let styles = e.internal.stateful-debug-get()
  let (get,) = styles.ctx
  assert.eq(get(wock).color, blue)
  assert.eq(get(wock).inner, [Hello!])

  assert(e.eid(wock) in styles.elements)
  assert("chain" in styles.elements.at(e.eid(wock)))
}
