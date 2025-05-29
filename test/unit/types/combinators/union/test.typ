#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ": types
#import "/src/types/types.typ": cast, default

#assert.eq(cast(red, types.union(color, float, content, length)), (true, red))
#assert.eq(cast(5, types.union(color, float, content, length)), (true, 5.0))
#assert.eq(cast(5.0, types.union(color, float, content, length)), (true, 5.0))
#assert.eq(cast("a", types.union(color, float, content, length)), (true, [a]))
#assert.eq(cast([a], types.union(color, float, content, length)), (true, [a]))
#assert.eq(cast(5pt, types.union(color, float, content, length)), (true, 5pt))
#assert.eq(cast(5pt, types.union(color, float, types.union(content, length))), (true, 5pt))
#assert.eq(cast(none, types.union(color, float, types.option(length))), (true, none))
#assert.eq(cast(sym.eq, types.union(color, float, content, length)), (true, [#sym.eq]))
#assert.eq(cast(none, types.union(color, float, length)), (false, "expected color, float, integer or length, found none"))
#assert.eq(cast(none, types.union(color, float, types.exact(content), length)), (false, "expected color, float, integer, content or length, found none"))
#assert.eq(cast(none, types.union(color, float, content, length)), (true, []))
#assert.eq(cast(5, types.union(color, types.exact(float), content, length)), (false, "expected color, float, none, content, string, symbol or length, found integer"))

#assert.eq(default(types.union(color, 5, float)).first(), false)

// Folding
// Option
#assert.eq((types.union(array, stroke).fold)((1,), (2,)), (1, 2))
#assert.eq((types.union(array, stroke).fold)(3pt + yellow, stroke(blue)), 3pt + blue)
#assert.eq((types.union(array, stroke).fold)(3pt + yellow, (1, 2)), (1, 2))
#assert.eq((types.union(array, stroke).fold)((1, 2), 3pt + yellow), 3pt + yellow)
