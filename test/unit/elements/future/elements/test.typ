// Test forward-compatibility with non-existing rules.

#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: field
#import "/src/data.typ": prepared-rule-key

#let wock = e.element.declare(
  "wock",
  display: it => (it.run)(it),
  fields: (
    field("color", color, default: red),
    field("inner", content, default: [Hello!]),
    field("run", function, default: _ => {}),
  ),
  prefix: ""
)

#let (prepare-rule, apply-rules) = e.data(wock).routines

#let modify-data(mapper) = prepare-rule((
  (prepared-rule-key): true,
  version: e.constants.element-version,
  kind: "modifier",
  mapper: mapper,
  name: none,
  names: (),
  mode: auto,
  __future: (
    call: (rule, elements: none, settings: none, global: none, __future-version: 0, ..) => {
      assert.ne(__future-version, 0)

      mapper(elements: elements, settings: settings, global: global)
    },
    max-version: 999999,
  )
))

#let modify-element-data(elem, mapper) = modify-data(
  (elements: none, settings: none, global: none) => {
    elements.insert(e.eid(elem), mapper(elements.at(e.eid(elem), default: e.data(elem).default-data)))

    (elements: elements)
  },
)

#{
  show: modify-element-data(wock, w => {
    w.__futures = (
      (element-data: ((max-version: 99999, call: (element-data: none, args: none, __future-version: 0, ..) => {
        assert.ne(__future-version, 0)
        assert.eq(args.inner, [test])
        element-data.chain = ()
        (element-data: element-data)
      }), ))
    )
    w
  })

  show: e.set_(wock, color: blue)
  // Chain nullified by our custom rule
  wock(inner: [test], run: it => assert.eq(it.color, red))
}

#{
  show: modify-element-data(wock, w => {
    w.__futures = (
      (element-data: ((max-version: 0, call: (element-data: none, args: none, __future-version: 0, ..) => {
        assert.ne(__future-version, 0)
        assert.eq(args.inner, [test])
        element-data.chain = ()
        (element-data: element-data)
      }), ))
    )
    w
  })

  show: e.set_(wock, color: blue)
  // Chain kept (max version < current version)
  wock(inner: [test], run: it => assert.eq(it.color, blue))
}

#{
  let test-state = state("test2", none)
  show: modify-element-data(wock, w => {
    w.__futures = (
      (construct: ((max-version: 99999, call: (element-data: none, args: none, __future-version: 0, ..) => {
        assert.ne(__future-version, 0)
        element-data.chain = ()
        (construct: (args.run)("potato potato"))
      }), ))
    )
    w
  })

  show: e.set_(wock, color: blue)
  wock(run: it => test-state.update(it))

  // Custom rule overrode display and all
  context assert.eq(test-state.get(), "potato potato")
}

#{
  show: modify-element-data(wock, w => {
    w.__futures = (
      (construct: ((max-version: 0, call: (element-data: none, args: none, __future-version: 0, ..) => {
        panic()
      }), ))
    )
    w
  })

  // Should not panic (max version < current version)
  wock(run: it => it)
}

// Synthesized field futures
#{
  show: modify-element-data(wock, w => {
    w.__futures = (
      (synthesized-fields: ((max-version: 0, call: (synthesized-fields: none, element-data: none, args: none, __future-version: 0, ..) => {
        panic()
      }), ))
    )
    w
  })

  // Should not panic (max version < current version)
  wock(run: it => it)
}
#{
  let test-state1 = state("st-test1", false)
  let test-state2 = state("st-test2", false)
  let test-state3 = state("st-test3", none)
  show: modify-element-data(wock, w => {
    w.__futures = (
      (synthesized-fields: ((max-version: 9999, call: (synthesized-fields: none, element-data: none, args: none, global-data: none, __future-version: 0, ..) => {
        if synthesized-fields.color == red {
          return (synthesized-fields: (:..synthesized-fields, run: it => test-state1.update(true)))
        } else if synthesized-fields.color == blue {
          return (construct: test-state2.update(true))
        } else if synthesized-fields.color == green {
          let rule = e.set_(wock, color: purple)([]).children.last().value.rule
          global-data += apply-rules((rule,), elements: global-data.elements, settings: global-data.settings, global: global-data.global)
          return (global-data: global-data)
        }
        (:)
      }), ))
    )
    w
  })

  wock(run: it => it)
  wock(color: blue, run: it => it)
  wock(color: green, run: it => e.get(get => test-state3.update(get(wock).color)))
  context assert(test-state1.get())
  context assert(test-state2.get())
  context assert.eq(test-state3.get(), purple)
}

#{
  let test-state = state("test2", none)

  // Apply a set rule through a future rule
  show: modify-data((global: none, ..) => {
    global.__futures = (
      (global-data: ((max-version: 99999, call: (global-data: none, element-data: none, args: none, all-element-data: none, __future-version: 0, ..) => {
        assert.ne(__future-version, 0)
        assert.eq(all-element-data.eid, e.eid(wock))

        let rule = e.set_(wock, color: purple)([]).children.last().value.rule
        global-data += apply-rules((rule,), elements: global-data.elements, settings: global-data.settings, global: global-data.global)

        (global-data: global-data)
      }), ))
    )
    (global: global)
  })

  wock(run: it => {
    test-state.update(it.color)
    e.get(get => assert.eq(get(wock).color, purple))
  })
  context assert.eq(test-state.get(), purple)
}

#{
  let test-state = state("test3", none)

  // Apply a set rule through a future rule
  // but return data-changed: false so it is
  // not propagated
  show: modify-data((global: none, ..) => {
    global.__futures = (
      (global-data: ((max-version: 99999, call: (global-data: none, element-data: none, args: none, all-element-data: none, __future-version: 0, ..) => {
        assert.ne(__future-version, 0)
        assert.eq(all-element-data.eid, e.eid(wock))

        let rule = e.set_(wock, color: purple)([]).children.last().value.rule
        global-data += apply-rules((rule,), elements: global-data.elements, settings: global-data.settings, global: global-data.global)

        (global-data: global-data, data-changed: false)
      }), ))
    )
    (global: global)
  })

  wock(run: it => {
    test-state.update(it.color)
    e.get(get => assert.eq(get(wock).color, red))
  })
  context assert.eq(test-state.get(), purple)
}

#{
  let test-state = state("test4", none)

  // Future rule shouldn't match here (max version not satisfied)
  show: modify-data((global: none, ..) => {
    global.__futures = (
      (global-data: ((max-version: 0, call: (global-data: none, element-data: none, args: none, __future-version: 0, ..) => {
        panic()
      }), ))
    )
    (global: global)
  })

  wock(run: it => {
    test-state.update(it.color)
    e.get(get => assert.eq(get(wock).color, red))
  })
  context assert.eq(test-state.get(), red)
}
