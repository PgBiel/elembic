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

#assert.eq(cast(person1("John", 100), person-union), (true, person1("John", 100)))
#assert.eq(cast(person2("John2", 100), person-union), (true, person2("John2", 100)))
#assert.eq(cast(1, person-union), (true, person1("Young", 1)))
#assert.eq(cast(20, person-union), (true, person1("Generic", 20)))
#assert.eq(cast(10pt, person-union), (true, person2("Generic", 5, border: 10pt)))
#assert.eq(cast(20pt, person-union), (false, "all typechecks for union failed\n  hint (person1): failed to cast to custom type 'person1'\n  hint (person2): failed to cast to custom type 'person2'"))
#assert.eq(cast("abc", person-union), (false, "expected person1, integer, person2 or length, found string"))
