#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: field, types

#let wock = e.element.declare(
  "wock",
  display: it => {
    (it.run)(it)
  },
  fields: (
    field("run", function, required: true),
    field("arr", array),
    field("typed-arr", types.array(int)),
  ),
  prefix: ""
)

#let assert-fields(arr, typed-arr) = it => {
  assert.eq(it.arr, arr)
  assert.eq(it.typed-arr, typed-arr)
}

#wock(assert-fields((), ()))
#e.get(get => assert-fields((), ())(get(wock)))

// Not much to say here
#show: e.set_(wock, arr: (), typed-arr: ())

#wock(assert-fields((), ()))
#e.get(get => assert-fields((), ())(get(wock)))

// Sum
#show: e.set_(wock, arr: ("a", "b"), typed-arr: (1, 2, 3))

#wock(assert-fields(("a", "b"), (1, 2, 3)))
#e.get(get => assert-fields(("a", "b"), (1, 2, 3))(get(wock)))

// Sum
#show: e.set_(wock, arr: ("a", "b"), typed-arr: (1, 2, 3))

#wock(assert-fields(("a", "b", "a", "b"), (1, 2, 3, 1, 2, 3)))
#e.get(get => assert-fields(("a", "b", "a", "b"), (1, 2, 3, 1, 2, 3))(get(wock)))

// Sum
#show: e.set_(wock, arr: ("c",), typed-arr: ())

#wock(assert-fields(("a", "b", "a", "b", "c"), (1, 2, 3, 1, 2, 3)))
#e.get(get => assert-fields(("a", "b", "a", "b", "c"), (1, 2, 3, 1, 2, 3))(get(wock)))
