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
  prefix: "mypkg"
)

#assert.eq(e.repr(person("John", 5)), "person(border: 5pt, name: \"John\", age: 5)")
#assert.eq(e.tid(person), e.data(person).tid)
#assert.eq(e.tid(person("John", 5)), e.tid(person))
#assert.eq(e.func(person), person)
#assert.eq(e.func(person("John", 5)), person)
