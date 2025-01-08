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
  ),
  prefix: "mypkg",
  allow-unknown-fields: true
)

#assert.eq(cast(person("Rob", 60, something: "what?"), person), (true, person("Rob", 60, something: "what?")))
#assert.eq(person("Rob", 60, something: "what?").name, "Rob")
#assert.eq(person("Rob", 60, something: "what?").age, 60)
#assert.eq(person("Rob", 60, something: "what?").something, "what?")
