#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ": types
#import "/src/types/types.typ": cast

// TODO: test custom types
#assert.eq(cast(red, types.any), (true, red))
#assert.eq(cast(none, types.any), (true, none))
#assert.eq(cast(auto, types.any), (true, auto))
#assert.eq(cast("a", types.any), (true, "a"))
#assert.eq(cast([b], types.any), (true, [b]))
#assert.eq(cast(5, types.any), (true, 5))
#assert.eq(type(cast(5, types.any).at(1)), int)
#assert.eq(cast(5.0, types.any), (true, 5.0))
#assert.eq(cast(5pt, types.any), (true, 5pt))
#assert.eq(cast(5%, types.any), (true, 5%))
#assert.eq(cast(5pt + 5%, types.any), (true, 5pt + 5%))
#assert.eq(cast(1pt + black, types.any), (true, 1pt + black))
