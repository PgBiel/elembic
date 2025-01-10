#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: field

#let wock = e.element.declare(
  "wock",
  display: it => {
    (it.run)(it)
  },
  fields: (
    field("color", color, default: red),
    field("inner", content, default: [Hello!]),
    field("run", function, default: () => {})
  ),
  template: it => {
    set text(fill: red)
    show: e.set_(e.data(it).func, inner: [Bye!])
    it
  },
  prefix: ""
)

#wock(run: it => context {
  assert.eq(it.color, red)
  assert.eq(it.inner, [Bye!])
  assert.eq(text.fill, red)
})

#show e.selector(wock): set text(blue)

#wock(run: it => context {
  assert.eq(it.color, red)
  assert.eq(it.inner, [Bye!])
  assert.eq(text.fill, blue)
})
