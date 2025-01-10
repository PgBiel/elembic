#import "/test/unit/base.typ": template
#show: template
#set text(5pt)

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
    supplement: [Wock],
    numbering: "1.1"
  ),
  prefix: ""
)

#wock(label: <my-wock>)
@my-wock

#wock(depth: 2, label: <my-wock2>)
@my-wock2[abc]
