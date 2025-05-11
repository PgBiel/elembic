// Test forward-compatibility with non-existing rules.

#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: field
#import "/src/data.typ": filter-key

#let wock = e.element.declare(
  "wock",
  display: it => {},
  fields: (
    field("color", color, default: red),
    field("inner", content, default: [Hello!])
  ),
  prefix: ""
)

#let only-purples-filter = (
  (filter-key): true,
  version: e.constants.element-version,
  kind: "new-filter",
  elements: ((e.eid(wock)): e.data(wock)),
  desired-color: purple,
  __future: (
    call: (fields, eid: none, filter: none, __future-version: 0) => {
      "color" in fields and fields.color == filter.desired-color
    },
    max-version: 999999,
  )
)

#{
  let matches-counter = counter("test-matches")

  show: e.show_(only-purples-filter, it => {
    matches-counter.step()
    it
  })

  wock(color: purple)
  wock(color: purple)
  wock(color: orange)

  context assert.eq(matches-counter.get().first(), 2)
}

// Non-matching version
#{
  let only-purples-bad = only-purples-filter
  only-purples-bad.__future.max-version = 0
  only-purples-bad.kind = "or"
  only-purples-bad.operands = ()

  let matches-counter = counter("test-matches2")

  show: e.show_(only-purples-bad, it => {
    matches-counter.step()
    it
  })

  wock(color: purple)
  wock(color: purple)
  wock(color: orange)

  context assert.eq(matches-counter.get().first(), 0)
}
// In composite filters
#{
  let matches-counter = counter("test-matches3")

  show: e.show_(e.filters.and_(wock.with(inner: [matching]), only-purples-filter), it => {
    matches-counter.step()
    it
  })

  wock(color: purple, inner: [matching])
  wock(color: purple, inner: [matching])
  wock(color: purple, inner: [matching])
  wock(color: purple, inner: [not matching...])
  wock(color: orange, inner: [matching])

  context assert.eq(matches-counter.get().first(), 3)
}
// In composite filters, with "operands"
#{
  let only-purples-with-operands = (..only-purples-filter, operands: (1, 2, 3))
  let matches-counter = counter("test-matches4")

  show: e.show_(e.filters.and_(wock.with(inner: [matching]), only-purples-with-operands), it => {
    matches-counter.step()
    it
  })

  wock(color: purple, inner: [matching])
  wock(color: purple, inner: [matching])
  wock(color: purple, inner: [matching])
  wock(color: purple, inner: [not matching...])
  wock(color: orange, inner: [matching])

  context assert.eq(matches-counter.get().first(), 3)
}
