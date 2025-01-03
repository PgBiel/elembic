#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ": types
#import "/src/types/types.typ": cast

// TODO: test custom types
// TODO: improve this
#assert.eq(cast(red, types.never), (false, "expected , found color"))
#assert.eq(cast(none, types.never), (false, "expected , found none"))
#assert.eq(cast(auto, types.never), (false, "expected , found auto"))
#assert.eq(cast("a", types.never), (false, "expected , found string"))
#assert.eq(cast([b], types.never), (false, "expected , found content"))
#assert.eq(cast(5, types.never), (false, "expected , found integer"))
#assert.eq(cast(5.0, types.never), (false, "expected , found float"))
#assert.eq(cast(5pt, types.never), (false, "expected , found length"))
#assert.eq(cast(5%, types.never), (false, "expected , found ratio"))
#assert.eq(cast(5pt + 5%, types.never), (false, "expected , found relative length"))
#assert.eq(cast(1pt + black, types.never), (false, "expected , found stroke"))
