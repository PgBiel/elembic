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

#show: e.set_(wock, color: blue)

#e.get(
  get => {
    assert.eq(get(wock).color, blue)
    assert.eq(get(wock).inner, [Hello!])
  }
)

#[
  #show: e.set_(wock, inner: [Bye!])

  #e.get(
    get => {
      assert.eq(get(wock).color, blue)
      assert.eq(get(wock).inner, [Bye!])
    }
  )
]

#e.get(
  get => {
    assert.eq(get(wock).color, blue)
    assert.eq(get(wock).inner, [Hello!])
  }
)
