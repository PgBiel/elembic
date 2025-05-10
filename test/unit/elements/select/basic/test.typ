#import "/test/unit/base.typ": template
#show: template

#import "/src/lib.typ" as e: field

#show rect: block.with(above: 0pt, below: 3pt)

#let wock = e.element.declare(
  "wock",
  display: it => {
    rect(fill: it.color, width: it.size, height: 10pt)
  },
  fields: (
    field("color", color, default: red),
    field("size", length, default: 10pt)
  ),
  prefix: ""
)

#e.select(wock.with(color: blue), wock.with(size: 20pt), prefix: "sel1", (blue-wock, wide-wock) => [
  #show blue-wock: it => {
    let (fields,) = e.data(it)
    assert.eq(fields.color, blue)
    set rect(stroke: orange)
    it
  }
  #show wide-wock: it => {
    let (fields,) = e.data(it)
    assert.eq(fields.size, 20pt)
    set rect(stroke: 2pt)
    it
  }

  #wock(color: red, size: 10pt)
  #wock(color: blue, size: 10pt)
  #wock(color: red, size: 20pt)
  #wock(color: blue, size: 20pt)
])
