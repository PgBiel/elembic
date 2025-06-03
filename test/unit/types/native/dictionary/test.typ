#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ": types
#import types: native
#import "/src/types/types.typ": cast, validate, default

#let person = types.declare("person", prefix: "", fields: ())

#assert.eq(cast((a: 5), native.dict_), (true, (a: 5)))
#assert.eq(cast((:), native.dict_), (true, (:)))
#assert.eq(cast((), native.dict_), (false, "expected dictionary, found array"))
#assert.eq(cast(person(), native.dict_), (false, "expected dictionary, found person"))

#assert.eq(validate((a: 5)).first(), false)
#assert.eq(default(native.dict_), (true, (:)))

#assert.eq(native.dict_.fold, auto)
