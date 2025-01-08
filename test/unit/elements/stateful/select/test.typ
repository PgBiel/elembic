#import "/test/unit/base.typ": template
#show: template

#import "/src/lib.typ" as e: field

#show rect: block.with(above: 0pt, below: 3pt)

#show: e.stateful.enable()

#let wock = e.element.declare(
  "wock",
  display: it => {
    rect(fill: it.color, width: it.size, height: 10pt)
  },
  fields: (
    field("color", color, default: red),
    field("size", length, default: 10pt)
  )
)

#(e.data(wock).where)(color: blue, blue-wock => (e.data(wock).where)(size: 20pt, wide-wock => [
  #show blue-wock: it => {
    // TODO
    // let (fields,) = e.data(it)
    // assert.eq(fields.color, blue)
    set rect(stroke: orange)
    it
  }
  #show wide-wock: it => {
    // TODO
    // let (fields,) = e.data(it)
    // assert.eq(fields.size, 20pt)
    set rect(stroke: 2pt)
    it
  }

  #wock(color: red, size: 10pt)
  #wock(color: blue, size: 10pt)
  #wock(color: red, size: 20pt)
  #wock(color: blue, size: 20pt)

  #[
    #show: e.set_(wock, size: 20pt)
    #wock(color: red)
  ]

  #[
    #show: e.stateful.set_(wock, size: 20pt)
    #wock(color: red)
  ]
]))
