#import "/test/unit/base.typ": empty
#show: empty
#show "abc": hide

#import "/src/lib.typ" as e: element, field

#let (wock, wock-e) = element(
  "wock",
  it => {},
  fields: (
    field("color", color, default: red),
    field("inner", content, default: [])
  )
)

#[
  #show: e.set_(wock-e, color: blue)

  #[
    #show: e.stateful.toggle(true)

    #show: e.stateful.set_(wock-e, inner: [Abc])

    #(wock-e.get)(w => assert.eq(w.color, blue))
    #(wock-e.get)(w => assert.eq(w.inner, [Abc]))
  ]

  #(wock-e.get)(w => assert.eq(w.color, blue))
  #(wock-e.get)(w => assert.ne(w.inner, [Abc]))

  #show: e.set_(wock-e, inner: [Is this thing on?])

  #(wock-e.get)(w => assert.eq(w.color, blue))
  #(wock-e.get)(w => assert.eq(w.inner, [Is this thing on?]))
]

#show: e.stateful.toggle(true)

#show: e.stateful.set_(wock-e, color: yellow)

#[
  #show: e.stateful.toggle(false)

  #show: e.set_(wock-e, inner: [Def])

  #(wock-e.get)(w => assert.eq(w.color, yellow))
  #(wock-e.get)(w => assert.eq(w.inner, [Def]))
]

#(wock-e.get)(w => assert.eq(w.color, yellow))
#(wock-e.get)(w => assert.ne(w.inner, [Def]))

#show: e.stateful.set_(wock-e, inner: [Is it still working?])

#(wock-e.get)(w => assert.eq(w.color, yellow))
#(wock-e.get)(w => assert.eq(w.inner, [Is it still working?]))
