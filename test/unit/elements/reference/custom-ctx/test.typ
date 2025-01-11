#import "/test/unit/base.typ": template
#show: template
#set text(5pt)

#import "/src/lib.typ" as e: field

#show ref: e.ref

#let dock = e.element.declare(
  "dock",
  display: it => {},
  fields: (
    field("color", color, default: red),
    field("func", function, default: () => {}),
  ),
  prefix: ""
)

#show: e.set_(dock, color: purple)
#show: e.set_(dock, func: circle)

#let wock = e.element.declare(
  "wock",
  display: it => {
    // Context assigns the purple color
    rect(width: 5pt, height: 2.5pt, fill: (e.ctx(it).get)(dock).color)
  },
  fields: (
    field("color", color, default: red),
    field("inner", content, default: [Hello!]),
    field("supplement", e.types.option(content), default: [Wock]),
    field("numbering", e.types.option(e.types.union(str, function)), default: "1"),
  ),
  reference: (
    supplement: it => {
      // Context assigns the circle function
      let (get, ..) = e.ctx(it)
      let func = get(dock).func
      box(func(radius: 2.5pt, fill: it.color))
    },

    // Context provides the element's counter
    numbering: it => _ => e.counter(it).display("A"),
  ),
  prefix: ""
)

#wock(color: blue, label: <my-wock>)
#wock(color: red, label: <my-wock2>, supplement: [def])
#wock(color: green, label: <my-wock3>, supplement: [def], numbering: "a")

@my-wock ; @my-wock2 ; @my-wock3
