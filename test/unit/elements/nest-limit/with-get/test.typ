#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: field

#let dock = e.element.declare(
  "dock",
  display: it => it.inner,
  fields: (
    field("inner", content, required: true),
    field("color", color, default: red),
  ),
  prefix: ""
)

#let wock = e.element.declare(
  "wock",
  display: it => {
    e.get(get => {
      assert.eq(get(dock).color, blue)
      it.inner
    })
  },
  fields: (
    field("inner", content, required: true),
  ),
  prefix: ""
)

#show: e.set_(dock, color: blue)

#range(20).fold([], (acc, _) => wock(acc))
#dock(range(100).fold([], (acc, _) => e.get(_ => acc)))
