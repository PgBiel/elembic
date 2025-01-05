#import "/test/unit/base.typ": empty, type-assert-eq, unwrap
#show: empty

#import "/src/lib.typ": types
#import types: exact, literal, ok, err, native
#import "/src/types/types.typ": cast, validate, default

#assert.eq(cast((), types.array(int)), ok(()))
#assert.eq(cast((5pt, 6%), types.array(relative)), ok((5pt + 0%, 0pt + 6%)))
#type-assert-eq(unwrap(cast((5pt, 6%), types.array(relative))).at(0), relative)
#assert.eq(cast((5.0, 6.0, "abc"), types.array(float)), err("an element in an array of float did not typecheck\n  hint: at position 2: expected float or integer, found string"))
#assert.eq(cast((5,), types.array(float)), ok((5.0,)))
#type-assert-eq(unwrap(cast((5,), types.array(float))).first(), float)
#assert.eq(cast(("abc", "abc", "def"), types.array(types.union("abc", "def"))), ok(("abc", "abc", "def")))
#assert.eq(cast(("abc", "abc", "defg"), types.array(types.union("abc", "def"))).first(), false)

#assert.eq(default(types.array(types.union(float, int, color))), (true, ()))
