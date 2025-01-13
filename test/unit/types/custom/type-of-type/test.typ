#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: types, field
#import types: native
#import "/src/types/types.typ": cast

#let sides(t) = {
  let (res, t) = types.typeinfo(t)
  if not res {
    assert(false, message: t)
  }

  types.declare(
    "sides of " + t.name,
    fields: (
      field("left", types.option(t)),
      field("right", types.option(t)),
      field("top", types.option(t)),
      field("bottom", types.option(t)),
    ),
    prefix: ""
  )
}

#assert.eq(types.typeid(e.data(sides(int))), "custom type")
#assert.eq(cast(e.data(sides(int)), types.custom-type), (true, e.data(sides(int))))
#assert.eq(cast(e.data(sides(red)), types.union(types.literal(e.data(sides(int))), types.literal(e.data(sides(red))))), (true, e.data(sides(red))))
#assert.eq(cast(e.data(sides(red)), dictionary), (false, "expected dictionary, found custom type"))
#assert.eq(cast(e.data(sides(red)), types.union(dictionary, stroke, types.custom-type)), (true, e.data(sides(red))))
#assert.eq(cast(e.data(sides(red)), types.literal(e.data(sides(red)))), (true, e.data(sides(red))))
#assert.eq(cast(e.data(sides(blue)), types.literal(e.data(sides(red)))), (false, "given value wasn't equal to literal 'custom-type(name: \"sides of literal 'rgb(\\\"#ff4136\\\")'\", tid: \"t__---_sides of literal 'rgb(\\\"#ff4136\\\")'\")'"))
