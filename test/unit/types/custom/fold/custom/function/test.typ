#import "/test/unit/base.typ": empty, unwrap
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
  fold: _ => (outer, inner) => if outer.age > inner.age { outer } else { inner },
  prefix: "mypkg"
)

#let fold = unwrap(e.types.typeinfo(person)).fold

#assert.eq(fold(person("Rob", 120, border: black), person("John", 60, border: (miter-limit: 100))), person("Rob", 120, border: black))
#assert.eq(fold(person("Rob", 60, border: black), person("John", 120, border: (miter-limit: 100))), person("John", 120, border: (miter-limit: 100)))
