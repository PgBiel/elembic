/// Test revoke rules not affecting future filtered / show / cond-set rules

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
    field("run", function, default: _ => none),
    field("inner", content, default: [])
  ),
  prefix: ""
)

// Test rule just to not trigger useless revoke optimization
#show: e.named("abc", e.show_(wock, panic))

#show: e.revoke("abc")

#let show-test-state = state("show-test", false)
#show: e.named("abc", e.set_(wock, border: blue + 8pt))
#show: e.named("abc", e.cond-set(wock, size: 4))
#show: e.named("abc", e.filtered(wock, e.set_(wock, color: yellow)))
#show: e.named("abc", e.show_(wock, it => it + show-test-state.update(true)))

#wock(run: it => assert.eq(it.size, 4))
#wock(inner: e.get(get => assert.eq(get(wock).color, yellow)))
#context assert.eq(show-test-state.get(), true)
