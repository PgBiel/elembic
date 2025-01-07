#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: element, field, types

#let (door, door-e) = element(
  "door",
  display: it => {},
  fields: ()
)

#let (udoor, udoor-e) = element(
  "udoor",
  display: it => {},
  fields: (),
  allow-unknown-fields: true
)

#door()
#udoor(abc: 5pt, def: 60)

#door()
#let u = udoor(g: 10pt, sign: "a", name: "b", asdfasdf: 50)

#assert.eq(e.data(u).fields.asdfasdf, 50)
