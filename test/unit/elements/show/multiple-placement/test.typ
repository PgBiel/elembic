// Test the "e.show_" rule.

#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: field

#let test-state = state("test", ())
#let wock = e.element.declare(
  "wock",
  display: it => (it.inner)(),
  fields: (
    field("color", color, default: red),
    field("number", int, default: 0),
    field("inner", function, default: () => {})
  ),
  prefix: "",
  reference: (custom: it => {
    let value = e.counter(it).get()
    test-state.update(a => a + ((count: value),))
  })
)

#[
  #show: e.show_(wock, it => {
    it
    it
  })
  #wock()
  #wock(label: <snd>)

  #context assert.eq(e.counter(wock).get().first(), 2)
  #e.ref(<snd>)

  // Ref figure was only placed once
  #context assert.eq(test-state.get(), ((count: (2,)),)))
]
