#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: field

#let wock = e.element.declare(
  "wock",
  display: it => {},
  fields: (
    field("color", color, default: red),
    field("size", length, default: 10pt)
  ),
  prefix: ""
)

#e.select(wock.with(color: blue), prefix: "sel1", blue-wock => [
  #wock(color: orange, size: 10pt)
  #wock(color: blue, size: 10pt)
])

#e.select(wock.with(color: red), prefix: "sel2", red-wock => [
  #wock(color: red, size: 20pt)
  #wock(color: green, size: 20pt)

  #context assert.eq(query(red-wock).len(), 1)
])

#e.select(wock.with(color: yellow), prefix: "sel1", yellow-wock => [
  #wock(color: yellow, size: 20pt)
  #wock(color: purple, size: 20pt)

  // Clashes with the other one with sel1
  #context assert.eq(query(yellow-wock).len(), 2)
])
