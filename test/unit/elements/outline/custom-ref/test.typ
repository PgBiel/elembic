#import "/test/unit/base.typ": template
#show: template
#set text(5pt)
#set outline(title: box(circle(fill: black, radius: 2.5pt)), fill: box(width: 1fr, stroke: (bottom: black)))

#import "/src/lib.typ" as e: field

#show ref: e.ref

#let wock = e.element.declare(
  "wock",
  display: it => {
    rect(width: 5pt, height: 2.5pt, fill: it.color)
  },
  fields: (
    field("color", color, default: red),
    field("inner", content, default: [Hello!])
  ),

  // Outline just copies the reference if there's just 'custom'
  reference: (
    custom: _ => box(circle(radius: 2.5pt, fill: orange)),
  ),
  outline: auto,
  prefix: ""
)

#outline(target: e.selector(wock, outline: true))

#wock(color: blue)
// @my-wock

#wock(color: blue, label: <my-wock2>)
@my-wock2
