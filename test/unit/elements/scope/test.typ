#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: field

#let wock = e.element.declare(
  "wock",
  display: it => {
    assert.eq(it.color, red)
    assert.eq(it.inner, [Hello!])
  },
  fields: (
    field("color", color, default: red),
    field("inner", content, default: [Hello!])
  ),
  scope: {
    import "scope.typ"
    scope
  },
  prefix: ""
)

#let wock-scope = e.scope(wock)

#wock-scope.subwock(color: blue)

#assert.eq(wock-scope.do-math(2, 3), 5)
#assert.eq(wock-scope.value, 50)
