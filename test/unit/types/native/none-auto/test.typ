#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ": types
#import types: native
#import "/src/types/types.typ": cast

#assert.eq(types.literal(none), native.none_)
#assert.eq(types.literal(auto), native.auto_)
#assert.eq(types.union(none, 5), types.union(types.literal(none), 5))
#assert.eq(types.union(auto, 5), types.union(types.literal(auto), 5))

#assert.eq(cast(none, none), (true, none))
#assert.eq(cast(none, types.literal(none)), (true, none))
#assert.eq(cast(5, none), (false, "expected none, found integer"))

#assert.eq(cast(auto, auto), (true, auto))
#assert.eq(cast(auto, types.literal(auto)), (true, auto))
#assert.eq(cast(5, auto), (false, "expected auto, found integer"))
