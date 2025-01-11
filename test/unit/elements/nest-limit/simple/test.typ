#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: field

#let wock = e.element.declare(
  "wock",
  display: it => {
    it.inner
  },
  fields: (
    field("inner", content, required: true),
  ),
  prefix: ""
)

#range(21).fold([], (acc, _) => wock(acc))
