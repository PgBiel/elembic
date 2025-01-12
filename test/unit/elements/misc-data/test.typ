#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: field

#let wock = e.element.declare(
  "wock",
  display: it => {},
  fields: (
    field("color", color, default: red),
    field("border", stroke, default: red),
    field("inner", content, default: [Hello!])
  ),
  prefix: ""
)

#show e.selector(wock): it => {
  assert.eq(e.func(it), wock)
  assert.eq(e.func(it), e.data(it).func)
  assert.eq(e.eid(it), e.eid(wock))
  assert.eq(e.eid(it), e.data(it).eid)
}

#wock()
