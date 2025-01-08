#import "/test/unit/base.typ": empty
#show: empty
#show "abc": hide

#import "/src/lib.typ" as e: field

#let wock = e.element.declare(
  "wock",
  display: it => {},
  fields: (
    field("color", color, default: red),
    field("inner", content, default: [])
  ),
  prefix: ""
)

#[
  #show: e.set_(wock, color: blue)

  #[
    #show: e.stateful.enable()

    #show: e.stateful.set_(wock, inner: [Abc])

    #e.get(get => assert.eq(get(wock).color, blue))
    #e.get(get => assert.eq(get(wock).inner, [Abc]))
  ]

  #e.get(get => assert.eq(get(wock).color, blue))
  #e.get(get => assert.ne(get(wock).inner, [Abc]))

  #show: e.set_(wock, inner: [Is this thing on?])

  #e.get(get => assert.eq(get(wock).color, blue))
  #e.get(get => assert.eq(get(wock).inner, [Is this thing on?]))
]

#show: e.stateful.enable()

#show: e.stateful.set_(wock, color: yellow)

#[
  #show: e.stateful.disable()

  #show: e.set_(wock, inner: [Def])

  #e.get(get => assert.eq(get(wock).color, yellow))
  #e.get(get => assert.eq(get(wock).inner, [Def]))
]

#e.get(get => assert.eq(get(wock).color, yellow))
#e.get(get => assert.ne(get(wock).inner, [Def]))

#show: e.stateful.set_(wock, inner: [Is it still working?])

#e.get(get => assert.eq(get(wock).color, yellow))
#e.get(get => assert.eq(get(wock).inner, [Is it still working?]))
