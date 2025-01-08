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
  #show: e.set_(wock, color: blue)

  #context assert.eq(bibliography.title, [Custom Title])
  #hide(bibliography("bib.yml"))
]

#show e.selector(wock): it => {
  context assert.eq(bibliography.title, [Custom Title])
  it
}

#e.get(_ => {
  context assert.eq(bibliography.title, [Custom Title])
})

#(e.data(wock).where)(color: blue, _ => {
  context assert.eq(bibliography.title, [Custom Title])
})

#wock()
