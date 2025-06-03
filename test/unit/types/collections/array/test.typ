#import "/test/unit/base.typ": empty, type-assert-eq, unwrap
#show: empty

#import "/src/lib.typ": types
#import types: exact, literal, ok, err, native
#import "/src/types/types.typ": cast, validate, default

#let pos-int = types.wrap(int, name: "positive integer", check: _ => i => i > 0, error: _ => i => "expected positive integer, got " + str(i))
#let pos-if-int-or-any = types.wrap(types.any, name: "positive integer or any", check: _ => i => type(i) != int or i > 0, error: _ => i => "expected positive integer, got " + str(i))

#assert.eq(cast((), types.array(int)), ok(()))
#assert.eq(cast((5pt, 6%), types.array(relative)), ok((5pt + 0%, 0pt + 6%)))
#type-assert-eq(unwrap(cast((5pt, 6%), types.array(relative))).at(0), relative)
#assert.eq(cast((5.0, 6.0, "abc"), types.array(float)), err("an element in an array of float did not typecheck\n  hint: at position 2: expected float or integer, found string"))
#assert.eq(cast((5, 6, "abc", 0), types.array(pos-int)), err("2 elements in an array of positive integer did not typecheck\n  hint: at position 2: expected integer, found string\n  hint: at position 3: expected positive integer, got 0"))
#assert.eq(cast((5,), types.array(float)), ok((5.0,)))
#type-assert-eq(unwrap(cast((5,), types.array(float))).first(), float)
#assert.eq(cast(("abc", "abc", [def]), types.array(content)), ok(([abc], [abc], [def])))
#assert.eq(cast(("abc", "abc", "def"), types.array(types.union("abc", "def"))), ok(("abc", "abc", "def")))
#assert.eq(cast(("abc", "abc", "defg"), types.array(types.union("abc", "def"))).first(), false)

#assert.eq(cast(("abc", 50, 2), types.array(pos-if-int-or-any)), ok(("abc", 50, 2)))
#assert.eq(cast(("abc", 50, 0), types.array(pos-if-int-or-any)), err("an element in an array of positive integer or any did not typecheck\n  hint: at position 2: expected positive integer, got 0"))

#assert.eq(default(types.array(types.union(float, int, color))), (true, ()))

// Folding:
// (1, 2), (3, 4) => (1, 2, 3, 4)
#assert.eq(types.array(int).fold, auto)
