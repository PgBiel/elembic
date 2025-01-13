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
#assert.eq(cast([abc *abc*], native-elem(text)), (false, "expected native element text, found sequence"))

#assert.eq(cast([a *abc*], native-elem(sequence)), (true, [a *abc*]))
#assert.eq(cast([abc], native-elem(sequence)), (false, "expected native element sequence, found text"))
#assert.eq(cast(wock(), native-elem(sequence)), (false, "expected native element sequence, found wock"))
#assert.eq(cast(wock(color: black), native-elem(sequence)), (false, "expected native element sequence, found wock"))

#assert.eq(cast([= efg], native-elem(heading)), (true, [= efg]))
#assert.eq(cast([efg], native-elem(heading)), (false, "expected native element heading, found text"))
#assert.eq(cast(wock(), native-elem(heading)), (false, "expected native element heading, found wock"))

#assert.eq(cast([abc *abc*], types.union(native-elem(sequence), native-elem(heading))), (true, [abc *abc*]))
#assert.eq(cast([= efg], types.union(native-elem(sequence), native-elem(heading))), (true, [= efg]))
#assert.eq(cast(wock(), types.union(native-elem(sequence), native-elem(heading))), (false, "expected native elements sequence or heading, found wock"))

#assert.eq(cast([abc *abc*], types.union(int, native-elem(sequence), native-elem(heading))), (true, [abc *abc*]))
#assert.eq(cast([= efg], types.union(int, native-elem(sequence), native-elem(heading))), (true, [= efg]))
#assert.eq(cast(5, types.union(int, native-elem(sequence), native-elem(heading))), (true, 5))
#assert.eq(cast(wock(), types.union(int, native-elem(sequence), native-elem(heading))), (false, "all typechecks for union failed\n  hint (native element 'sequence'): expected native element sequence, found wock\n  hint (native element 'heading'): expected native element heading, found wock"))

#assert.eq(cast([abc *abc*], types.union(stroke, native-elem(sequence), native-elem(heading))), (true, [abc *abc*]))
#assert.eq(cast([= efg], types.union(stroke, native-elem(sequence), native-elem(heading))), (true, [= efg]))
#assert.eq(cast(5pt, types.union(stroke, native-elem(sequence), native-elem(heading))), (true, stroke(5pt)))
#assert.eq(cast(wock(), types.union(stroke, native-elem(sequence), native-elem(heading))), (false, "all typechecks for union failed\n  hint (native element 'sequence'): expected native element sequence, found wock\n  hint (native element 'heading'): expected native element heading, found wock"))
