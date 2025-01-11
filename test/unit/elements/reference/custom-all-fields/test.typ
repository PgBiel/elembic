#import "/test/unit/base.typ": template
#show: template
#set text(5pt)

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
    field("supplement", e.types.option(content), default: [Wock]),
    field("numbering", e.types.option(e.types.union(str, function)), default: "1"),
  ),
  reference: (
    supplement: [],
    numbering: "1.",
    custom: it => box(circle(radius: 2.5pt, fill: it.color))
  ),
  prefix: ""
)

#wock(color: blue, label: <my-wock>)
#wock(color: red, label: <my-wock2>, supplement: [def])
#wock(color: green, label: <my-wock3>, supplement: [def], numbering: "a")

@my-wock ; @my-wock2 ; @my-wock3
