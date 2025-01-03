#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ": types
#import types: native
#import "/src/types/types.typ": cast

#assert.eq(cast(5, native.float_), (true, 5.0))
#assert.eq(cast(5.0, native.float_), (true, 5.0))
#assert.eq(cast(5, types.exact(native.float_)), (false, "expected float, found integer"))
#assert.eq(cast(5.0, types.exact(native.float_)), (true, 5.0))
#assert.eq(cast(5pt, native.float_), (false, "expected float or integer, found length"))
