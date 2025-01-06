#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: element, field, types

#let (wock, wock-e) = element(
  "wock",
  display: it => {
    (it.run)(it)
  },
  fields: (
    field("run", function, required: true),
    field("align", alignment, default: left),
    field("align2", alignment, default: top),
  )
)

#let assert-fields(align, align2) = it => {
  assert.eq(it.align, align)
  assert.eq(it.align2, align2)
}

#wock(assert-fields(left, top))
#(wock-e.get)(assert-fields(left, top))

// Same axis: override
#show: e.set_(wock, align: end, align2: horizon)

#wock(assert-fields(end, horizon))
#(wock-e.get)(assert-fields(end, horizon))

// Different axes: sum
#show: e.set_(wock, align: bottom, align2: center)

#wock(assert-fields(end + bottom, center + horizon))
#(wock-e.get)(assert-fields(end + bottom, center + horizon))

// 2D: override existing 2D
#show: e.set_(wock, align: start + horizon, align2: right + top)

#wock(assert-fields(start + horizon, right + top))
#(wock-e.get)(assert-fields(start + horizon, right + top))

// 1D over 2D: override just that axis
#show: e.set_(wock, align: center, align2: bottom)

#wock(assert-fields(center + horizon, right + bottom))
#(wock-e.get)(assert-fields(center + horizon, right + bottom))

#show: e.reset(wock)

#wock(assert-fields(left, top))
#(wock-e.get)(assert-fields(left, top))

// 2D over 1D: full override
#show: e.set_(wock, align: right + top, align2: end + horizon)

#wock(assert-fields(right + top, end + horizon))
#(wock-e.get)(assert-fields(right + top, end + horizon))
