#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: field

#show: e.stateful.enable()

#let (wock, wock-e) = e.element.declare(
  "wock",
  display: it => {},
  fields: (
    field("color", color, default: red),
    field("inner", content, default: [])
  )
)

#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red) // 10
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red) // 20
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red) // 30
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red) // 40
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red) // 50
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red) // 60
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red) // 70
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red) // 80
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red) // 90
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red)
#show: e.stateful.set_(wock, color: red) // 100

#wock()
