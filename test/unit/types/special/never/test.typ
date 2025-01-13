#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ": types
#import "/src/types/types.typ": cast

#let person = types.declare("person", prefix: "", fields: ())

#assert.eq(cast(red, types.never), (false, "type 'never' does not accept any values"))
#assert.eq(cast(none, types.never), (false, "type 'never' does not accept any values"))
#assert.eq(cast(auto, types.never), (false, "type 'never' does not accept any values"))
#assert.eq(cast("a", types.never), (false, "type 'never' does not accept any values"))
#assert.eq(cast([b], types.never), (false, "type 'never' does not accept any values"))
#assert.eq(cast(5, types.never), (false, "type 'never' does not accept any values"))
#assert.eq(cast(5.0, types.never), (false, "type 'never' does not accept any values"))
#assert.eq(cast(5pt, types.never), (false, "type 'never' does not accept any values"))
#assert.eq(cast(5%, types.never), (false, "type 'never' does not accept any values"))
#assert.eq(cast(5pt + 5%, types.never), (false, "type 'never' does not accept any values"))
#assert.eq(cast(1pt + black, types.never), (false, "type 'never' does not accept any values"))
#assert.eq(cast(person(), types.never), (false, "type 'never' does not accept any values"))
