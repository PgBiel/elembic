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
    field("arr", array),
    field("typed-arr", types.array(int)),
  )
)

#let assert-fields(arr, typed-arr) = it => {
  assert.eq(it.arr, arr)
  assert.eq(it.typed-arr, typed-arr)
}

#wock(assert-fields((), ()))
#(wock-e.get)(assert-fields((), ()))

// Not much to say here
#show: e.set_(wock, arr: (), typed-arr: ())

#wock(assert-fields((), ()))
#(wock-e.get)(assert-fields((), ()))

// Sum
#show: e.set_(wock, arr: ("a", "b"), typed-arr: (1, 2, 3))

#wock(assert-fields(("a", "b"), (1, 2, 3)))
#(wock-e.get)(assert-fields(("a", "b"), (1, 2, 3)))

// Sum
#show: e.set_(wock, arr: ("a", "b"), typed-arr: (1, 2, 3))

#wock(assert-fields(("a", "b", "a", "b"), (1, 2, 3, 1, 2, 3)))
#(wock-e.get)(assert-fields(("a", "b", "a", "b"), (1, 2, 3, 1, 2, 3)))

// Sum
#show: e.set_(wock, arr: ("c",), typed-arr: ())

#wock(assert-fields(("a", "b", "a", "b", "c"), (1, 2, 3, 1, 2, 3)))
#(wock-e.get)(assert-fields(("a", "b", "a", "b", "c"), (1, 2, 3, 1, 2, 3)))
