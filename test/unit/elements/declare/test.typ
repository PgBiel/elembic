#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: element, field

#let (wock, wock-e) = element(
  "wock",
  it => {
    assert.eq(it.color, red)
    assert.eq(it.inner, [Hello!])
  },
  fields: (
    field("color", color, default: red),
    field("inner", content, default: [Hello!])
  )
)

#wock()
