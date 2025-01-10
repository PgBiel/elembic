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
    field("inner", content, default: [Hello!])
  ),
  reference: (
    supplement: [Wock],
    numbering: "1"
  ),
  prefix: ""
)

#wock(color: blue, label: <my-wock>)
@my-wock

#wock(color: blue, label: <my-wock2>)
@my-wock2[abc]
