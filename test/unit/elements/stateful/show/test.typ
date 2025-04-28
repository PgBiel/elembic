// Test the "e.show_" rule (stateful).

#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: field

#let wock = e.element.declare(
  "wock",
  display: it => it.inner,
  fields: (
    field("color", color, default: red),
    field("number", int, default: 0),
    field("inner", content, default: [])
  ),
  prefix: ""
)

#show: e.stateful.enable()

#[
  #let test-state = state("test", ())
  #show: e.stateful.show_(wock, it => {
    test-state.update(a => a + (e.fields(it).number,))
    it
  })
  #show: e.stateful.show_(wock.with(color: blue), it => {
    test-state.update(a => a + (e.fields(it).number,))
    it
  })
  #show: e.stateful.show_(wock.with(color: orange), it => {
    // This should stop other show rules from applying.
    // We will never see the number of an orange wock
    none
  })
  #wock(number: 39)
  #wock(number: 48, color: blue)
  #wock(number: 59, color: orange)

  #context {
    // Both show rules match on the blue one
    assert.eq(test-state.get(), (39, 48, 48))
  }
]

#[
  #let test-state = state("test2", ())
  #show: e.named("wowzers", e.stateful.show_(wock.with(color: blue), it => {
    test-state.update(a => a + (e.fields(it).number,))
    it
  }))
  #wock(number: 39)

  #[
    #wock(number: 48, color: blue)
    #show: e.stateful.revoke("wowzers")
    #wock(number: 77, color: blue)
  ]

  #[
    #wock(number: 33, color: blue)
    #show: e.stateful.reset()
    #wock(number: 79, color: blue)
  ]

  #[
    #wock(number: 22, color: blue)
    #show: e.stateful.reset(wock)
    #wock(number: 80, color: blue)
  ]

  #context {
    // No match after revoke
    assert.eq(test-state.get(), (48, 33, 22))
  }
]

#[
  #show: e.stateful.show_(wock, _ => panic())
  #show: e.stateful.show_(wock, none)
  #wock()
]

#[
  #let test-state = state("test-string-exists", false)
  #show "abc": test-state.update(true)
  #show: e.stateful.show_(wock, _ => panic())
  #show: e.stateful.show_(wock, "abc")
  #wock()

  #context assert(test-state.get())
]

#[
  #let test-state = state("test-state-update-exists", false)
  #show: e.stateful.show_(wock, _ => panic())
  #show: e.stateful.show_(wock, test-state.update(true))
  #wock()

  #context assert(test-state.get())
]
