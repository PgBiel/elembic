#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ": types
#import types: native
#import "/src/types/types.typ": cast

// TODO: Test custom types
#assert.eq(cast((a: 5), native.dict_), (true, (a: 5)))
#assert.eq(cast((:), native.dict_), (true, (:)))
#assert.eq(cast((), native.dict_), (false, "expected dictionary, found array"))
