// Test forward-compatibility when merging rules (use the later version).

#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: field
#import "/src/data.typ": prepared-rule-key

#let wock = e.element.declare(
  "wock",
  display: it => {
    assert.eq(it.color, blue)
    assert.eq(it.inner, [Hello!])
  },
  fields: (
    field("color", color, default: red),
    field("inner", content, default: [Hello!])
  ),
  prefix: ""
)

#let prepare-rule = e.data(wock).routines.prepare-rule

#{
  let value = 321
  let (doc, rule-data) = e.set_(wock, color: orange)([]).children
  let lbl = rule-data.label
  let rule-data = rule-data.value
  let test-state = state("test-state", 0)

  rule-data.__future = (max-version: 999999, call: (rule, doc, __future-version: 0) => {
    assert.ne(__future-version, 0)
    (doc: test-state.update(c => c + 1))
  })

  {
    // Should merge with our "future" and update the state
    show: e.set_(wock, color: green)
    show: doc => [#doc#metadata(rule-data)#lbl]

    [hi]
  }

  {
    let ineffective-data = rule-data
    ineffective-data.__future.max-version = 0
    // No merging, wrong version
    show: e.set_(wock, color: green)
    show: doc => [#doc#metadata(ineffective-data)#lbl]

    [hi]
  }

  // Only the first one works
  context assert.eq(test-state.get(), 1)
}
