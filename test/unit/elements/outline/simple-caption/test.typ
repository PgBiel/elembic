#import "/test/unit/base.typ": template
#show: template
#set text(5pt)
#set outline(title: box(circle(fill: black, radius: 2.5pt)), fill: box(width: 1fr, stroke: (bottom: black)))

#import "/src/lib.typ" as e: field

#let wock = e.element.declare(
  "wock",
  display: it => {
    rect(width: 5pt, height: 2.5pt, fill: it.color)
  },
  fields: (
    field("color", color, default: red),
    field("inner", content, default: [Hello!])
  ),
  outline: (caption: box(rect(width: 5pt, height: 2.5pt, fill: green))),
  prefix: ""
)

#outline(target: e.selector(wock, outline: true))
#wock(color: blue)
#wock(color: red)
