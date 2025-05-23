/// Test filtered rules with composed filters.

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

#show: e.filtered(
  e.filters.or_(
    wibble.with(number: 10),
    e.filters.and_(wibble, e.within(wobble.with(inner: [green children])))
  ),
  e.set_(wobble, color: green)
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
    assert.eq(it.color, red)
    assert.eq(it.inner, [Hello!])
  })
)

#wobble(
  inner: [green children],
  run: it => wibble(run: it => wobble(run: it => {
    assert.eq(it.color, green)
    assert.eq(it.inner, [Hello!])
  }))
)

#wobble(
  inner: [not green children],
  run: it => wibble(run: it => wobble(run: it => {
    assert.eq(it.color, red)
    assert.eq(it.inner, [Hello!])
  }))
)

// test within on custom

// Only match children of non-"entity"
#show: e.filtered(
  e.filters.and_(
    wobble,
    e.filters.not_(e.filters.custom((it, ancestry: (), ..) => ancestry.any(p => p.eid == e.eid(wibble) and p.fields.data == "entity")))
  ),
  e.set_(wobble, inner: [matched!])
)
#show: e.settings(track-ancestry: (wibble,))

// Test AND
#wibble(
  number: 10,
  data: "entity",
  run: it => wobble(run: it => wobble(run: it => {
    // Descendant of an "entity", so no match
    assert.eq(it.inner, [Hello!])
  }))
)

#wibble(
  number: 10,
  data: "not entity",
  run: it => wobble(run: it => wobble(run: it => {
    // Not descendant of an "entity", so match
    assert.eq(it.inner, [matched!])
  }))
)
