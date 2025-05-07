/// Test query with composed filters.

#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: field, types

#let wibble = e.element.declare(
  "wibble",
  display: it => {},
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

#wibble()
#wobble(data: "no match")
#wobble(data: "match")
#wobble(data: "also match no")

#context assert.eq(e.query(e.filters.or_(wibble, wobble)).len(), 4)
#context assert.eq(e.query(e.filters.and_(wobble.with(color: red), wobble.with(data: "match"))).len(), 1)
#context assert.eq(e.query(e.filters.and_(wobble.with(color: red), e.filters.not_(wobble.with(data: "match")))).len(), 2)
#context assert(e.query(e.filters.and_(wobble.with(color: red), e.filters.not_(wobble.with(data: "match")))).any(it => e.fields(it).data == "no match"))
#context assert.eq(e.query(e.filters.or_(wobble.with(data: "abc"), wobble.with(data: "match"))).len(), 1)
