#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ": types
#import "/src/types/types.typ": cast, default

#assert.eq(cast(red, types.option(color)), (true, red))
#assert.eq(cast(none, types.option(color)), (true, none))
#assert.eq(cast(none, types.union(none, color)), (true, none))
#assert.eq(cast(auto, types.option(color)), (false, "expected none or color, found auto"))
#assert.eq(cast(auto, types.union(none, color)), (false, "expected none or color, found auto"))
#assert.eq(cast("a", types.option(color)), (false, "expected none or color, found string"))

#assert.eq(default(types.option(color)), (true, none))
#assert.eq(default(types.union(none, color)), (true, none))
