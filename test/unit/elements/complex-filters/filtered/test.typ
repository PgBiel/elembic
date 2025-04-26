
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

#show: e.filtered(e.filters.or_(wibble.with(number: 10), wobble.with(inner: [green children])), e.set_(wobble, color: green))
#show: e.filtered(
  e.filters.or_(
    e.filters.and_(
      wibble.with(number: 10),
      wibble.with(data: "entity")
    ),
    e.filters.xor(
      wobble.with(color: blue),
      wobble.with(inner: [match child]),
    )
  ),
  e.set_(wobble, inner: [matched!])
)

#wibble(
  number: 10,
  run: it => wobble(run: it => {
    assert.eq(it.color, green)
    assert.eq(it.inner, [Hello!])
  })
)

#wobble(
  inner: [green children],
  run: it => wobble(run: it => {
    assert.eq(it.color, green)
    assert.eq(it.inner, [Hello!])
  })
)

#wobble(
  inner: [not green children],
  run: it => wobble(run: it => {
    assert.eq(it.color, red)
    assert.eq(it.inner, [Hello!])
  })
)

#wibble(
  number: 20,
  run: it => wobble(run: it => {
    assert.eq(it.color, red)
    assert.eq(it.inner, [Hello!])
  })
)

#wibble(
  number: 30,
  run: it => wobble(run: it => {
    assert.eq(it.color, red)
    assert.eq(it.inner, [Hello!])
  })
)

// test second filter

// Test AND
#wibble(
  number: 10,
  data: "entity",
  run: it => wobble(run: it => {
    assert.eq(it.color, green)
    assert.eq(it.inner, [matched!])
  })
)

#wibble(
  data: "entity",
  run: it => wobble(run: it => {
    assert.eq(it.color, red)
    assert.eq(it.inner, [Hello!])
  })
)

#wibble(
  number: 10,
  run: it => wobble(run: it => {
    assert.eq(it.color, green)
    assert.eq(it.inner, [Hello!])
  })
)

// Test XOR
#wobble(
  inner: [match child],
  run: it => wobble(run: it => {
    assert.eq(it.color, red)
    assert.eq(it.inner, [matched!])
  })
)

#wobble(
  color: blue,
  run: it => wobble(run: it => {
    assert.eq(it.color, red)
    assert.eq(it.inner, [matched!])
  })
)

#wobble(
  inner: [match child],
  color: blue,
  run: it => wobble(run: it => {
    assert.eq(it.color, red)
    assert.eq(it.inner, [Hello!])
  })
)

#show: e.reset()
#show: e.filtered(
  e.filters.or_(
    e.filters.and_(
      wobble,
      e.filters.custom(wobble, (it, ..) => it.inner.func() == strong)
    ),
    e.filters.and_(
      wibble,
      e.filters.not_(wibble.with(number: 10))
    )
  ),
  e.set_(wobble, inner: [yay!])
)

#let assert-wobble-has-inner(inner) = {
  wobble(run: it => assert.eq(it.inner, inner))
}

// Test custom
#wobble(inner: [not strong], run: it => assert-wobble-has-inner([Hello!]))
#wobble(inner: [*strong*], run: it => assert-wobble-has-inner([yay!]))

// Test NOT
#wibble(number: 10, run: it => assert-wobble-has-inner([Hello!]))
#wibble(number: 20, run: it => assert-wobble-has-inner([yay!]))
