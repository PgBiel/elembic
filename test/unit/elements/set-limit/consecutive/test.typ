#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: field

#let wock = e.element.declare(
  "wock",
  display: it => {},
  fields: (
    field("color", color, default: red),
    field("inner", content, default: [])
  ),
  prefix: ""
)

#let setter = e.set_(wock, color: red)
#show: setter
#show: setter
#show: setter
#show: setter
#show: setter
#show: setter
#show: setter
#show: setter
#show: setter
#show: setter
#show: setter // 10
#show: setter
#show: setter
#show: setter
#show: setter
#show: setter
#show: setter
#show: setter
#show: setter
#show: setter
#show: setter // 20
#show: setter
#show: setter
#show: setter
#show: setter
#show: setter
#show: setter
#show: setter
#show: setter
#show: setter
#show: setter // 30
#show: setter
#show: setter
#show: setter
#show: setter
#show: setter
#show: setter
#show: setter
#show: setter
#show: setter
#show: setter // 40
#show: setter
#show: setter
#show: setter
#show: setter
#show: setter
#show: setter
#show: setter
#show: setter
#show: setter
#show: setter // 50
#show: setter
#show: setter
#show: setter
#show: setter
#show: setter
#show: setter
#show: setter
#show: setter
#show: setter
#show: setter // 60
#show: setter
#show: setter
#show: setter
#show: setter
#show: setter
#show: setter
#show: setter
#show: setter
#show: setter
#show: setter // 70
#show: setter
#show: setter
#show: setter
#show: setter
#show: setter
#show: setter
#show: setter
#show: setter
#show: setter
#show: setter // 80
#show: setter
#show: setter
#show: setter
#show: setter
#show: setter
#show: setter
#show: setter
#show: setter
#show: setter
#show: setter // 90
#show: setter
#show: setter
#show: setter
#show: setter
#show: setter
#show: setter
#show: setter
#show: setter
#show: setter // 100

#wock()
