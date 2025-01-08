#import "/src/lib.typ" as e: field

#let wock = e.element.declare(
  "wock",
  display: it => {
    text(it.color)[#it.inner]
  },
  fields: (
    field("color", color, default: red),
    field("somedata", int, default: 100),
    field("inner", content, default: [Hello!])
  ),
  prefix: ""
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

  #e.get(get => assert(get(wock).color == blue and get(wock).inner == [e]))

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

  #e.get(get => assert.eq(get(wock).color, cool-color))
  #e.get(get => assert.eq(get(wock).inner, [ABC]))
  #e.get(get => assert.eq(get(wock).somedata, 300))

  #wock()

  #show: e.revoke("coolness")

  #e.get(get => assert.ne(get(wock).color, cool-color))
  #e.get(get => assert.eq(get(wock).inner, [ABC]))
  #e.get(get => assert.eq(get(wock).somedata, 300))

  #wock()

  #show: e.revoke("datums")

  #e.get(get => assert.ne(get(wock).inner, [ABC]))
  #e.get(get => assert.ne(get(wock).somedata, 300))

  #wock()
]
