#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: field

#let wock = e.element.declare(
  "wock",
  display: it => assert.eq(it.color, yellow),
  fields: (
    field("color", color, default: red),
    field("inner", content, default: [])
  ),
  prefix: ""
)

#show: e.leaky.settings(prefer-leaky: true)
#let setter = e.set_(wock, color: yellow)
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
// #show: setter // 60
abc
// #show: setter
abc
// #show: setter
abc
// #show: setter
abc
// #show: setter
abc
// #show: setter
abc
// #show: setter
abc
// #show: setter
abc
// #show: setter
abc
// #show: setter
abc
// #show: setter // 70
abc
// #show: setter
abc
// #show: setter
abc
// #show: setter
abc
// #show: setter
abc
// #show: setter
abc
// #show: setter
abc
// #show: setter
abc
// #show: setter
abc
// #show: setter
abc
// #show: setter // 80
abc
// #show: setter
abc
// #show: setter
abc
// #show: setter
abc
// #show: setter
abc
// #show: setter
abc
// #show: setter
abc
// #show: setter
abc
// #show: setter
abc
// #show: setter
abc
// #show: setter // 90
abc
// #show: setter
abc
// #show: setter
abc
// #show: setter
abc
// #show: setter
abc
// #show: setter
abc
// #show: setter
abc
// #show: setter
abc
// #show: setter
abc
// #show: setter // 100
abc
#wock()
