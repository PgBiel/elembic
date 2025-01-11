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

#assert.eq(cast(person("John", 100), types.union(types.literal(person("John", 100)), types.literal(person("John", 200)))), (true, person("John", 100)))
#assert.eq(cast(person("John", 200), types.union(types.literal(person("John", 100)), types.literal(person("John", 200)))), (true, person("John", 200)))
#assert.eq(cast(person("John", 101), types.union(types.literal(person("John", 100)), types.literal(person("John", 200)))), (false, "given value wasn't equal to literals 'person(border: 5pt, name: \"John\", age: 100)' or 'person(border: 5pt, name: \"John\", age: 200)'"))
