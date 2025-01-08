#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ": types
#import types: native
#import "/src/types/types.typ": cast

#assert.eq(cast([abc], native.content_), (true, [abc]))
#assert.eq(cast("abc", native.content_), (true, [abc]))
#assert.eq(cast(sym.eq, native.content_), (true, [#sym.eq]))
#assert.eq(cast([= efg], native.content_), (true, [= efg]))
#assert.eq(cast(123, native.content_), (false, "expected content, string or symbol, found integer"))

#assert.eq(cast([abc], content), (true, [abc]))
#assert.eq(cast("abc", content), (true, [abc]))
#assert.eq(cast(sym.eq, content), (true, [#sym.eq]))
#assert.eq(cast([= efg], content), (true, [= efg]))
#assert.eq(cast(123, content), (false, "expected content, string or symbol, found integer"))
