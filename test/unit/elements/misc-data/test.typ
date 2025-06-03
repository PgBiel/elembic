#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: field

#let wock = e.element.declare(
  "wock",
  display: it => {},
  fields: (
    field("color", color, default: red),
    field("border", stroke, default: blue),
    field("inner", content, default: [Hello!])
  ),
  prefix: ""
)

#assert.eq(e.func-name(wock), "wock")

#show e.selector(wock): it => {
  assert.eq(e.func(it), wock)
  assert.eq(e.func(it), e.data(it).func)
  assert.eq(e.eid(it), e.eid(wock))
  assert.eq(e.eid(it), e.data(it).eid)
  assert.eq(e.func-name(it), "wock")

  assert.eq(e.repr(it), "wock(border: luma(0%), color: rgb(\"#ff4136\"), inner: [Hello!])")
}

#let w = wock(border: black)

#assert.eq(e.func-name(w), "wock")
#assert.eq(e.repr(w), "wock(border: luma(0%))")

#assert.eq(e.func-name[= abc], "heading")

#assert.eq(type(e.internal.constants.element-version), int)
#assert.eq(type(e.internal.constants.type-version), int)
#assert.eq(type(e.internal.constants.style-modes), dictionary)

#w
