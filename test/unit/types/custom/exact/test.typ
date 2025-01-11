#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: types, field
#import types: native
#import "/src/types/types.typ": cast

#let person1 = types.declare(
  "person1",
  fields: (
    field("name", str, required: true),
    field("age", int, required: true),
    field("border", stroke, default: 5pt),
  ),
  casts: (
    (from: int, check: i => i < 10, with: person => value => person("Young", value)),
    (from: int, with: person => value => person("Generic", value)),
  ),
  prefix: "mypkg"
)

#let person2 = types.declare(
  "person2",
  fields: (
    field("name", str, required: true),
    field("age", int, required: true),
    field("border", stroke, default: 5pt),
  ),
  casts: (
    (from: int, with: person => value => person("Generic", value)),
    (from: length, check: i => i.pt() < 15.0, with: person => value => person("Generic", 5, border: value)),
  ),
  prefix: "mypkg"
)

#let person-union = types.union(person1, person2)

#assert.eq(cast(5, person1), (true, person1("Young", 5)))
#assert.eq(cast(person1("Generic", 10), person1), (true, person1("Generic", 10)))
#assert.eq(cast(5, types.exact(person1)), (false, "expected person1, found integer"))
#assert.eq(cast(5, types.exact(types.exact(person1))), (false, "expected person1, found integer"))
#assert.eq(cast(person1("Generic", 10), types.exact(person1)), (true, person1("Generic", 10)))

#assert.eq(cast(5, person2), (true, person2("Generic", 5)))
#assert.eq(cast(person2("Generic", 10), person2), (true, person2("Generic", 10)))
#assert.eq(cast(5, types.exact(person2)), (false, "expected person2, found integer"))
#assert.eq(cast(person2("Generic", 10), types.exact(person2)), (true, person2("Generic", 10)))

#assert.eq(cast(person1("John", 100), types.exact(person-union)), (true, person1("John", 100)))
#assert.eq(cast(person2("John2", 100), types.exact(person-union)), (true, person2("John2", 100)))
#assert.eq(cast(1, types.exact(person-union)), (false, "expected person1 or person2, found integer"))
