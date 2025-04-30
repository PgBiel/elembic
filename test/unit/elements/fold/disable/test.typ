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
    field("also-fold-arr", array),
    field("fold-arr", array, folds: true),
    field("non-fold-arr", array, folds: false),
  ),
  prefix: ""
)

#let assert-fields(a1, a2, a3) = it => {
  assert.eq(it.also-fold-arr, a1)
  assert.eq(it.fold-arr, a2)
  assert.eq(it.non-fold-arr, a3)
}
#let assert-fields-all(a1, a2, a3) = {
  wock(assert-fields(a1, a2, a3))
  e.get(get => assert-fields(a1, a2, a3)(get(wock)))
}

#assert-fields-all((), (), ())

#show: e.set_(wock, also-fold-arr: (1,), fold-arr: (2,), non-fold-arr: (3,))

#assert-fields-all((1,), (2,), (3,))

#show: e.set_(wock, also-fold-arr: (4, 5), fold-arr: (6, 7), non-fold-arr: (8, 9))

#assert-fields-all((1, 4, 5), (2, 6, 7), (8, 9))
