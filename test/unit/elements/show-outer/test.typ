#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: field

#let wock = e.element.declare(
  "wock",
  display: it => {
    (it.run)(it)
  },
  fields: (
    field("run", function, named: false, default: _ => {}),
    field("color", color, default: red),
    field("inner", content, default: [])
  ),
  prefix: ""
)

#show e.selector(wock): e.set_(wock, color: blue)


// Apply only to nested 'wock's
#wock()
#wock(it => assert.eq(it.color, red))
#wock(_ => wock(it => assert.eq(it.color, blue)))

#show e.selector(wock, outer: true): e.set_(wock, inner: [abc])
#show e.selector(wock, outer: true): it => assert.eq(e.data(it).eid, e.data(wock).eid)

// Apply immediately
#wock(it => assert.eq(it.inner, [abc]))
#wock(_ => wock(it => assert.eq(it.inner, [abc])))
