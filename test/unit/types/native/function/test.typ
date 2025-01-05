#import "/test/unit/base.typ": empty, type-assert-eq, unwrap
#show: empty

#import "/src/lib.typ": types
#import types: native
#import "/src/types/types.typ": cast

#let f = x => x
#assert.eq(cast(f, native.function_), (true, f))
#assert.eq(cast(int, native.function_), (true, int))
#type-assert-eq(unwrap(cast(int, native.function_)), type)
#assert.eq(cast(sym.arrow, native.function_), (false, "expected type or function, found symbol"))
#assert.eq(cast(int, types.exact(native.function_)), (false, "expected function, found type"))
