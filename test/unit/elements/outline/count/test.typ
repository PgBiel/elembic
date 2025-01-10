#import "/test/unit/base.typ": template
#show: template
#set text(5pt)
#set outline(title: box(circle(fill: black, radius: 2.5pt)), fill: box(width: 1fr, stroke: (bottom: black)))

#import "/src/lib.typ" as e: field

#show ref: e.ref

#let wock = e.element.declare(
  "wock",
  display: it => {
    rect(width: 2.5pt, height: 2.5pt, fill: blue)
  },
  fields: (
    field("depth", int, default: 1),
    field("offset", int, default: 0),
    field("run", function, default: () => {})
  ),
  synthesize: it => {
    it.level = it.depth + it.offset
    it
  },
  count: c => it => c.step(level: it.level),
  reference: (
    supplement: box(circle(radius: 2.5pt, fill: green)),
    numbering: "1.1"
  ),
  outline: auto,
  prefix: ""
)

#outline(target: e.selector(wock, outline: true))

#wock(label: <my-wock>)
#wock(depth: 2, label: <my-wock2>)
@my-wock2
