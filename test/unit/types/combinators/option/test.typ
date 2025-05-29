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

// Folding
#assert.eq((types.option(stroke).fold)(none, 4pt + red), 4pt + red)
#assert.eq((types.option(stroke).fold)(4pt + red, none), none)
#assert.eq((types.option(stroke).fold)(3pt + yellow, stroke(blue)), 3pt + blue)

#assert.eq((types.union(none, stroke).fold)(none, 4pt + red), 4pt + red)
#assert.eq((types.union(none, stroke).fold)(4pt + red, none), none)
#assert.eq((types.union(none, stroke).fold)(3pt + yellow, stroke(blue)), 3pt + blue)
