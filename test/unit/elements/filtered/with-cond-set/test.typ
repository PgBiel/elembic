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

#let assert-fields(num, data, clr, inner) = {
  wibble(run: it => assert.eq(it.number, num))
  wibble(run: it => assert.eq(it.data, data))
  wobble(run: it => assert.eq(it.color, clr))
  wobble(run: it => assert.eq(it.inner, inner))
}

#show: e.filtered(wibble.with(number: 10), e.cond-set(wobble.with(inner: [Bye]), color: orange))

#wibble(
  number: 10,
  run: it => wobble(
    inner: [Bye],
    run: it => {
      assert.eq(it.color, orange)
      assert.eq(it.inner, [Bye])
    }
  )
)

#wibble(
  number: 10,
  run: it => wobble(
    inner: [Not Bye],
    run: it => {
      assert.eq(it.color, red)
      assert.eq(it.inner, [Not Bye])
    }
  )
)

#wibble(
  number: 20,
  run: it => wobble(
    inner: [Bye],
    run: it => {
      assert.eq(it.color, red)
      assert.eq(it.inner, [Bye])
    }
  )
)

#wibble(
  number: 10,
  run: it => wobble(run: it => {
    assert.eq(it.color, red)
    assert.eq(it.inner, [Hello!])
  })
)
