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

#show: e.set_(dock, color: blue)

#range(200).fold(
  [],
  (acc, _) => e.get(get => assert.eq(get(dock).color, blue) + acc)
)

#range(20).fold(
  [],
  (acc, _) => [#e.get(get => assert.eq(get(dock).color, blue) + acc)<abc>]
)

#context assert.eq(query(<abc>).len(), 20)
