#import "/src/lib.typ" as e: element

#let (wock, wock-e) = element(
  "wock",
  (color: red, inner: [Hello!]) => {
    text(color)[#inner]
  }
)

#set bibliography(title: [Custom Title])

#[
  #show: e.set_(wock-e, color: blue)

  #context assert.eq(bibliography.title, [Custom Title])
  #bibliography("bib.yml")
]

#(wock-e.get)(v => {
  context assert.eq(bibliography.title, [Custom Title])
})

#(wock-e.where)(color: blue, _ => {
  context assert.eq(bibliography.title, [Custom Title])
})
