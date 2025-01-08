#import "/src/lib.typ" as e: field

#let (wock, wock-e) = e.element.declare(
  "wock",
  display: it => {
    text(it.color)[#it.inner]
  },
  fields: (
    field("color", color, default: red),
    field("inner", content, default: [Hello!])
  )
)


#let all-rules = (
  e.set_(wock, color: red),
  e.set_(wock, inner: [Something]),
  e.set_(wock, color: blue),
  e.set_(wock, inner: [Something else]),
  e.set_(wock, inner: []),
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
