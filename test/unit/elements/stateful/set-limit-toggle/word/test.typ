#import "/test/unit/base.typ": empty
#show: empty
#show "abc": hide

#import "/src/lib.typ" as e: field

#let wock = e.element.declare(
  "wock",
  display: it => {},
  fields: (
    field("color", color, default: red),
    field("inner", content, default: [])
  )
)

#show: e.stateful.enable()

#show: e.set_(wock, color: red)
abc
#show: e.set_(wock, color: red)
abc
#show: e.set_(wock, color: red)
abc
#show: e.set_(wock, color: red)
abc
#show: e.set_(wock, color: red)
abc
#show: e.set_(wock, color: red)
abc
#show: e.set_(wock, color: red)
abc
#show: e.set_(wock, color: red)
abc
#show: e.set_(wock, color: red)
abc
#show: e.set_(wock, color: red)
abc
#show: e.set_(wock, color: red) // 10
abc
#show: e.set_(wock, color: red)
abc
#show: e.set_(wock, color: red)
abc
#show: e.set_(wock, color: red)
abc
#show: e.set_(wock, color: red)
abc
#show: e.set_(wock, color: red)
abc
#show: e.set_(wock, color: red)
abc
#show: e.set_(wock, color: red)
abc
#show: e.set_(wock, color: red)
abc
#show: e.set_(wock, color: red)
abc
#show: e.set_(wock, color: red) // 20
abc
#show: e.set_(wock, color: red)
abc
#show: e.set_(wock, color: red)
abc
#show: e.set_(wock, color: red)
abc
#show: e.set_(wock, color: red)
abc
#show: e.set_(wock, color: red)
abc
#show: e.set_(wock, color: red)
abc
#show: e.set_(wock, color: red)
abc
#show: e.set_(wock, color: red)
abc
#show: e.set_(wock, color: red)
abc
#show: e.set_(wock, color: red) // 30
abc
#show: e.set_(wock, color: red)
abc
#show: e.set_(wock, color: red)
abc
#show: e.set_(wock, color: red)
abc
#show: e.set_(wock, color: red)
abc
#show: e.set_(wock, color: red)
abc
#show: e.set_(wock, color: red)
abc
#show: e.set_(wock, color: red)
abc
#show: e.set_(wock, color: red)
abc
#show: e.set_(wock, color: red)
abc
#show: e.set_(wock, color: red) // 40
abc
#show: e.set_(wock, color: red)
abc
#show: e.set_(wock, color: red)
abc
#show: e.set_(wock, color: red)
abc
#show: e.set_(wock, color: red)
abc
#show: e.set_(wock, color: red)
abc
#show: e.set_(wock, color: red)
abc
#show: e.set_(wock, color: red)
abc
#show: e.set_(wock, color: red)
abc
#show: e.set_(wock, color: red)
abc
#show: e.set_(wock, color: red) // 50
abc
#show: e.set_(wock, color: red)
abc
#show: e.set_(wock, color: red)
abc
#show: e.set_(wock, color: red)
abc
#show: e.set_(wock, color: red)
abc
#show: e.set_(wock, color: red)
abc
#show: e.set_(wock, color: red)
abc
#show: e.set_(wock, color: red)
abc
// #show: e.set_(wock, color: red)
abc
// #show: e.set_(wock, color: red)
abc
// #show: e.set_(wock, color: red) // 60
abc
// #show: e.set_(wock, color: red)
abc
// #show: e.set_(wock, color: red)
abc
// #show: e.set_(wock, color: red)
abc
// #show: e.set_(wock, color: red)
abc
// #show: e.set_(wock, color: red)
abc
// #show: e.set_(wock, color: red)
abc
// #show: e.set_(wock, color: red)
abc
// #show: e.set_(wock, color: red)
abc
// #show: e.set_(wock, color: red)
abc
// #show: e.set_(wock, color: red) // 70
abc
// #show: e.set_(wock, color: red)
abc
// #show: e.set_(wock, color: red)
abc
// #show: e.set_(wock, color: red)
abc
// #show: e.set_(wock, color: red)
abc
// #show: e.set_(wock, color: red)
abc
// #show: e.set_(wock, color: red)
abc
// #show: e.set_(wock, color: red)
abc
// #show: e.set_(wock, color: red)
abc
// #show: e.set_(wock, color: red)
abc
// #show: e.set_(wock, color: red) // 80
abc
// #show: e.set_(wock, color: red)
abc
// #show: e.set_(wock, color: red)
abc
// #show: e.set_(wock, color: red)
abc
// #show: e.set_(wock, color: red)
abc
// #show: e.set_(wock, color: red)
abc
// #show: e.set_(wock, color: red)
abc
// #show: e.set_(wock, color: red)
abc
// #show: e.set_(wock, color: red)
abc
// #show: e.set_(wock, color: red)
abc
// #show: e.set_(wock, color: red) // 90
abc
// #show: e.set_(wock, color: red)
abc
// #show: e.set_(wock, color: red)
abc
// #show: e.set_(wock, color: red)
abc
// #show: e.set_(wock, color: red)
abc
// #show: e.set_(wock, color: red)
abc
// #show: e.set_(wock, color: red)
abc
// #show: e.set_(wock, color: red)
abc
// #show: e.set_(wock, color: red)
abc
// #show: e.set_(wock, color: red) // 100
abc
#wock()
