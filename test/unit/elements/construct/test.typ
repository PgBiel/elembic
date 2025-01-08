#import "/test/unit/base.typ": template
#show: template

#import "/src/lib.typ" as e: field

#let wock = e.element.declare(
  "wock",
  display: it => {
    assert.eq(it.color, yellow)
    assert.eq(it.inner, [Hello!])
  },
  fields: (
    field("color", color, default: red),
    field("inner", content, default: [Hello!])
  ),
  prefix: ""
)

#let dock = e.element.declare(
  "dock",
  construct: constructor => {
    (a: red, b: 10%) => {
      stack(
        dir: ltr,
        circle(fill: red, radius: 5pt),
        constructor(color: a.lighten(b)),
        circle(fill: orange, radius: 5pt)
      )
    }
  },
  display: it => {
    rect(fill: it.color, width: 20pt, height: 10pt)
  },
  fields: (
    field("color", color, default: red),
    field("inner", content, default: [Hello!])
  ),
  prefix: ""
)

#wock(color: yellow)
#dock(a: blue, b: 70%)
