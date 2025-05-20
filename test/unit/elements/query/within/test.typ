/// Test query with composed filters.

#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: field, types

#let wibble = e.element.declare(
  "wibble",
  display: it => it.inner,
  fields: (
    field("color", color, default: red),
    field("data", str, default: "data"),
    field("inner", content, default: [Hello!]),
  ),
  prefix: ""
)

#let wobble = e.element.declare(
  "wobble",
  display: it => it.inner,
  fields: (
    field("color", color, default: red),
    field("data", str, default: "data"),
    field("inner", content, default: [Hello!]),
  ),
  prefix: ""
)

#[
  #wibble(color: blue, inner: wobble(color: red))
  #show: e.settings(track-ancestry: "any")
  #wibble(color: yellow, inner: wobble(color: purple))

  #context assert.eq(e.query(e.filters.and_(wobble, e.within(wibble))).len(), 1)
  #context assert.eq(e.query(e.filters.and_(wobble, e.within(wibble.with(color: yellow)))).len(), 1)
  #context assert.eq(e.query(e.filters.and_(wobble, e.within(wibble.with(color: red)))).len(), 0)
]

#let wibble = e.element.declare(
  "wibble2",
  display: it => it.inner,
  fields: (
    field("color", color, default: red),
    field("data", str, default: "data"),
    field("inner", content, default: [Hello!]),
  ),
  prefix: ""
)

#let wobble = e.element.declare(
  "wobble2",
  display: it => it.inner,
  fields: (
    field("color", color, default: red),
    field("data", str, default: "data"),
    field("inner", content, default: [Hello!]),
  ),
  prefix: ""
)

#[
  #wibble(color: blue, inner: wobble(color: red))
  #show: e.settings(track-ancestry: (wibble,), store-ancestry: (wobble,))
  #wibble(color: yellow, inner: wobble(color: purple))
  #wibble(color: orange, inner: wibble(color: blue, inner: wobble(color: purple)))
  #wibble(color: orange, inner: wobble(color: purple))

  #context assert.eq(e.query(e.filters.and_(wobble, e.within(wibble))).len(), 3)
  #context assert.eq(e.query(e.filters.and_(wobble, e.within(wibble.with(color: yellow)))).len(), 1)
  #context assert.eq(e.query(e.filters.and_(wobble, e.within(wibble.with(color: red)))).len(), 0)
  #context assert.eq(e.query(e.filters.and_(wobble, e.within(wibble.with(color: orange), max-depth: 1))).len(), 1)
  #context assert.eq(e.query(e.filters.and_(wobble, e.within(wibble.with(color: orange), max-depth: 2))).len(), 2)
]
