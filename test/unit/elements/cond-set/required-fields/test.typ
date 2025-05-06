/// Test conditional set rules.

#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: field, types

#let wibble = e.element.declare(
  "wibble",
  display: it => (it.run)(it),
  fields: (
    field("number", int, required: true),
    field("data", str, default: "data"),
    field("run", function, default: panic)
  ),
  prefix: ""
)

#let wobble = e.element.declare(
  "wobble",
  display: it => (it.run)(it),
  fields: (
    field("number", int, required: true, named: true),
    field("data", str, default: "data"),
    field("run", function, default: panic)
  ),
  prefix: ""
)

#show: e.cond-set(wibble, data: "set")
#show: e.cond-set(wobble, data: "set")

#wibble(
  4,
  run: it => assert.eq(it.data, "set")
)

#wobble(
  number: 10,
  run: it => assert.eq(it.data, "set")
)
