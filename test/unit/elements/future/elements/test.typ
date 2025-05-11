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

#let prepare-rule = e.data(wock).routines.prepare-rule
#let modify-element-data(elem, mapper) = prepare-rule((
    (prepared-rule-key): true,
    version: e.constants.element-version,
    kind: "modifier",
    mapper: mapper,
    name: none,
    names: (),
    mode: auto,
    __future: (
      call: (rule, elements: none, settings: none, __future-version: 0, ..) => {
        elements.insert(e.eid(elem), mapper(elements.at(e.eid(elem), default: e.data(elem).default-data)))

        assert.ne(__future-version, 0)

        (elements: elements)
      },
      max-version: 999999,
    )
  ))

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
  let test-state = state("test2", none)
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
