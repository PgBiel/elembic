# Elements as types

## Custom elements

Custom elements can be used directly as types (in fields etc.) to specify that you only want to accept a certain custom element as input. Note that you can use a [`union`](./type-combinators.md) to accept more than one custom element.

```rs
#import "@preview/elembic:X.X.X" as e

#let elem = e.element.declare(...)

#assert.eq(
  e.types.cast(
    elem(field: 5),
    elem
  ),
  (true, elem(field: 5))
)
```

## Native elements

You can use `e.types.native-elem(native element function)` to only accept instances of a particular native element.

For example, `e.types.native-elem(heading)` only accepts headings. (You can use a [`union`](./type-combinators.md) to accept more than one native element.)

```rs
#import "@preview/elembic:X.X.X" as e

#assert.eq(
  e.types.cast(
    [= hello!],
    e.types.native-elem(heading)
  ),
  (true, [= hello!])
)
```
