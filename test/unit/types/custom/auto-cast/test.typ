#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: types, field
#import types: native
#import "/src/types/types.typ": cast

#let person = types.declare(
  "person",
  fields: (
    field("name", str, required: true, named: true),
    field("age", int, default: 20),
    field("border", stroke, default: 5pt),
  ),
  casts: (
    (from: dictionary),
  ),
  prefix: "mypkg"
)

#assert.eq(cast(person(name: "John", age: 100), person), (true, person(name: "John", age: 100)))
#assert.eq(cast((name: "John", age: 100), person), (true, person(name: "John", age: 100)))
#assert.eq(cast("abc", person), (false, "expected person or dictionary, found string"))
