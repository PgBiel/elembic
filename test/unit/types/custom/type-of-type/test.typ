#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ": types, field
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

#assert.eq(types.typeid(sides(int)), "custom type")
#assert.eq(cast(sides(int), types.custom-type), (true, sides(int)))
#assert.eq(cast(sides(red), types.literal(sides(int), sides(red)), (true, sides(red))))
#assert.eq(cast(sides(red), dictionary), (false, "expected dictionary, found custom type"))
#assert.eq(cast(sides(red), types.union(dictionary, stroke, types.custom-type)), (true, sides(red)))
