#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ": types
#import types: exact, literal, ok, err, native, cast

#assert.eq(cast(5, float), ok(5.0))
#assert.eq(type(cast(5, float).at(1)), float)
#assert.eq(cast(5, exact(float)), err("expected float, found integer"))
#assert.eq(cast(5, types.union(float, stroke)), ok(5.0))
#assert.eq(type(cast(5, types.union(float, stroke)).at(1)), float)
#assert.eq(cast(5pt, types.union(float, stroke)), ok(stroke(5pt)))
#assert.eq(cast(5, exact(types.union(float, stroke(5pt)))), err("expected float or stroke, found integer"))
#assert.eq(cast(5pt, exact(types.union(float, stroke(5pt)))), err("expected float or stroke, found length"))
#assert.eq(cast(5, literal(5.0)), ok(5.0))
#assert.eq(type(cast(5, literal(5.0)).at(1)), float)
#assert.eq(cast(5, exact(5.0)), err("expected float, found integer"))

#assert.ne(exact(stroke).fold, none)
