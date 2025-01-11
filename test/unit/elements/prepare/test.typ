#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: field

#let wock = e.element.declare(
  "wock",
  display: it => {},
  fields: (
    field("color", color, default: red),
  ),
  prepare: doc => {
    set text(red)
    doc
  },
  prefix: ""
)

#let dock = e.element.declare(
  "dock",
  display: it => {},
  fields: (
    field("color", color, default: red),
  ),
  prepare: doc => {
    show: e.set_(wock, color: blue)
    doc
  },
  prefix: ""
)

#show: e.prepare(wock, dock)

#context assert.eq(text.fill, red)
#e.get(get => assert.eq(get(wock).color, blue))
