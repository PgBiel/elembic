# Native types

Typst-native types, such as `int` and `str`, are internally represented by typeinfos of `"native"` type-kind, which can be obtained with `e.types.native.typeinfo(type)`. They can generally be specified directly on type positions (e.g. `types.union(int, float)`) without using that function, as Elembic will automatically convert them.

For fill-like fields, there is also `e.types.paint`, an alias for `types.union(color, gradient, tiling)`.

Of note, some native types, such as `float`, `stroke` and `content`, supporting casting, e.g. `str => content`, `int => float` and `length => stroke`. You can use [`e.types.exact`](./type-combinators.md) to disable casting for a type.

In addition, some native types support **folding**, a special behavior when specifying consecutive set rules over the same field with that type. The most notable one is `stroke`: specifying a stroke of `4pt` and then `black` generates `4pt + black`. There is also `array`: specifying an array `(2, 3)` and then `(4, 5)` on set rules generates `(2, 3, 4, 5)` at the end. Finally, `alignment` is worthy of mention: specifying `left + bottom`, `right` and then `top`, in that order, generates the final value of `right + top`.

You can disable folding with [`e.types.wrap`](./wrapping-types.md), setting `fold: none`.
