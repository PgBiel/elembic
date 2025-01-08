#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: field

#show: e.stateful.enable()

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

#show: e.stateful.set_(wock, color: blue)
#wock()
