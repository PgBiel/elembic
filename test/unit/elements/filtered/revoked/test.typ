/// Test filtered rules.

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

#let assert-fields(num, data, clr, inner) = {
  wibble(run: it => assert.eq(it.number, num))
  wibble(run: it => assert.eq(it.data, data))
  wobble(run: it => assert.eq(it.color, clr))
  wobble(run: it => assert.eq(it.inner, inner))
}

#show: e.named("abc", e.filtered(wibble.with(number: 10), e.set_(wobble, color: orange)))

#wibble(
  number: 10,
  run: it => wobble(run: it => {
    assert.eq(it.color, orange)
    assert.eq(it.inner, [Hello!])
  })
)

#show: e.revoke("abc")

#wibble(
  number: 10,
  run: it => wobble(run: it => {
    assert.eq(it.color, red)
    assert.eq(it.inner, [Hello!])
  })
)
