// Test the "e.show_" rule.

#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: field

#let wock = e.element.declare(
  "wock",
  display: it => (it.inner)(),
  fields: (
    field("color", color, default: red),
    field("number", int, default: 0),
    field("inner", function, default: () => {})
  ),
  prefix: ""
)

#[
  #set terms(indent: 44pt)
  #show: e.show_(wock, it => {
    set terms(indent: 88pt)
    it
  })
  #wock(inner: () => assert.eq(terms.indent, 44pt))
  #wock(inner: () => context assert.eq(terms.indent, 88pt))
]
