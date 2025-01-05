#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ": types
#import "/src/types/types.typ": cast, default

#assert.eq(cast(5deg, types.literal(5deg)), (true, 5deg))
#assert.eq(cast(10deg, types.literal(5deg)), (false, "given value wasn't equal to literal '5deg'"))
#assert.eq(cast(red, types.union("a", red)), (true, red))
#assert.eq(cast("a", types.union("a", red)), (true, "a"))
#assert.eq(cast("b", types.union("a", red)), (false, "given value wasn't equal to literals 'a' or 'rgb(\"#ff4136\")'"))
#assert.eq(cast(yellow, types.union("a", red)), (false, "given value wasn't equal to literals 'a' or 'rgb(\"#ff4136\")'"))
#assert.eq(cast(5, types.union(10, 5.0)), (true, 5.0))
#assert.eq(type(cast(5, types.union(10, 5.0)).at(1)), float)

#assert.eq(default(types.literal(5deg)), (true, 5deg))
#assert.eq(default(types.literal(types)), (true, types))
