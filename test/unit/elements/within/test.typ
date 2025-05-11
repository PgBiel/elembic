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

#show: e.set_(wock, color: blue)

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
