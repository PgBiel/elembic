#import "/test/unit/base.typ": template
#show: template
#set text(5pt)
#let outline-fill = box(width: 1fr, stroke: (bottom: black))
#set outline(title: box(circle(fill: black, radius: 2.5pt)))
#set outline(fill: outline-fill) if sys.version < version(0, 13, 0)
#set outline.entry(fill: outline-fill) if sys.version >= version(0, 13, 0)

#import "/src/lib.typ" as e: field

#show: e.prepare()

#let wock = e.element.declare(
  "wock",
  display: it => {
    rect(width: 5pt, height: 2.5pt, fill: it.color)
  },
  fields: (
    field("color", color, default: red),
    field("inner", content, default: [Hello!])
  ),
  reference: (
    supplement: box(circle(radius: 2.5pt, fill: green)),
    numbering: "1"
  ),
  outline: (caption: it => box(rect(width: 2.5pt, height: 2.5pt, fill: it.color))),
  prefix: ""
)

#outline(target: e.selector(wock, outline: true))

#wock(color: blue)
// @my-wock

#wock(color: red, label: <my-wock2>)
@my-wock2
