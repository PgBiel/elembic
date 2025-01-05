#import "/test/unit/base.typ": empty, unwrap, type-assert-eq
#show: empty

#import "/src/lib.typ": types
#import types: native
#import "/src/types/types.typ": cast

#assert.eq(cast(5pt, native.relative_), (true, 5pt + 0%))
#type-assert-eq(unwrap(cast(5pt, native.relative_)), relative)
#assert.eq(cast(5%, native.relative_), (true, 5% + 0pt))
#type-assert-eq(unwrap(cast(5%, native.relative_)), relative)
#assert.eq(cast(5% + 5pt, native.relative_), (true, 5% + 5pt))
#assert.eq(cast(5pt, native.length_), (true, 5pt))
#assert.eq(cast(5%, native.length_), (false, "expected length, found ratio"))
#assert.eq(cast(5% + 5pt, native.length_), (false, "expected length, found relative length"))
#assert.eq(cast(5%, types.union(length, relative)), (true, 5% + 0pt))
#type-assert-eq(unwrap(cast(5%, types.union(length, relative))), relative)
#assert.eq(cast(5pt, types.union(length, relative)), (true, 5pt))
#type-assert-eq(unwrap(cast(5pt, types.union(length, relative))), length)
#assert.eq(cast(123, native.relative_), (false, "expected relative length, length or ratio, found integer"))
