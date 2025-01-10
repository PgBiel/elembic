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

#v(5em) <labeled>
#h(5em)

#show: setter

#v(5em) <labeled>
#h(5em)

#show: setter

#v(5em) <labeled>
#h(5em)

#show: setter

#v(5em) <labeled>
#h(5em)

#show: setter

#v(5em) <labeled>
#h(5em)

#show: setter

#v(5em) <labeled>
#h(5em)

#show: setter

#v(5em) <labeled>
#h(5em)

#show: setter

#v(5em) <labeled>
#h(5em)

#show: setter

#v(5em) <labeled>
#h(5em)

#show: setter

#v(5em) <labeled>
#h(5em)

#show: setter // 10

#v(5em) <labeled>
#h(5em)

#show: setter

#v(5em) <labeled>
#h(5em)

#show: setter

#v(5em) <labeled>
#h(5em)

#show: setter

#v(5em) <labeled>
#h(5em)

#show: setter

#v(5em) <labeled>
#h(5em)

#show: setter

#v(5em) <labeled>
#h(5em)

#show: setter

#v(5em) <labeled>
#h(5em)

#show: setter

#v(5em) <labeled>
#h(5em)

#show: setter

#v(5em) <labeled>
#h(5em)

#show: setter

#v(5em) <labeled>
#h(5em)

#show: setter // 20

#v(5em) <labeled>
#h(5em)

#show: setter

#v(5em) <labeled>
#h(5em)

#show: setter

#v(5em) <labeled>
#h(5em)

#show: setter

#v(5em) <labeled>
#h(5em)

#show: setter

#v(5em) <labeled>
#h(5em)

#show: setter

#v(5em) <labeled>
#h(5em)

#show: setter

#v(5em) <labeled>
#h(5em)

#show: setter

#v(5em) <labeled>
#h(5em)

#show: setter

#v(5em) <labeled>
#h(5em)

#show: setter

#v(5em) <labeled>
#h(5em)

// #show: setter // 30

// #v(5em) <labeled>
// #h(5em)

// #show: setter

// #v(5em) <labeled>
// #h(5em)

// #show: setter

// #v(5em) <labeled>
// #h(5em)

// #show: setter

// #v(5em) <labeled>
// #h(5em)

// #show: setter

// #v(5em) <labeled>
// #h(5em)

// #show: setter

// #v(5em) <labeled>
// #h(5em)

// #show: setter

// #v(5em) <labeled>
// #h(5em)

// #show: setter

// #v(5em) <labeled>
// #h(5em)

// #show: setter

// #v(5em) <labeled>
// #h(5em)

// #show: setter

// #v(5em) <labeled>
// #h(5em)

// #show: setter // 40

// #v(5em) <labeled>
// #h(5em)

// #show: setter

// #v(5em) <labeled>
// #h(5em)

// #show: setter

// #v(5em) <labeled>
// #h(5em)

// #show: setter

// #v(5em) <labeled>
// #h(5em)

// #show: setter

// #v(5em) <labeled>
// #h(5em)

// #show: setter

// #v(5em) <labeled>
// #h(5em)

// #show: setter

// #v(5em) <labeled>
// #h(5em)

// #show: setter

// #v(5em) <labeled>
// #h(5em)

// #show: setter

// #v(5em) <labeled>
// #h(5em)

// #show: setter

// #v(5em) <labeled>
// #h(5em)

// #show: setter // 50

// #v(5em) <labeled>
// #h(5em)

// #show: setter

// #v(5em) <labeled>
// #h(5em)

// #show: setter

// #v(5em) <labeled>
// #h(5em)

// #show: setter

// #v(5em) <labeled>
// #h(5em)

// #show: setter

// #v(5em) <labeled>
// #h(5em)

// #show: setter

// #v(5em) <labeled>
// #h(5em)

// #show: setter

// #v(5em) <labeled>
// #h(5em)

// #show: setter

// #v(5em) <labeled>
// #h(5em)

// #show: setter

// #v(5em) <labeled>
// #h(5em)

// #show: setter

// #v(5em) <labeled>
// #h(5em)

// #show: setter // 60

// #v(5em) <labeled>
// #h(5em)

// #show: setter

// #v(5em) <labeled>
// #h(5em)

// #show: setter

// #v(5em) <labeled>
// #h(5em)

// #show: setter

// #v(5em) <labeled>
// #h(5em)

// #show: setter

// #v(5em) <labeled>
// #h(5em)

// #show: setter

// #v(5em) <labeled>
// #h(5em)

// #show: setter

// #v(5em) <labeled>
// #h(5em)

// #show: setter

// #v(5em) <labeled>
// #h(5em)

// #show: setter

// #v(5em) <labeled>
// #h(5em)

// #show: setter

// #v(5em) <labeled>
// #h(5em)

// #show: setter // 70

// #v(5em) <labeled>
// #h(5em)

// #show: setter

// #v(5em) <labeled>
// #h(5em)

// #show: setter

// #v(5em) <labeled>
// #h(5em)

// #show: setter

// #v(5em) <labeled>
// #h(5em)

// #show: setter

// #v(5em) <labeled>
// #h(5em)

// #show: setter

// #v(5em) <labeled>
// #h(5em)

// #show: setter

// #v(5em) <labeled>
// #h(5em)

// #show: setter

// #v(5em) <labeled>
// #h(5em)

// #show: e.apply(
//   setter,
//   e.set_(wock, inner: [Road]),
// )

// #v(5em) <labeled>
// #h(5em)

// #show: setter

// #v(5em) <labeled>
// #h(5em)

// #show: setter // 80

// #v(5em) <labeled>
// #h(5em)

// #show: setter

// #v(5em) <labeled>
// #h(5em)

// #show: setter

// #v(5em) <labeled>
// #h(5em)

// #show: setter

// #v(5em) <labeled>
// #h(5em)

// #show: setter

// #v(5em) <labeled>
// #h(5em)

// #show: setter

// #v(5em) <labeled>
// #h(5em)

// #show: setter

// #v(5em) <labeled>
// #h(5em)

// #show: setter

// #v(5em) <labeled>
// #h(5em)

// #show: setter

// #v(5em) <labeled>
// #h(5em)

// #show: setter

// #v(5em) <labeled>
// #h(5em)

// #show: setter // 90

// #v(5em) <labeled>
// #h(5em)

// #show: setter

// #v(5em) <labeled>
// #h(5em)

// #show: setter

// #v(5em) <labeled>
// #h(5em)

// #show: setter

// #v(5em) <labeled>
// #h(5em)

// #show: setter

// #v(5em) <labeled>
// #h(5em)

// #show: setter

// #v(5em) <labeled>
// #h(5em)

// #show: setter

// #v(5em) <labeled>
// #h(5em)

// #show: setter

// #v(5em) <labeled>
// #h(5em)

// #show: setter
// #set outline(title: [Roadster])
// #set bibliography(title: [Mount])
// #show: e.set_(wock, color: yellow) // 100

#v(5em) <labeled>
#h(5em)

#wock()
