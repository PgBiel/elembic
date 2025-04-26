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

#show: e.stateful.enable()
#show: e.named("abc", e.filtered(wibble.with(number: 10), e.named("inner", e.stateful.set_(wobble, color: orange))))

#wibble(
  number: 10,
  run: it => wobble(run: it => {
    assert.eq(it.color, orange)
    assert.eq(it.inner, [Hello!])
  })
)

#[
  #show: e.stateful.revoke("abc")

  #wibble(
    number: 10,
    run: it => wobble(run: it => {
      assert.eq(it.color, red)
      assert.eq(it.inner, [Hello!])
    })
  )
]

#[
  #show: e.stateful.revoke("inner") // this should have no effect (rule not yet applied)

  #wibble(
    number: 10,
    run: it => {
      wobble(run: it => {
        assert.eq(it.color, orange)
        assert.eq(it.inner, [Hello!])
      })

      show: e.stateful.revoke("abc") // too late (filter already applied)

      wobble(run: it => {
        assert.eq(it.color, orange)
        assert.eq(it.inner, [Hello!])
      })

      show: e.stateful.revoke("inner") // now it should work

      wobble(run: it => {
        assert.eq(it.color, red)
        assert.eq(it.inner, [Hello!])
      })
    }
  )
]
