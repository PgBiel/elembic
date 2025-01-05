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

#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red) // 10
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red) // 20
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red) // 30
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red) // 40
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red) // 50
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red) // 60
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red) // 70
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red) // 80
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red) // 90
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red)
#show: e.set_(wock-e, color: red) // 100

#wock()
