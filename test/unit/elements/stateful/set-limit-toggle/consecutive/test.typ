#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: element, field

#let (wock, wock-e) = element(
  "wock",
  display: it => {},
  fields: (
    field("color", color, default: red),
    field("inner", content, default: [])
  )
)

#show: e.stateful.toggle(true)

#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red) // 10
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red) // 20
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red) // 30
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red) // 40
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red) // 50
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red) // 60
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red) // 70
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red) // 80
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red) // 90
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red)
#show: e.set_(wock, color: red) // 100

#wock()
