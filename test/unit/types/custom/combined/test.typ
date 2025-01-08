#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ": types, field
#import types: native
#import "/src/types/base.typ": custom-type-key
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

#let casted-dict = types.wrap(
  dictionary,
  output: (dictionary,),
  cast: _ => d => d + (yep: "i am a dict")
)

#let many-types = types.union(int, red, sides(int), sides(red), casted-dict, function)

#assert.eq(cast(5, many-types), (true, 5))
#assert.eq(cast(red, many-types), (true, red))
#assert.eq(cast(sides(int)(left: 5, right: 10), many-types), (true, sides(int)(left: 5, right: 10, top: none, bottom: none)))
#assert.eq(cast(sides(red)(left: red, right: red), many-types), (true, sides(red)(left: red, right: red, top: none, bottom: none)))
#assert.eq(cast((a: 50, b: 6), many-types), (true, (a: 50, b: 6, yep: "i am a dict")))
#assert.eq(cast(int, many-types), (true, int))
#assert.eq(cast(cast, many-types), (true, cast))
// #panic(sides(stroke)().at(custom-type-key))
#assert.eq(
  cast(sides(stroke)(top: 5pt, right: black, left: 5pt + black), many-types),
  (false, "expected integer, color, sides of integer, sides of literal '" + repr(red) + "', dictionary, type or function, found sides of stroke")
)
