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
  #let test-state = state("test", ())
  #show: e.show_(wock.with(label: <snd>), it => {
    test-state.update(e.fields(it).label)
  })
  #wock(label: <snd>)

  // Ref figure was only placed once
  #context assert.eq(test-state.get(), <snd>)
]
