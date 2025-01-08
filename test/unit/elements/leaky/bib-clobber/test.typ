#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: field

#set bibliography(title: [Custom Title])

#let (wock, wock-e) = e.element.declare(
  "wock",
  display: it => {
    context assert.eq(bibliography.title, [Custom Title])
  },
  fields: (
    field("color", color, default: red),
    field("inner", content, default: [Hello!])
  )
)

#[
  #show: e.leaky.set_(wock, color: blue)

  #context assert.eq(bibliography.title, [Custom Title])

  #set bibliography(title: [Another Title])
  #context assert.eq(bibliography.title, [Another Title])

  #show: e.leaky.set_(wock, color: blue)
  // Reset
  #context assert.eq(bibliography.title, [Custom Title])

  #hide(bibliography("bib.yml"))
]

#[
  #show: e.stateful.toggle(true)
  #show: e.leaky.set_(wock, color: blue)

  #context assert.eq(bibliography.title, [Custom Title])
]

#show wock-e.sel: it => {
  context assert.eq(bibliography.title, [Custom Title])
  it
}

#(wock-e.get)(v => {
  show: e.leaky.set_(wock, color: blue)
  context assert.eq(bibliography.title, [Custom Title])
})

#(wock-e.where)(color: blue, _ => {
  show: e.leaky.set_(wock, color: blue)
  context assert.eq(bibliography.title, [Custom Title])
})

#show: e.leaky.set_(wock, color: blue)
#wock()
