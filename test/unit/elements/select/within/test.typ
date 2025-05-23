/// Test select with composed filters.

#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: field, types

#let wibble = e.element.declare(
  "wibble",
  display: it => it.inner,
  fields: (
    field("color", color, default: red),
    field("data", str, default: "data"),
    field("inner", content, default: [Hello!]),
  ),
  prefix: ""
)

#let wobble = e.element.declare(
  "wobble",
  display: it => {},
  fields: (
    field("color", color, default: red),
    field("data", str, default: "data"),
    field("inner", content, default: [Hello!]),
  ),
  prefix: ""
)

#e.select(e.filters.and_(wobble, e.within(wibble)), prefix: "sel1", matched => {
  let match-counter = counter("matches")
  show matched: it => match-counter.step() + it

  wibble(inner: wobble())
  wibble(inner: wobble())
  wobble()
  wobble()
  wobble()
  wibble(inner: [])

  context assert.eq(match-counter.get(), (2,))
})
