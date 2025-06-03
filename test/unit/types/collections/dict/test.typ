#import "/test/unit/base.typ": empty, type-assert-eq, unwrap
#show: empty

#import "/src/lib.typ": types
#import types: exact, literal, ok, err, native
#import "/src/types/types.typ": cast, validate, default

#let pos-int = types.wrap(int, name: "positive integer", check: _ => i => i > 0, error: _ => i => "expected positive integer, got " + str(i))
#let pos-if-int-or-any = types.wrap(types.any, name: "positive integer or any", check: _ => i => type(i) != int or i > 0, error: _ => i => "expected positive integer, got " + str(i))

#assert.eq(cast((:), types.dict(int)), ok((:)))
#assert.eq(cast((abc: 5pt, def: 6%), types.dict(relative)), ok((abc: 5pt + 0%, def: 0pt + 6%)))
#type-assert-eq(unwrap(cast((abc: 5pt, def: 6%), types.dict(relative))).abc, relative)
#assert.eq(cast((abc: 5.0, def: 6.0, ghi: "abc"), types.dict(float)), err("a value in a dictionary of float did not typecheck\n  hint: at key \"ghi\": expected float or integer, found string"))
#assert.eq(cast((abc: 5, def: 6, ghi: "abc", jkl: 0), types.dict(pos-int)), err("2 values in a dictionary of positive integer did not typecheck\n  hint: at key \"ghi\": expected integer, found string\n  hint: at key \"jkl\": expected positive integer, got 0"))
#assert.eq(cast((abc: 5), types.dict(float)), ok((abc: 5.0)))
#type-assert-eq(unwrap(cast((abc: 5), types.dict(float))).abc, float)
#assert.eq(cast((v1: "abc", v2: "abc", v3: [def]), types.dict(content)), ok((v1: [abc], v2: [abc], v3: [def])))
#assert.eq(cast((v1: "abc", v2: "abc", v3: "def"), types.dict(types.union("abc", "def"))), ok((v1: "abc", v2: "abc", v3: "def")))
#assert.eq(cast((v1: "abc", v2: "abc", v3: "defg"), types.dict(types.union("abc", "def"))).first(), false)

#assert.eq(cast((v0: "abc", v1: 50, v2: 2), types.dict(pos-if-int-or-any)), ok((v0: "abc", v1: 50, v2: 2)))
#assert.eq(cast((v0: "abc", v1: 50, v2: 0), types.dict(pos-if-int-or-any)), err("a value in a dictionary of positive integer or any did not typecheck\n  hint: at key \"v2\": expected positive integer, got 0"))

#assert.eq(default(types.dict(types.union(float, int, color))), (true, (:)))

// Folding:
#import types: dict
#assert.eq(dict(int).fold, auto)
#assert.eq(
  (dict(array).fold)((a: (1, 2), b: (), c: (5,)), (a: (3, 4), b: (45,), d: (8, 8, 8))),
  (a: (1, 2, 3, 4), b: (45,), c: (5,), d: (8, 8, 8))
)
#assert.eq(
  (dict(stroke).fold)(
    (a: stroke(red), b: 4pt + blue, c: 5pt + purple, e: 6pt + green),
    (a: stroke(8em), b: stroke(10pt), d: stroke(orange), e: 10pt + blue)
  ),
  (a: 8em + red, b: 10pt + blue, c: 5pt + purple, d: stroke(orange), e: 10pt + blue)
)
