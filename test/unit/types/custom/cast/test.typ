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
  casts: (
    (from: int, check: i => i < 10, with: person => value => person("Young", value)),
    (from: int, with: person => value => person("Generic", value)),
    (from: float, check: f => f > 10.0, with: person => value => person("Generic", calc.floor(value))),
    (
      from: types.wrap(float, name: "large float", check: _ => f => f > 5.0, error: _ => _ => "value must be larger than 5"),
      check: f => f > 10.0, with: person => value => person("Generic", calc.floor(value))
    ),
    (from: stroke, with: person => value => person("Generic 2", 100, border: value)),
    (from: function, check: f => f == int, with: person => value => person("Joseph", value(50.5))),
  ),
  prefix: "mypkg"
)

#assert.eq(cast(person("John", 100), person), (true, person("John", 100)))
#assert.eq(cast(50, person), (true, person("Generic", 50)))
#assert.eq(cast(2, person), (true, person("Young", 2)))
#assert.eq(cast(95.6, person), (true, person("Generic", 95)))
#assert.eq(cast(gradient.linear(red, blue, green), person), (true, person("Generic 2", 100, border: gradient.linear(red, blue, green))))
#assert.eq(cast(int, person), (true, person("Joseph", 50)))
#assert.eq(cast("abc", person), (false, "expected person, integer, float, stroke, length, color, gradient, " + str(types.native.tiling) + ", dictionary, type or function, found string"))
#assert.eq(cast(5.0, person), (false, "all casts to custom type 'person' failed\n  hint (large float): value must be larger than 5"))
#assert.eq(cast(float, person), (false, "all casts to custom type 'person' failed"))
