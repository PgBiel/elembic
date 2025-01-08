#import "/src/lib.typ" as e: field

#let (wock, wock-e) = e.element.declare(
  "wock",
  display: it => {
    text(it.color)[#it.inner]
  },
  fields: (
    field("color", color, default: red),
    field("somedata", int, default: 100),
    field("inner", content, default: [Hello!])
  )
)

#[
  #let rules = (
    e.set_(wock, color: red),
    e.set_(wock, inner: [Something]),
    e.set_(wock, color: blue),
    e.set_(wock, inner: [Something else]),
    e.set_(wock, inner: [e]),
  )

  // Flatten nested applications
  #show: e.apply(
    e.apply(
      e.apply(
        ..rules
      )
    )
  )

  #(wock-e.get)(d => assert(d.color == blue and d.inner == [e]))

  #wock()
]

= Revoke

#[
  #let cool-color = luma(89)
  #show: e.named("coolness", e.set_(wock, color: cool-color))
  #show: e.named("datums", e.apply(
    e.set_(wock, inner: [ABC]),
    e.set_(wock, somedata: 300)
  ))

  #(wock-e.get)(d => assert.eq(d.color, cool-color))
  #(wock-e.get)(d => assert.eq(d.inner, [ABC]))
  #(wock-e.get)(d => assert.eq(d.somedata, 300))

  #wock()

  #show: e.revoke("coolness")

  #(wock-e.get)(d => assert.ne(d.color, cool-color))
  #(wock-e.get)(d => assert.eq(d.inner, [ABC]))
  #(wock-e.get)(d => assert.eq(d.somedata, 300))

  #wock()

  #show: e.revoke("datums")

  #(wock-e.get)(d => assert.ne(d.inner, [ABC]))
  #(wock-e.get)(d => assert.ne(d.somedata, 300))

  #wock()
]
