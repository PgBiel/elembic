#import "/test/unit/base.typ": empty
#show: empty
#show "abc": hide

#import "/src/lib.typ" as e: element, field

#let (wock, wock-e) = element(
  "wock",
  display: it => {},
  fields: (
    field("color", color, default: red),
    field("inner", content, default: [])
  )
)

#show: e.set_(wock-e, color: red)
abc
#show: e.set_(wock-e, color: red)
abc
#show: e.set_(wock-e, color: red)
abc
#show: e.set_(wock-e, color: red)
abc
#show: e.set_(wock-e, color: red)
abc
#show: e.set_(wock-e, color: red)
abc
#show: e.set_(wock-e, color: red)
abc
#show: e.set_(wock-e, color: red)
abc
#show: e.set_(wock-e, color: red)
abc
#show: e.set_(wock-e, color: red)
abc
#show: e.set_(wock-e, color: red) // 10
abc
#show: e.set_(wock-e, color: red)
abc
#show: e.set_(wock-e, color: red)
abc
#show: e.set_(wock-e, color: red)
abc
#show: e.set_(wock-e, color: red)
abc
#show: e.set_(wock-e, color: red)
abc
#show: e.set_(wock-e, color: red)
abc
#show: e.set_(wock-e, color: red)
abc
#show: e.set_(wock-e, color: red)
abc
#show: e.set_(wock-e, color: red)
abc
#show: e.set_(wock-e, color: red) // 20
abc
#show: e.set_(wock-e, color: red)
abc
#show: e.set_(wock-e, color: red)
abc
#show: e.set_(wock-e, color: red)
abc
#show: e.set_(wock-e, color: red)
abc
#show: e.set_(wock-e, color: red)
abc
#show: e.set_(wock-e, color: red)
abc
#show: e.set_(wock-e, color: red)
abc
#show: e.set_(wock-e, color: red)
abc
#show: e.set_(wock-e, color: red)
abc
// #show: e.set_(wock-e, color: red) // 30
abc
// #show: e.set_(wock-e, color: red)
abc
// #show: e.set_(wock-e, color: red)
abc
// #show: e.set_(wock-e, color: red)
abc
// #show: e.set_(wock-e, color: red)
abc
// #show: e.set_(wock-e, color: red)
abc
// #show: e.set_(wock-e, color: red)
abc
// #show: e.set_(wock-e, color: red)
abc
// #show: e.set_(wock-e, color: red)
abc
// #show: e.set_(wock-e, color: red)
abc
// #show: e.set_(wock-e, color: red) // 40
abc
// #show: e.set_(wock-e, color: red)
abc
// #show: e.set_(wock-e, color: red)
abc
// #show: e.set_(wock-e, color: red)
abc
// #show: e.set_(wock-e, color: red)
abc
// #show: e.set_(wock-e, color: red)
abc
// #show: e.set_(wock-e, color: red)
abc
// #show: e.set_(wock-e, color: red)
abc
// #show: e.set_(wock-e, color: red)
abc
// #show: e.set_(wock-e, color: red)
abc
// #show: e.set_(wock-e, color: red) // 50
abc
// #show: e.set_(wock-e, color: red)
abc
// #show: e.set_(wock-e, color: red)
abc
// #show: e.set_(wock-e, color: red)
abc
// #show: e.set_(wock-e, color: red)
abc
// #show: e.set_(wock-e, color: red)
abc
// #show: e.set_(wock-e, color: red)
abc
// #show: e.set_(wock-e, color: red)
abc
// #show: e.set_(wock-e, color: red)
abc
// #show: e.set_(wock-e, color: red)
abc
// #show: e.set_(wock-e, color: red) // 60
abc
// #show: e.set_(wock-e, color: red)
abc
// #show: e.set_(wock-e, color: red)
abc
// #show: e.set_(wock-e, color: red)
abc
// #show: e.set_(wock-e, color: red)
abc
// #show: e.set_(wock-e, color: red)
abc
// #show: e.set_(wock-e, color: red)
abc
// #show: e.set_(wock-e, color: red)
abc
// #show: e.set_(wock-e, color: red)
abc
// #show: e.set_(wock-e, color: red)
abc
// #show: e.set_(wock-e, color: red) // 70
abc
// #show: e.set_(wock-e, color: red)
abc
// #show: e.set_(wock-e, color: red)
abc
// #show: e.set_(wock-e, color: red)
abc
// #show: e.set_(wock-e, color: red)
abc
// #show: e.set_(wock-e, color: red)
abc
// #show: e.set_(wock-e, color: red)
abc
// #show: e.set_(wock-e, color: red)
abc
// #show: e.set_(wock-e, color: red)
abc
// #show: e.set_(wock-e, color: red)
abc
// #show: e.set_(wock-e, color: red) // 80
abc
// #show: e.set_(wock-e, color: red)
abc
// #show: e.set_(wock-e, color: red)
abc
// #show: e.set_(wock-e, color: red)
abc
// #show: e.set_(wock-e, color: red)
abc
// #show: e.set_(wock-e, color: red)
abc
// #show: e.set_(wock-e, color: red)
abc
// #show: e.set_(wock-e, color: red)
abc
// #show: e.set_(wock-e, color: red)
abc
// #show: e.set_(wock-e, color: red)
abc
// #show: e.set_(wock-e, color: red) // 90
abc
// #show: e.set_(wock-e, color: red)
abc
// #show: e.set_(wock-e, color: red)
abc
// #show: e.set_(wock-e, color: red)
abc
// #show: e.set_(wock-e, color: red)
abc
// #show: e.set_(wock-e, color: red)
abc
// #show: e.set_(wock-e, color: red)
abc
// #show: e.set_(wock-e, color: red)
abc
// #show: e.set_(wock-e, color: red)
abc
// #show: e.set_(wock-e, color: red) // 100
abc
#wock()
