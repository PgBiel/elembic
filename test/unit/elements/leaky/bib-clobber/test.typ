#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: field

#set bibliography(title: [Custom Title])

#let wock = e.element.declare(
  "wock",
  display: it => {
    context assert.eq(bibliography.title, [Custom Title])
  },
  fields: (
    field("color", color, default: red),
    field("inner", content, default: [Hello!])
  ),
  prefix: ""
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

#show e.selector(wock): it => {
  context assert.eq(bibliography.title, [Custom Title])
  it
}

#e.get(_ => {
  show: e.leaky.set_(wock, color: blue)
  context assert.eq(bibliography.title, [Custom Title])
})

#e.select(wock.with(color: blue), prefix: "sel1", _ => {
  show: e.leaky.set_(wock, color: blue)
  context assert.eq(bibliography.title, [Custom Title])
})

#show: e.leaky.set_(wock, color: blue)
#wock()
