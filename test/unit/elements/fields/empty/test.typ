#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: field, types

#let (door, door-e) = e.element.declare(
  "door",
  display: it => {},
  fields: ()
)

#let (udoor, udoor-e) = e.element.declare(
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
