// Test the "e.show_" rule.

#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: field

#let wock = e.element.declare(
  "wock",
  display: it => {},
  fields: (
    field("color", color, default: red),
    field("number", int, default: 0),
    field("inner", content, default: [])
  ),
  prefix: ""
)

#let test-state = state("test", ())

#[
  #show: e.show_(wock, it => {
    test-state.update(a => a + (e.fields(it).number,))
    it
  })
  #show: e.show_(wock.with(color: blue), it => {
    test-state.update(a => a + (e.fields(it).number,))
    it
  })
  #wock(number: 39)
  #wock(number: 48, color: blue)

  #context {
    // Both show rules match on the blue one
    assert.eq(test-state.get(), (39, 48, 48))
  }
]
