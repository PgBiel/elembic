// Test forward-compatibility with non-existing rules.

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
  let brand-new-rule = prepare-rule((
    (prepared-rule-key): true,
    version: e.constants.element-version,
    kind: "new-rule",
    value: value,
    name: none,
    names: (),
    mode: auto,
    __future: (
      call: (rule, elements: none, settings: none, __future-version: 0, ..) => {
        if e.eid(wock) not in elements {
          elements.insert(e.eid(wock), e.data(wock).default-data)
        }
        elements.at(e.eid(wock)).goofy = rule.value
        settings.goofy = rule.value

        assert.ne(__future-version, 0)

        (elements: elements, settings: settings)
      },
      max-version: 999999,
    )
  ))

  show: brand-new-rule

  e.debug-get(styles => {
    assert.eq(styles.elements.at(e.eid(wock)).goofy, value)
    assert.eq(styles.settings.goofy, value)
  })
}

#show: e.set_(wock, color: blue)

#e.get(
  get => {
    assert.eq(get(wock).color, blue)
    assert.eq(get(wock).inner, [Hello!])
  }
)
