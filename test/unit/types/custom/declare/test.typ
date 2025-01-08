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

#assert.eq(cast(sides(int)(left: 5, right: 10), sides(int)), (true, sides(int)(left: 5, right: 10, top: none, bottom: none)))
#assert.eq(cast((left: 5, right: 10), sides(int)), (false, "expected sides of integer, found dictionary"))
#assert.eq(cast(sides(stroke)(top: 5pt, right: black, left: 5pt + black), sides(stroke)), (true, sides(stroke)(top: stroke(5pt), right: stroke(black), left: 5pt + black, bottom: none)))
