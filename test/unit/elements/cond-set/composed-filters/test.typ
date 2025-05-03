/// Test cond-set rules with composed filters.

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
    field("data", str, default: "data"),
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

#show: e.cond-set(e.filters.or_(wobble.with(inner: [also green]), wobble.with(inner: [green children])), color: green)
#show: e.cond-set(
  e.filters.or_(
    e.filters.and_(
      wobble.with(color: red),
      wobble.with(data: "match me")
    ),
    e.filters.xor(
      wobble.with(color: blue),
      wobble.with(data: "non-blue"),
    )
  ),
  inner: [matched!]
)

#wobble(run: it => {
  assert.eq(it.color, red)
  assert.eq(it.inner, [Hello!])
})

#wobble(
  inner: [green children],
  run: it => {
    assert.eq(it.color, green)
    assert.eq(it.inner, [green children])
  }
)

#wobble(
  inner: [also green],
  run: it => {
    assert.eq(it.color, green)
    assert.eq(it.inner, [also green])
  }
)

#wobble(
  inner: [not green children],
  run: it => {
    assert.eq(it.color, red)
    assert.eq(it.inner, [not green children])
  }
)

// Test AND
#wobble(
  color: red,
  data: "match me",
  run: it => {
    assert.eq(it.color, red)
    assert.eq(it.inner, [matched!])
  }
)
#wobble(
  color: red,
  run: it => {
    assert.eq(it.color, red)
    assert.eq(it.inner, [Hello!])
  }
)
#wobble(
  color: green,
  data: "match me",
  run: it => {
    assert.eq(it.color, green)
    assert.eq(it.inner, [Hello!])
  }
)

// Test XOR
#wobble(
  color: blue,
  data: "blue",
  run: it => {
    assert.eq(it.color, blue)
    assert.eq(it.inner, [matched!])
  }
)
#wobble(
  color: green,
  data: "non-blue",
  run: it => {
    assert.eq(it.color, green)
    assert.eq(it.inner, [matched!])
  }
)
#wobble(
  color: blue,
  data: "non-blue",
  run: it => {
    assert.eq(it.color, blue)
    assert.eq(it.inner, [Hello!])
  }
)


// Test NOT, custom filters
#show: e.reset()
#show: e.cond-set(
  e.filters.or_(
    e.filters.and_(
      wobble,
      e.filters.custom((it, ..) => it.data.len() == 3)
    ),
    e.filters.and_(
      wobble,
      e.filters.not_(wobble.with(data: "dont"))
    ),
  ),
  inner: [yay!]
)

// Test custom and not
#wobble(data: "dont", run: it => assert.eq(it.inner, [Hello!]))
#wobble(data: "abc", run: it => assert.eq(it.inner, [yay!]))
#wobble(data: "doit", run: it => assert.eq(it.inner, [yay!]))
