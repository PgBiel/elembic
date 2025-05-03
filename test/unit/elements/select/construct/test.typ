#import "/test/unit/base.typ": template
#show: template

#import "/src/lib.typ" as e: field

#let dock = e.element.declare(
  "dock",
  construct: constructor => {
    (a: red, b: 10%) => {
      stack(
        dir: ltr,
        circle(fill: red, radius: 3pt),
        constructor(color: a.lighten(b)),
        circle(fill: orange, radius: 3pt)
      )
    }
  },
  display: it => {
    rect(fill: it.color, width: 12pt, height: 7pt)
  },
  fields: (
    field("color", color, default: red),
    field("inner", content, default: [Hello!])
  ),
  prefix: ""
)

#e.select(dock.with(color: yellow.lighten(40%)), yellow-dock => {
  show yellow-dock: it => {
    assert.eq(e.data(it).fields.color, yellow.lighten(40%))

    scale(40%, it)
  }

  dock(a: yellow, b: 40%)
  dock(a: blue, b: 40%)

  e.select(dock.with(color: blue.lighten(20%)), blue-dock => {
    show blue-dock: set rect(stroke: green + 2pt)
    dock(a: blue, b: 20%)
  })
})
