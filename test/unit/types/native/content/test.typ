#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ": types
#import types: native
#import "/src/types/types.typ": cast

#assert.eq(cast([abc], native.content_), (true, [abc]))
#assert.eq(cast("abc", native.content_), (true, [abc]))
#assert.eq(cast([= efg], native.content_), (true, [= efg]))
#assert.eq(cast(123, native.content_), (false, "expected content or string, found integer"))
