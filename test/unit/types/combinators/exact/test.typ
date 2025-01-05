#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ": types
#import types: exact, literal, ok, err, native
#import "/src/types/types.typ": cast, validate

#assert.eq(cast(5, native.float_), ok(5.0))
#assert.eq(type(cast(5, native.float_).at(1)), float)
#assert.eq(cast(5, exact(float)), err("expected float, found integer"))
#assert.eq(cast(5, literal(5.0)), ok(5.0))
#assert.eq(type(cast(5, literal(5.0)).at(1)), float)
#assert.eq(cast(5, exact(5.0)), err("expected float, found integer"))
