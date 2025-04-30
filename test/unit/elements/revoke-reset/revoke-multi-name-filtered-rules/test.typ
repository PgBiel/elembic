/// Test revoking filtered rules with multiple names

#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: field, types

#let wock = e.element.declare(
  "wock",
  display: it => {
    (it.run)(it)
    it.inner
  },
  fields: (
    field("color", color, default: red),
    field("size", int, default: 100),
    field("border", types.exact(stroke), default: black + 1pt),
    field("state-data", types.option(types.any), default: none),
    field("run", function, default: _ => none),
    field("inner", content, default: [])
  ),
  prefix: ""
)

#let show-test-state = state("show-test", 0)
#show: e.named("abc", "def", e.cond-set(wock, size: 4))
#show: e.named("abc", "ghi", e.filtered(wock, e.set_(wock, color: yellow)))
#show: e.named("abc", "jkl", e.show_(wock, it => it + if e.fields(it).state-data != none { show-test-state.update(e.fields(it).state-data) }))

#wock(run: it => assert.eq(it.size, 4))
#wock(inner: e.get(get => assert.eq(get(wock).color, yellow)))
#wock(state-data: 88)
#context assert.eq(show-test-state.get(), 88)

#[
  #show: e.revoke("abc")

  #wock(run: it => assert.eq(it.size, 100))
  #wock(inner: e.get(get => assert.eq(get(wock).color, red)))
  #wock(state-data: 9999)
  #context assert.eq(show-test-state.get(), 88)
]

#[
  #show: e.revoke("def")

  #wock(run: it => assert.eq(it.size, 100))
  #wock(inner: e.get(get => assert.eq(get(wock).color, yellow)))
  #wock(state-data: 777)
  #context assert.eq(show-test-state.get(), 777)
]

#[
  #show: e.revoke("ghi")

  #wock(run: it => assert.eq(it.size, 4))
  #wock(inner: e.get(get => assert.eq(get(wock).color, red)))
  #wock(state-data: 444)
  #context assert.eq(show-test-state.get(), 444)
]

#[
  #show: e.revoke("jkl")

  #wock(run: it => assert.eq(it.size, 4))
  #wock(inner: e.get(get => assert.eq(get(wock).color, yellow)))
  #wock(state-data: 5555)
  #context assert.eq(show-test-state.get(), 444)
]
