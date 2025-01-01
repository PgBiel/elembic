#import "/src/lib.typ" as e: element, field

#let (wock, wock-e) = element(
  "wock",
  it => {
    text(it.color)[#it.inner]
  },
  fields: (
    field("color", color, default: red),
    field("inner", content, default: [Hello!])
  )
)


#let rules = (
  e.set_(wock-e, color: red),
  e.set_(wock-e, inner: [Something]),
  e.set_(wock-e, color: blue),
  e.set_(wock-e, inner: [Something else]),
  e.set_(wock-e, inner: [e]),
)

// Flatten nested applications
#show: e.apply_(
  e.apply_(
    e.apply_(
      ..rules
    )
  )
)

#(wock-e.get)(d => assert(d.color == blue and d.inner == [e]))

#wock()
