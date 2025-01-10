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
    field("inner", content, default: [Hello!]),
    field("supplement", e.types.option(content), default: box(rect(fill: purple, width: 2.5pt, height: 2.5pt))),
    field("numbering", e.types.option(e.types.union(str, function)), default: "1"),
  ),
  reference: (
    supplement: it => it.supplement,
    numbering: it => it.numbering,
  ),
  outline: auto,
  prefix: ""
)

#outline(target: e.selector(wock, outline: true))
#wock(color: blue, label: <my-wock>)
#wock(color: blue, label: <my-wock2>, supplement: box(circle(fill: orange, radius: 2.5pt)))
#wock(color: blue, label: <my-wock3>, supplement: box(circle(fill: orange, radius: 2.5pt)), numbering: "a")

@my-wock2
