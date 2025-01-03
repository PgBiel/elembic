#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: element, field

#let (wock, wock-e) = element(
  "wock",
  it => {
    assert.eq(it.color, blue)
    assert.eq(it.inner, [Hello!])
  },
  fields: (
    field("color", color, default: red),
    field("inner", content, default: [Hello!])
  )
)

#show: e.set_(wock-e, color: blue)

#(wock-e.get)(
  v => {
    assert.eq(v.color, blue)
    assert.eq(v.inner, [Hello!])
  }
)

#[
  #show: e.set_(wock-e, inner: [Bye!])

  #(wock-e.get)(
    v => {
      assert.eq(v.color, blue)
      assert.eq(v.inner, [Bye!])
    }
  )
]

#(wock-e.get)(
  v => {
    assert.eq(v.color, blue)
    assert.eq(v.inner, [Hello!])
  }
)
