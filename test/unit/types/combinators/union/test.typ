#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ": types
#import "/src/types/types.typ": cast

#assert.eq(cast(red, types.union(color, float, content, length)), (true, red))
#assert.eq(cast(5, types.union(color, float, content, length)), (true, 5.0))
#assert.eq(cast(5.0, types.union(color, float, content, length)), (true, 5.0))
#assert.eq(cast("a", types.union(color, float, content, length)), (true, [a]))
#assert.eq(cast([a], types.union(color, float, content, length)), (true, [a]))
#assert.eq(cast(5pt, types.union(color, float, content, length)), (true, 5pt))
#assert.eq(cast(none, types.union(color, float, content, length)), (false, "expected color, float, integer, content, string or length, found none"))
#assert.eq(cast(5, types.union(color, types.exact(float), content, length)), (false, "expected color, float, content, string or length, found integer"))
