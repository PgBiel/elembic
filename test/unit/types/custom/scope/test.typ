#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: types, field
#import types: native
#import "/src/types/types.typ": cast

#let person = types.declare(
  "person",
  fields: (
    field("name", str, required: true),
    field("age", int, required: true),
    field("border", stroke, default: 5pt),
  ),
  scope: {
    import "scope.typ"
    scope
  },
  prefix: "mypkg"
)

#let person-scope = e.scope(person)

#assert.eq(e.scope(person("John", 100)), person-scope)

#person-scope.subwock(color: blue)

#assert.eq(e.fields(person-scope.subperson("a", 5)), (name: "a", age: 5, border: stroke(5pt)))

#assert.eq(person-scope.do-math(2, 3), 5)
#assert.eq(person-scope.value, 50)
