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

// Folding
#assert.eq((types.smart(stroke).fold)(auto, 4pt + red), 4pt + red)
#assert.eq((types.smart(stroke).fold)(4pt + red, auto), auto)
#assert.eq((types.smart(stroke).fold)(3pt + yellow, stroke(blue)), 3pt + blue)

#assert.eq((types.union(auto, stroke).fold)(auto, 4pt + red), 4pt + red)
#assert.eq((types.union(auto, stroke).fold)(4pt + red, auto), auto)
#assert.eq((types.union(auto, stroke).fold)(3pt + yellow, stroke(blue)), 3pt + blue)

// Combine
#assert.eq((types.smart(types.option(stroke)).fold)(auto, 4pt + red), 4pt + red)
#assert.eq((types.smart(types.option(stroke)).fold)(4pt + red, auto), auto)
#assert.eq((types.smart(types.option(stroke)).fold)(none, 4pt + red), 4pt + red)
#assert.eq((types.smart(types.option(stroke)).fold)(4pt + red, none), none)
#assert.eq((types.smart(types.option(stroke)).fold)(3pt + yellow, stroke(blue)), 3pt + blue)

#assert.eq((types.option(types.smart(stroke)).fold)(auto, 4pt + red), 4pt + red)
#assert.eq((types.option(types.smart(stroke)).fold)(4pt + red, auto), auto)
#assert.eq((types.option(types.smart(stroke)).fold)(none, 4pt + red), 4pt + red)
#assert.eq((types.option(types.smart(stroke)).fold)(4pt + red, none), none)
#assert.eq((types.option(types.smart(stroke)).fold)(3pt + yellow, stroke(blue)), 3pt + blue)
