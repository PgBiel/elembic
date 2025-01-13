#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: types, field
#import types: native, native-elem
#import "/src/types/types.typ": cast

#let sequence = [].func()

#let wock = e.element.declare(
  "wock",
  display: it => {
    assert.eq(it.color, red)
    assert.eq(it.inner, [Hello!])
  },
  fields: (
    field("color", color, default: red),
    field("inner", content, default: [Hello!])
  ),
  prefix: ""
)

#assert.eq(cast([abc], native-elem(text)), (true, [abc]))
#assert.eq(cast([abc *abc*], native-elem(text)), (false, "expected native element text, got sequence"))

#assert.eq(cast([a *abc*], native-elem(sequence)), (true, [a *abc*]))
#assert.eq(cast([abc], native-elem(sequence)), (false, "expected native element sequence, got text"))
#assert.eq(cast(wock(), native-elem(sequence)), (false, "expected native element sequence, got wock"))
#assert.eq(cast(wock(color: black), native-elem(sequence)), (false, "expected native element sequence, got wock"))

#assert.eq(cast([= efg], native-elem(heading)), (true, [= efg]))
#assert.eq(cast([efg], native-elem(heading)), (false, "expected native element heading, got text"))
#assert.eq(cast(wock(), native-elem(heading)), (false, "expected native element heading, got wock"))

#assert.eq(cast([abc], types.union(native-elem(sequence), native-elem(heading))), (true, [abc]))
#assert.eq(cast([= efg], types.union(native-elem(sequence), native-elem(heading))), (true, [= efg]))
#assert.eq(cast(wock(), types.union(native-elem(sequence), native-elem(heading))), (false, "all typechecks for union failed\n  hint (native element 'sequence'): expected native element sequence, got text\n  hint (native element 'heading'): expected native element heading, got text"))
