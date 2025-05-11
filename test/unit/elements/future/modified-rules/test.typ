// Test forward-compatibility with existing but modified rules.

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
#let test-value = 321
#let call(expected-kind) = (rule, elements: none, settings: none, __future-version: 0, ..) => {
  assert.eq(rule.kind, expected-kind)

  if e.eid(wock) not in elements {
    elements.insert(e.eid(wock), e.data(wock).default-data)
  }
  elements.at(e.eid(wock)).goofy = test-value
  settings.goofy = test-value

  assert.ne(__future-version, 0)

  (elements: elements, settings: settings)
}

#let modify-rule(name, callback, rule-func) = {
  let rule = rule-func([]).children.last().value.rule
  prepare-rule(callback(rule, ((name): (call: call(name), max-version: 999999))))
}

// For rules like revoke which read the future rules from the chain.
#let modify-rule-in-chain(name) = {
  prepare-rule((
    (prepared-rule-key): true,
    version: e.constants.element-version,
    kind: "new-rule",
    name: none,
    names: (),
    mode: auto,
    __future: (
      call: (rule, elements: none, settings: none, __future-version: 0, ..) => {
        if e.eid(wock) not in elements {
          elements.insert(e.eid(wock), e.data(wock).default-data)
        }
        elements.at(e.eid(wock)).__future-rules = ((name): (call: call(name), max-version: 999999))

        assert.ne(__future-version, 0)

        (elements: elements, settings: settings)
      },
      max-version: 999999,
    )
  ))
}

#let check-if-it-worked() = e.debug-get(styles => {
  assert.eq(styles.elements.at(e.eid(wock)).goofy, test-value)
  assert.eq(styles.settings.goofy, test-value)
})

#{
  show: modify-rule(
    "cond-set",
    (rule, future-rules) => {
      rule.element.default-data.__future-rules = future-rules
      rule
    },
    e.cond-set(wock, color: yellow)
  )

  check-if-it-worked()
}

#{
  show: modify-rule(
    "set",
    (rule, future-rules) => {
      rule.element.default-data.__future-rules = future-rules
      rule
    },
    e.set_(wock, color: yellow)
  )

  check-if-it-worked()
}

#{
  show: modify-rule(
    "show",
    (rule, future-rules) => {
      rule.filter.elements.at(e.eid(wock)).default-data.__future-rules = future-rules
      rule
    },
    e.show_(wock, "")
  )

  check-if-it-worked()
}

#{
  show: modify-rule(
    "filtered",
    (rule, future-rules) => {
      rule.filter.elements.at(e.eid(wock)).default-data.__future-rules = future-rules
      rule
    },
    e.filtered(wock, e.set_(wock, color: blue))
  )

  check-if-it-worked()
}

#{
  show: e.named("test", e.set_(wock, color: gray))
  show: modify-rule-in-chain("revoke")
  show: e.revoke("test")

  check-if-it-worked()
}

#{
  show: e.set_(wock, color: gray)
  show: modify-rule-in-chain("reset")
  show: e.reset()

  check-if-it-worked()
}
