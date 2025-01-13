#import "/test/unit/base.typ": empty
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
  prefix: ""
)

#let stock = e.element.declare(
  "stock",
  display: it => {},
  fields: (
    field("color", color, default: red),
    field("inner", content, default: [Hello!])
  ),
  prefix: ""
)

#assert.eq(cast([a *abc*], wock), (false, "expected element wock, got sequence"))
#assert.eq(cast([abc], wock), (false, "expected element wock, got text"))
#assert.eq(cast(wock(), wock), (true, wock()))
#assert.eq(cast(wock(color: black), wock), (true, wock(color: black)))
#assert.eq(cast(dock(), wock), (false, "expected element wock, got dock"))
#assert.eq(cast(wock(), dock), (false, "expected element dock, got wock"))

#assert.eq(cast(wock(), types.union(wock, dock)), (true, wock()))
#assert.eq(cast(dock(), types.union(wock, dock)), (true, dock()))
#assert.eq(cast([abc], types.union(wock, dock)), (false, "all typechecks for union failed\n  hint (element 'wock'): expected element wock, got text\n  hint (element 'dock'): expected element dock, got text"))
#assert.eq(cast(stock(), types.union(wock, dock)), (false, "all typechecks for union failed\n  hint (element 'wock'): expected element wock, got stock\n  hint (element 'dock'): expected element dock, got stock"))
