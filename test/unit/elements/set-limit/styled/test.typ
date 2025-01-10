#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: field

#let wock = e.element.declare(
  "wock",
  display: it => {},
  fields: (
    field("color", color, default: blue),
    field("inner", content, default: [])
  ),
  prefix: ""
)

#let setter = e.set_(wock, color: red)
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter // 10
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter // 20
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter // 30
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter // 40
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter // 50
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter // 60
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter // 70
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: e.apply(
  setter,
  e.set_(wock, inner: [Road]),
)
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter // 80
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter // 90
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))
#show: setter
#set outline(title: [Roadster])
#set bibliography(title: [Mount])
#show: e.set_(wock, color: yellow) // 100
#set table(fill: red)
#set box(stroke: black)
#set list(marker: ("a", "b"))

#wock()
#e.get(get => assert.eq(get(wock).color, yellow))
#e.get(get => assert.eq(get(wock).inner, [Road]))

#context {
  assert.eq(outline.title, [Roadster])
  assert.eq(bibliography.title, [Mount])
  assert.eq(table.fill, red)
  assert.eq(box.stroke, stroke(black))
  assert.eq(list.marker, ([a], [b]))
}
