#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ": types
#import types: native
#import "/src/types/types.typ": cast

#let content2 = (:..native.content_, output: (int,), cast: _ => 5, __future_cast: (max-version: 9999))
#let lit1 = (:..types.literal(20), output: (int,), check: none, __future_cast: (max-version: 9999))
#let lit2 = (:..types.literal(20), output: (int,), check: none, cast: _ => 5, __future_cast: (max-version: 9999))
#let lit3 = (:..types.literal(20), output: (int,), cast: _ => 5, __future_cast: (max-version: 9999))
#let lit4 = (:..types.literal(20), output: (int,), check: i => i > 10, error: _ => "must be more than 10", cast: _ => 5, __future_cast: (max-version: 9999))

#assert.eq(cast("a", lit1), (false, "expected integer, found string"))
#assert.eq(cast(20, lit1), (true, 20))
#assert.eq(cast(10, lit1), (true, 10))

#assert.eq(cast("a", lit2), (false, "expected integer, found string"))
#assert.eq(cast(20, lit2), (true, 5))
#assert.eq(cast(10, lit2), (true, 5))

#assert.eq(cast("a", lit3), (false, "expected integer, found string"))
#assert.eq(cast(20, lit3), (true, 5))
#assert.eq(cast(10, lit3), (false, "given value wasn't equal to literal '20'"))

#assert.eq(cast("a", lit4), (false, "expected integer, found string"))
#assert.eq(cast(20, lit4), (true, 5))
#assert.eq(cast(15, lit4), (true, 5))
#assert.eq(cast(10, lit4), (false, "must be more than 10"))

#assert.eq(cast(10, types.union(lit1, lit2)), (true, 10))
#assert.eq(cast(20, types.union(lit2, lit3)), (true, 5))
#assert.eq(cast(10, types.union(lit2, lit3)), (true, 5))
#assert.eq(cast(15, types.union(lit3, lit4)), (true, 5))
#assert.eq(cast(10, types.union(lit3, lit4)), (false, "all typechecks for union failed\n  hint (literal '20'): given value wasn't equal to literal '20'\n  hint (literal '20'): must be more than 10"))
#assert.eq(cast(20, types.union(str, lit1)), (true, 20))
#assert.eq(cast(10, types.union(str, lit1)), (true, 10))
#assert.eq(cast(20, types.union(str, lit2)), (true, 5))
#assert.eq(cast(10, types.union(str, lit2)), (true, 5))
#assert.eq(cast(20, types.union(str, lit3)), (true, 5))
#assert.eq(cast(10, types.union(str, lit3)), (false, "all typechecks for union failed\n  hint (literal '20'): given value wasn't equal to literal '20'"))

#assert.eq(cast([abc], content2), (true, 5))
#assert.eq(cast("abc", content2), (true, 5))
#assert.eq(cast(sym.eq, content2), (true, 5))
#assert.eq(cast(none, content2), (true, 5))
#assert.eq(cast(123, content2), (false, "expected none, content, string or symbol, found integer"))

#assert.eq(cast([abc], types.union(content2, native.ratio_)), (true, 5))
#assert.eq(cast(none, types.union(content2, native.ratio_)), (true, 5))

#assert.eq(cast([abc], types.union(float, content2)), (true, 5))
#assert.eq(cast(none, types.union(float, content2)), (true, 5))

#assert.eq(cast(([abc],), types.array(content2)), (true, (5,)))
#assert.eq(cast((none,), types.array(content2)), (true, (5,)))

#assert.eq(cast((a: [abc],), types.dict(content2)), (true, (a: 5)))
#assert.eq(cast((b: none,), types.dict(content2)), (true, (b: 5)))
