#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: element, field

#let (wock, wock-e) = element(
  "wock",
  display: it => {
    assert.eq(it.color, blue)
    assert.eq(it.inner, [Hello!])
  },
  fields: (
    field("color", color, default: red),
    field("inner", content, default: [Hello!])
  )
)

#(wock-e.get)(
  v => {
    assert.eq(v.color, red)
    assert.eq(v.inner, [Hello!])
  }
)
