#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: field, types

#let (wock, wock-e) = e.element.declare(
  "wock",
  display: it => {
    (it.run)(it)
  },
  fields: (
    field("run", function, required: true),
    field("option", types.option(stroke)),
    field("smart", types.smart(stroke)),
    field("option-sum", types.option(array)),
    field("smart-sum", types.smart(array)),
  )
)

#let assert-fields(option, smart) = it => {
  assert.eq(it.option, option)
  assert.eq(it.smart, smart)
}

#let assert-sum-fields(option, smart) = it => {
  assert.eq(it.option-sum, option)
  assert.eq(it.smart-sum, smart)
}

#wock(assert-fields(none, auto))
#wock(assert-sum-fields(none, auto))
#(wock-e.get)(assert-sum-fields(none, auto))
#(wock-e.get)(assert-sum-fields(none, auto))

#show: e.set_(wock, option: 4pt, smart: 5pt)
#show: e.set_(wock, option-sum: (5,), smart-sum: (6,))

#wock(assert-fields(stroke(4pt), stroke(5pt)))
#wock(assert-sum-fields((5,), (6,)))
#(wock-e.get)(assert-fields(stroke(4pt), stroke(5pt)))
#(wock-e.get)(assert-sum-fields((5,), (6,)))

#show: e.set_(wock, option: black, smart: red)
#show: e.set_(wock, option-sum: (10, "a"), smart-sum: (90, "b"))

#wock(assert-fields(4pt + black, 5pt + red))
#wock(assert-sum-fields((5, 10, "a"), (6, 90, "b")))
#(wock-e.get)(assert-fields(4pt + black, 5pt + red))
#(wock-e.get)(assert-sum-fields((5, 10, "a"), (6, 90, "b")))

// Prefer explicit none / auto
#show: e.set_(wock, option: none, smart: auto)
#show: e.set_(wock, option-sum: none, smart-sum: auto)

#wock(assert-fields(none, auto))
#wock(assert-sum-fields(none, auto))
#(wock-e.get)(assert-fields(none, auto))
#(wock-e.get)(assert-sum-fields(none, auto))
