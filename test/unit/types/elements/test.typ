#import "/test/unit/base.typ": empty, unwrap
#show: empty

#import "/src/lib.typ" as e: types, field
#import types: native, native-elem
#import "/src/types/types.typ": cast

#let sequence = [].func()

#let wock = e.element.declare(
  "wock",
  display: it => {},
  fields: (
    field("color", color, default: red),
    field("inner", content, default: [Hello!])
  ),
  prefix: ""
)

#let dock = e.element.declare(
  "dock",
  display: it => {},
  fields: (
    field("color", color, default: red),
    field("inner", content, default: [Hello!])
  ),
  labelable: true,
  prefix: ""
)

#let stock = e.element.declare(
  "stock",
  display: it => box[],
  fields: (
    field("color", color, default: red),
    field("inner", content, default: [Hello!])
  ),
  prefix: ""
)

#assert.eq(cast([a *abc*], wock), (false, "expected element wock, found sequence"))
#assert.eq(cast([abc], wock), (false, "expected element wock, found text"))
#assert.eq(cast(wock(), wock), (true, wock()))
#assert.eq(cast(wock(color: black), wock), (true, wock(color: black)))
#assert.eq(cast(dock(), wock), (false, "expected element wock, found dock"))
#assert.eq(cast(wock(), dock), (false, "expected element dock, found wock"))

#assert.eq(cast(wock(), types.union(wock, dock)), (true, wock()))
#assert.eq(cast(dock(), types.union(wock, dock)), (true, dock()))
#assert.eq(cast([abc], types.union(wock, dock)), (false, "expected elements wock or dock, found text"))
#assert.eq(cast(stock(), types.union(wock, dock)), (false, "expected elements wock or dock, found stock"))

#assert.eq(cast(wock(), types.union(types.native-elem(text), wock, dock)), (true, wock()))
#assert.eq(cast(dock(), types.union(types.native-elem(text), wock, dock)), (true, dock()))
#assert.eq(cast([abc], types.union(types.native-elem(text), wock, dock)), (true, [abc]))
#assert.eq(cast([= abc], types.union(types.native-elem(text), wock, dock)), (false, "expected elements text (native), wock or dock, found heading"))
#assert.eq(cast(stock(), types.union(types.native-elem(text), wock, dock)), (false, "expected elements text (native), wock or dock, found stock"))

#assert.eq(cast(wock(), types.union(wock, dock, 5)), (true, wock()))
#assert.eq(cast(dock(), types.union(wock, dock, 5)), (true, dock()))
#assert.eq(cast(5, types.union(wock, dock, 5)), (true, 5))
#assert.eq(cast([abc], types.union(wock, dock, 5)), (false, "all typechecks for union failed\n  hint (element 'wock'): expected element wock, found text\n  hint (element 'dock'): expected element dock, found text"))
#assert.eq(cast(stock(), types.union(wock, dock, 5)), (false, "all typechecks for union failed\n  hint (element 'wock'): expected element wock, found stock\n  hint (element 'dock'): expected element dock, found stock"))

#assert.eq(cast(wock(), types.union(int, wock, dock)), (true, wock()))
#assert.eq(cast(dock(), types.union(int, wock, dock)), (true, dock()))
#assert.eq(cast(5, types.union(int, wock, dock)), (true, 5))
#assert.eq(cast([abc], types.union(int, wock, dock)), (false, "all typechecks for union failed\n  hint (element 'wock'): expected element wock, found text\n  hint (element 'dock'): expected element dock, found text"))
#assert.eq(cast(stock(), types.union(int, wock, dock)), (false, "all typechecks for union failed\n  hint (element 'wock'): expected element wock, found stock\n  hint (element 'dock'): expected element dock, found stock"))

#assert.eq(cast(wock(), types.union(stroke, wock, dock)), (true, wock()))
#assert.eq(cast(dock(), types.union(stroke, wock, dock)), (true, dock()))
#assert.eq(cast(5pt, types.union(stroke, wock, dock)), (true, stroke(5pt)))
#assert.eq(cast([abc], types.union(stroke, wock, dock)), (false, "all typechecks for union failed\n  hint (element 'wock'): expected element wock, found text\n  hint (element 'dock'): expected element dock, found text"))
#assert.eq(cast(stock(), types.union(stroke, wock, dock)), (false, "all typechecks for union failed\n  hint (element 'wock'): expected element wock, found stock\n  hint (element 'dock'): expected element dock, found stock"))

#assert.eq(cast(wock(), types.literal(wock())), (true, wock()))
#assert.eq(cast(wock(), types.literal(wock(color: black))), (false, "given value wasn't equal to literal 'wock(color: luma(0%))'"))
#assert.eq(cast(wock(color: black), types.literal(wock(color: black))), (true, wock(color: black)))

#assert.eq(types.option(types.typeof(wock())), types.option(wock))
#assert.eq(types.option(types.typeof(dock())), types.option(dock))

#show e.selector(stock): it => {
  assert.eq(cast(it, stock), (true, it))
  assert.eq(cast(it, types.union(stock, wock)), (true, it))
  assert.eq(e.fields(it), e.fields(stock(color: red, inner: [Hello!])))
  assert.eq(types.typeof(it).data.eid, e.eid(stock))
}

#let pretty-much-wock = e.element.declare(
  "wock",
  display: it => "this is the only thing that differs",
  fields: (
    field("color", color, default: red),
    field("inner", content, default: [Hello!])
  ),
  prefix: ""
)

#assert.eq(cast(pretty-much-wock(), wock), (true, pretty-much-wock()))
#assert.eq(cast(pretty-much-wock(), types.literal(wock())), (true, pretty-much-wock()))
#assert.eq(cast(pretty-much-wock(), types.union(content, e.types.literal(wock()), e.types.literal(wock(color: blue)))), (true, pretty-much-wock()))
#assert.eq(cast(pretty-much-wock(), types.union(e.types.literal(wock()), e.types.literal(wock(color: blue)))), (true, pretty-much-wock()))

#assert.eq(types.typeof(wock()).data.eid, e.eid(wock))

#stock()
