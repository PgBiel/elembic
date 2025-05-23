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
#context assert.eq(e.query(wibble, before: here()).len(), 1)
#context assert.eq(e.query(wibble, after: here()).len(), 2)
#wibble()
#wibble()

#wobble(data: "match")
#context assert.eq(e.query(wobble.with(data: "match"), before: here()).len(), 1)
#context assert.eq(e.query(wobble.with(data: "match"), after: here()).len(), 2)
#wobble(data: "match")
#wobble(data: "match")
