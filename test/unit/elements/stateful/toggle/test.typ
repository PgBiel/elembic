#import "/test/unit/base.typ": empty
#show: empty
#show "abc": hide

#import "/src/lib.typ" as e: field

#let (wock, wock-e) = e.element.declare(
  "wock",
  display: it => {},
  fields: (
    field("color", color, default: red),
    field("inner", content, default: [])
  )
)

#[
  #show: e.set_(wock, color: blue)

  #[
    #show: e.stateful.enable()

    #show: e.stateful.set_(wock, inner: [Abc])

    #(wock-e.get)(w => assert.eq(w.color, blue))
    #(wock-e.get)(w => assert.eq(w.inner, [Abc]))
  ]

  #(wock-e.get)(w => assert.eq(w.color, blue))
  #(wock-e.get)(w => assert.ne(w.inner, [Abc]))

  #show: e.set_(wock, inner: [Is this thing on?])

  #(wock-e.get)(w => assert.eq(w.color, blue))
  #(wock-e.get)(w => assert.eq(w.inner, [Is this thing on?]))
]

#show: e.stateful.enable()

#show: e.stateful.set_(wock, color: yellow)

#[
  #show: e.stateful.disable()

  #show: e.set_(wock, inner: [Def])

  #(wock-e.get)(w => assert.eq(w.color, yellow))
  #(wock-e.get)(w => assert.eq(w.inner, [Def]))
]

#(wock-e.get)(w => assert.eq(w.color, yellow))
#(wock-e.get)(w => assert.ne(w.inner, [Def]))

#show: e.stateful.set_(wock, inner: [Is it still working?])

#(wock-e.get)(w => assert.eq(w.color, yellow))
#(wock-e.get)(w => assert.eq(w.inner, [Is it still working?]))
