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

#assert.eq(cast((2.0, 5,), types.array(float)), ok((2.0, 5.0,)))
#assert.eq(cast((2.0, 5,), exact(types.array(float))), err("an element in an array of float did not typecheck\n  hint: at position 1: expected float, found integer"))
#assert.eq(cast((2.0, 5,), types.array(exact(float))), err("an element in an array of float did not typecheck\n  hint: at position 1: expected float, found integer"))
#assert.eq(cast((a: 2.0, b: 5), types.dict(float)), ok((a: 2.0, b: 5.0)))
#assert.eq(cast((a: 2.0, b: 5), exact(types.dict(float))), err("a value in a dictionary of float did not typecheck\n  hint: at key \"b\": expected float, found integer"))
#assert.eq(cast((a: 2.0, b: 5), types.dict(exact(float))), err("a value in a dictionary of float did not typecheck\n  hint: at key \"b\": expected float, found integer"))

#assert.ne(exact(stroke).fold, none)
