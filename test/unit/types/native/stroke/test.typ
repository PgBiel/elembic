#import "/test/unit/base.typ": empty, unwrap, type-assert-eq
#show: empty

#import "/src/lib.typ": types
#import types: native
#import "/src/types/types.typ": cast, default
#import "/src/types/native.typ": tiling

#let pattern-name = if sys.version >= version(0, 13, 0) { "tiling" } else { "pattern" }
#let sample-tiling = tiling[a]
#assert.eq(cast(5pt + red, native.stroke_), (true, 5pt + red))
#assert.eq(cast(5pt, native.stroke_), (true, stroke(thickness: 5pt)))
#assert.eq(cast(5%, native.stroke_), (false, "expected stroke, length, color, gradient, " + pattern-name + " or dictionary, found ratio"))
#assert.eq(cast(red, native.stroke_), (true, stroke(paint: red)))
#assert.eq(cast(sample-tiling, native.stroke_), (true, stroke(paint: sample-tiling)))
#assert.eq(cast(gradient.linear(red, blue), native.stroke_), (true, stroke(paint: gradient.linear(red, blue))))
#assert.eq(cast((paint: red), native.stroke_), (true, stroke(paint: red)))

#assert.ne(unwrap(default(native.stroke_)), 1pt + black)
