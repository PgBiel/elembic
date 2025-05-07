/// Test query.

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

#context assert.eq(e.query(wobble).len(), 3)
#context assert.eq(e.query(wibble).len(), 1)
#context assert.eq(e.query(wibble.with(color: red)).len(), 1)
#context assert.eq(e.query(wobble.with(data: "match")).len(), 1)
#context assert.eq(e.fields(e.query(wobble.with(data: "match")).first()).data, "match")
#context assert.eq(e.query(e.filters.and_(wobble, e.filters.custom((it, ..) => "no" in it.data))).len(), 2)
