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

#show heading: it => [#it#it]

= aest
#context assert.eq(query(heading).len(), 1)

#show: e.show_(wibble, w => [#w#w])

#wibble()
#context assert.eq(e.query(wibble).len(), 1)
