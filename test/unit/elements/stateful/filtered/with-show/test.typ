/// Test filtered cond-set rules.

#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: field, types

#let wibble = e.element.declare(
  "wibble",
  display: it => {
    (it.run)(it)
  },
  fields: (
    field("number", int, default: 5),
    field("data", str, default: "data"),
    field("run", function, default: panic),
  ),
  prefix: ""
)

#let wobble = e.element.declare(
  "wobble",
  display: it => {
    (it.run)(it)
  },
  fields: (
    field("color", color, default: red),
    field("inner", content, default: [Hello!]),
    field("run", function, default: panic),
  ),
  prefix: ""
)

#let test-state = state("test-state", ())
#show: e.stateful.enable()
#show: e.filtered(wibble.with(number: 10), e.stateful.show_(wobble.with(inner: [Append]), it => {
  test-state.update(a => a + (e.fields(it).color,))
  it
}))

#wibble(
  number: 10,
  run: it => wobble(
    color: orange,
    inner: [Append],
    run: it => {}
  )
)

#wibble(
  number: 10,
  run: it => wobble(
    color: green,
    inner: [Do Not Append],
    run: it => {}
  )
)

#wibble(
  number: 20,
  run: it => wobble(
    color: yellow,
    inner: [Append],
    run: it => {}
  )
)

#context assert.eq(test-state.get(), (orange,))
