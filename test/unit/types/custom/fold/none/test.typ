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
  fold: none,
  prefix: "mypkg"
)

#assert.eq(unwrap(e.types.typeinfo(person)).fold, none)
