#import "/test/unit/base.typ": empty
#show: empty
#show "abc": hide

#import "/src/lib.typ" as e: field

#show: e.stateful.enable()

#let wock = e.element.declare(
  "wock",
  display: it => assert.eq(it.color, blue),
  fields: (
    field("color", color, default: red),
    field("inner", content, default: [])
  ),
  prefix: ""
)

#let setter = e.stateful.set_(wock, color: blue)

#show: setter
abc
#show: setter
abc
#show: setter
abc
#show: setter
abc
#show: setter
abc
#show: setter
abc
#show: setter
abc
#show: setter
abc
#show: setter
abc
#show: setter
abc
#show: setter // 10
abc
#show: setter
abc
#show: setter
abc
#show: setter
abc
#show: setter
abc
#show: setter
abc
#show: setter
abc
#show: setter
abc
#show: setter
abc
#show: setter
abc
#show: setter // 20
abc
#show: setter
abc
#show: setter
abc
#show: setter
abc
#show: setter
abc
#show: setter
abc
#show: setter
abc
#show: setter
abc
#show: setter
abc
#show: setter
abc
#show: setter // 30
abc
#show: setter
abc
#show: setter
abc
#show: setter
abc
#show: setter
abc
#show: setter
abc
#show: setter
abc
#show: setter
abc
#show: setter
abc
#show: setter
abc
#show: setter // 40
abc
#show: setter
abc
#show: setter
abc
#show: setter
abc
#show: setter
abc
#show: setter
abc
#show: setter
abc
#show: setter
abc
#show: setter
abc
#show: setter
abc
#show: setter // 50
abc
#show: setter
abc
#show: setter
abc
#show: setter
abc
#show: setter
abc
#show: setter
abc
#show: setter
abc
#show: setter
abc
#show: setter
abc
#show: setter
abc
#show: setter // 60
abc
#show: setter
abc
#show: setter
abc
#show: setter
abc
#show: setter
abc
#show: setter
abc
#show: setter
abc
#show: setter
abc
#show: setter
abc
#show: setter
abc
#show: setter // 70
abc
#show: setter
abc
#show: setter
abc
#show: setter
abc
#show: setter
abc
#show: setter
abc
#show: setter
abc
#show: setter
abc
#show: setter
abc
#show: setter
abc
#show: setter // 80
abc
#show: setter
abc
#show: setter
abc
#show: setter
abc
#show: setter
abc
#show: setter
abc
#show: setter
abc
#show: setter
abc
#show: setter
abc
#show: setter
abc
#show: setter // 90
abc
#show: setter
abc
#show: setter
abc
#show: setter
abc
#show: setter
abc
#show: setter
abc
#show: setter
abc
#show: setter
abc
#show: setter
abc
#show: setter // 100
abc
#wock()
