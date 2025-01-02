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


#let all-rules = (
  e.set_(wock-e, color: red),
  e.set_(wock-e, inner: [Something]),
  e.set_(wock-e, color: blue),
  e.set_(wock-e, inner: [Something else]),
  e.set_(wock-e, inner: []),
) * 5000

#let application = e.apply(
  ..all-rules
)

#wock()

#show: application

#wock()

#(wock-e.get)(v => v)

#let wocks = range(5000).map(i => {
  wock(inner: metadata(i))
})

#wocks.join()
