#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: field

#let wock = e.element.declare(
  "wock",
  display: _ => {},
  fields: (
    field("color", color, default: red),
    field("thing", color, default: blue),
  ),
  prepare: (wock, doc) => {
    set text(red)
    show: e.set_(wock, thing: yellow)
    doc
  },
  prefix: ""
)

#let dock = e.element.declare(
  "dock",
  display: _ => {},
  fields: (),
  prepare: (_, doc) => {
    show: e.set_(wock, color: blue)
    doc
  },
  prefix: ""
)

#show: e.prepare(wock, dock)

#wock()
#dock()

#context assert.eq(text.fill, red)
#e.get(get => assert.eq(get(wock).color, blue))
#e.get(get => assert.eq(get(wock).thing, yellow))
