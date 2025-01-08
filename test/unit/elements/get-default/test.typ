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

#e.get(
  get => {
    assert.eq(get(wock).color, red)
    assert.eq(get(wock).inner, [Hello!])
  }
)
