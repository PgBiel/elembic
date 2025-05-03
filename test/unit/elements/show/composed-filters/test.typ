/// Test show rules with composed filters.

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

#let match-counter = counter("matches")
#show: e.show_(e.filters.or_(wibble, wobble.with(data: "match"), wobble.with(data: "also match")), it => match-counter.step() + it)

#wobble(data: "no match")
#wobble(data: "match")
#wobble(data: "also match")
#wibble()

#context assert.eq(match-counter.get(), (3,))
