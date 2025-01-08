#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: element, field

#set bibliography(title: [Custom Title])

#let (wock, wock-e) = element(
  "wock",
  display: it => {
    context assert.eq(bibliography.title, [Custom Title])
  },
  fields: (
    field("color", color, default: red),
    field("inner", content, default: [Hello!])
  )
)

#show: e.stateful.enable()

#[
  #show: e.stateful.set_(wock, color: blue)

  #context assert.eq(bibliography.title, [Custom Title])
  #hide(bibliography("bib.yml"))
]

#show wock-e.sel: it => {
  context assert.eq(bibliography.title, [Custom Title])
  it
}

#(wock-e.get)(v => {
  context assert.eq(bibliography.title, [Custom Title])
})

#(wock-e.get)(v => {
  show: e.stateful.set_(wock, color: blue)
  context assert.eq(bibliography.title, [Custom Title])
})

#(wock-e.where)(color: blue, _ => {
  context assert.eq(bibliography.title, [Custom Title])
})

#(wock-e.where)(color: blue, _ => {
  show: e.stateful.set_(wock, color: blue)
  context assert.eq(bibliography.title, [Custom Title])
})

#wock()
