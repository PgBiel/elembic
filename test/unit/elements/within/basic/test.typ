#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: field

#let wock = e.element.declare(
  "wock",
  display: it => { it.inner },
  fields: (
    field("color", color, default: red),
    field("inner", content, default: [Hello!])
  ),
  prefix: ""
)

#let dock = e.element.declare(
  "dock",
  display: it => { it.inner },
  fields: (
    field("color", color, default: red),
    field("inner", content, default: [Hello!])
  ),
  prefix: ""
)

#show: e.set_(wock, color: blue)

// Lazy tracking
#wock(inner: [
  #e.debug-get(styles => {
    assert.eq(styles.global.ancestry-chain, ())
  })
])

#{
  show: e.settings(track-ancestry: (dock, wock))

  wock(inner: [
    #e.debug-get(styles => {
      let wock-within = styles.global.ancestry-chain.first()
      assert.eq(wock-within.eid, e.eid(wock))
      assert.eq(wock-within.fields.color, blue)
    })
  ])
}

#{
  show: e.settings(track-ancestry: "any")

  wock(inner: [
    #e.debug-get(styles => {
      let wock-within = styles.global.ancestry-chain.first()
      assert.eq(wock-within.eid, e.eid(wock))
      assert.eq(wock-within.fields.color, blue)
    })
  ])
}

// Bogus rule with 'within' just to trigger ancestry tracking
#show: e.cond-set(e.filters.and_(wock, e.within(wock)))

#wock(inner: [
  #e.debug-get(styles => {
    let wock-within = styles.global.ancestry-chain.first()
    assert.eq(wock-within.eid, e.eid(wock))
    assert.eq(wock-within.fields.color, blue)
  })

  #wock(
    color: red,
    inner: e.debug-get(styles => {
      let wock-within = styles.global.ancestry-chain.at(1)
      assert.eq(wock-within.eid, e.eid(wock))
      assert.eq(wock-within.fields.color, red)
    })
  )
])

#[
  #let blue-counter = counter("under-blue")
  #let other-counter = counter("under-other")
  #show: e.show_(e.filters.and_(wock, e.within(wock.with(color: blue))), it => blue-counter.step() + it)
  #show: e.show_(
    e.filters.and_(wock, e.within(e.filters.or_(wock.with(color: yellow), wock.with(color: purple)))),
    it => other-counter.step() + it
  )

  #wock()

  #wock(
    inner: {
      wock(color: yellow, inner: wock())
      wock(color: red, inner: wock())
      wock(color: purple, inner: wock())
    }
  )

  #context assert.eq(blue-counter.get().first(), 6)
  #context assert.eq(other-counter.get().first(), 2)
]
