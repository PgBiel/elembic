#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ": types
#import "/src/types/types.typ": cast, default

#assert.eq(cast(red, types.smart(color)), (true, red))
#assert.eq(cast(auto, types.smart(color)), (true, auto))
#assert.eq(cast(auto, types.union(auto, color)), (true, auto))
#assert.eq(cast(none, types.smart(color)), (false, "expected auto or color, found none"))
#assert.eq(cast(none, types.union(auto, color)), (false, "expected auto or color, found none"))
#assert.eq(cast("a", types.smart(color)), (false, "expected auto or color, found string"))

#assert.eq(default(types.smart(color)), (true, auto))
#assert.eq(default(types.union(auto, color)), (true, auto))
