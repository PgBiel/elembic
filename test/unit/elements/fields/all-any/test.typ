#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: element, field, types

#let bool-or-pos-float = types.wrap(
  types.union(bool, float),
  check: _ => x => if type(x) == bool { true } else { x >= 0.0 },
  error: _ => _ => "float must be positive or zero"
)

#let all-fields = (
  field("color", types.any, required: true),
  field("backcolor", types.any, required: true),
  field("sign", types.any, default: 3em),
  field("name", types.any, default: 3em),
)

#let (door, door-e) = element(
  "door",
  display: it => {},
  fields: all-fields
)

#let (udoor, udoor-e) = element(
  "udoor",
  display: it => {},
  fields: all-fields,
  allow-unknown-fields: true
)

#door(red, 50)
#udoor(5pt, 60)

#door(10pt, 80, sign: "a", name: "b")
#let u = udoor(10pt, 80, sign: "a", name: "b", asdfasdf: 50)

#assert.eq(e.data(u).fields.asdfasdf, 50)
