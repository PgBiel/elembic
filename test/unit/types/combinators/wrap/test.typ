#import "/test/unit/base.typ": empty, type-assert-eq, unwrap
#show: empty

#import "/src/lib.typ": types, result
#import result: ok, err
#import types: exact, literal, native, wrap
#import "/src/types/types.typ": cast, validate, default

#let larger-len = wrap(
  types.option(length), name: "larger length", cast: _ => x => if x != none and x > 5pt { x * 55 } else { x }, default: (0pt,),
  output: prev => prev
)
#let pos-int = wrap(int, name: "positive integer", check: _ => i => i > 0, error: _ => i => "integer must be positive")
#let neg-int = wrap(int, name: "negative integer", check: _ => i => i < 0, error: _ => i => "integer must be negative", default: (-1,))
#let singleton-array = wrap(
  types.any,
  name: "value wrapped in singleton array",
  output: (array,),
  cast: _ => v => if type(v) == array and v.len() == 1 { v } else { (v,) }
)

#assert.eq(cast(none, larger-len), ok(none))
#assert.eq(cast(4pt, larger-len), ok(4pt))
#assert.eq(cast(10pt, larger-len), ok(550pt))
#assert.eq(cast(0%, larger-len), err("expected none or length, found ratio"))
#assert.eq(cast(5, pos-int), ok(5))
#assert.eq(cast(-5, pos-int), err("integer must be positive"))
#assert.eq(cast(-5, neg-int), ok(-5))
#assert.eq(cast(5, neg-int), err("integer must be negative"))
#assert.eq(cast((-56, <A>, 5), types.array(types.union(label, neg-int))), err("an element in an array of label or negative integer did not typecheck\n  hint: at position 2: all typechecks for union failed\n  hint (negative integer): integer must be negative"))

// any input
#assert.eq(cast(105, singleton-array), ok((105,)))
#assert.eq(cast((<A>,), singleton-array), ok((<A>,)))
#assert.eq(cast(0.5, types.union(float, singleton-array)), ok(0.5))
#assert.eq(cast("a", types.union(float, singleton-array)), ok(("a",)))
#assert.eq(cast(("a",), types.union(float, singleton-array)), ok(("a",)))

#assert.eq(default(singleton-array).first(), false)
#assert.eq(default(larger-len), (true, 0pt))
#assert.eq(default(neg-int), (true, -1))
