#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: field

#let wock = e.element.declare(
  "wock",
  display: it => {},
  fields: (
    field("color", color, default: red),
    field("border", stroke, default: red),
    field("inner", content, default: [Hello!])
  ),
  prefix: ""
)

#show: e.set_(wock, border: 4pt)
#show: e.set_(wock, border: (miter-limit: 50))
#show: e.set_(wock, border: 10pt)

#let assert-ctx(it, body: auto, custom-ref: auto) = {
  let wock-fields = (e.ctx(it).get)(wock)
  assert.eq(wock-fields.color, red)
  assert.eq(wock-fields.border, stroke(paint: red, thickness: 10pt, miter-limit: 50))
  assert.eq(wock-fields.inner, [Hello!])

  if body == auto {
    panic("body should be specified (a boolean: true if the body should be non-none at this point, false if it should be none")
  } else {
    assert.eq(e.data(it).body != none, body)
  }

  if custom-ref == auto {
    panic("custom-ref should be specified (a boolean: true if 'custom-ref' should be non-none at this point, false if it should be none")
  } else {
    assert.eq(e.data(it).custom-ref != none, custom-ref)
  }
}

#let mock-factory = e.element.declare.with(
  "mock",
  display: it => {
    assert-ctx(it, body: false, custom-ref: false)
    []
  },
  fields: (),
  reference: (
    supplement: assert-ctx.with(body: true, custom-ref: true),
    numbering: it => { assert-ctx(it, body: true, custom-ref: true); "1." },
    custom: it => { assert-ctx(it, body: true, custom-ref: false); [] },
  ),
  outline: (caption: assert-ctx.with(body: true, custom-ref: true)),
  prefix: ""
)

#[
  #let mock = mock-factory()
  #mock()
]

#[
  #let mock = mock-factory(contextual: true)
  #mock()
]

#[
  #let mock = mock-factory(count: _ => assert-ctx.with(body: false, custom-ref: false))
  #mock()
]

#[
  #let mock = mock-factory(count: _ => assert-ctx.with(body: false, custom-ref: false), contextual: true)
  #mock()
]

#[
  #let mock = mock-factory(synthesize: it => { assert-ctx(it, body: false, custom-ref: false); it }, contextual: true)
  #mock()
]

#[
  #let mock = mock-factory(synthesize: it => { assert-ctx(it, body: false, custom-ref: false); it }, count: _ => assert-ctx.with(body: false, custom-ref: false))
  #mock()
]

#[
  #let mock = mock-factory(synthesize: it => { assert-ctx(it, body: false, custom-ref: false); it }, count: _ => assert-ctx.with(body: false, custom-ref: false), contextual: true)
  #mock()
]
