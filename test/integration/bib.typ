#import "/src/lib.typ" as e: field

#set bibliography(title: [Custom Title])

#let wock = e.element.declare(
  "wock",
  display: it => {
    context assert.eq(bibliography.title, [Custom Title])
    text(it.color)[#it.inner]
  },
  fields: (
    field("color", color, default: red),
    field("inner", content, default: [Hello!])
  ),
  prefix: ""
)

#[
  #show: e.set_(wock, color: blue)

  #context assert.eq(bibliography.title, [Custom Title])
  #bibliography("bib.yml")
]

#e.get(_ => {
  context assert.eq(bibliography.title, [Custom Title])
})

#(e.data(wock).where)(color: blue, _ => {
  context assert.eq(bibliography.title, [Custom Title])
})

#wock()
