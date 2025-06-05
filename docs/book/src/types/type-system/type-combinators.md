# Type combinators

Here's some information about some special types combining other types.

## `types.union`: Either of multiple types

You can use `types.union(int, str)` to indicate that a field depends on either an integer or a string.

As special aliases, there are `types.option(typ)` and `types.smart(typ)` for `types.union(none, typ)` and `types.union(auto, typ)` respectively.

```admonish note
**Unions are ordered.** This means that `types.union(int, float) != types.union(float, int)`.

This is relevant when two or more types in the union can accept the same native type, with differing checks or casts. In the case of `int` and `float`, the integer `5` will remain the integer `5` when casting to `types.union(int, float)`, but will be casted to the float `5.0` when casted to `types.union(float, int)`. (Of course, a float such as `4.0` will remain a float in both cases, since it isn't accepted by `int`).
```

### Folding in unions

At the moment, general unions (so, other than `option` and `smart`) completely disable folding, e.g. `types.union(int, stroke)` will disable folding between `4pt` and `black`, with `black` overriding the previous value. This could change in the future for some cases, but it cannot be kept in all cases since fold operates on `output` types, of which we have already lost the original type information, so it is generally ambiguous on which fold function to use.

However, `option` and `smart` are exceptions: they will fold the non-`none` and non-`auto` type (respectively) if it can be folded. However, an explicit `none` or `auto` always takes priority. For example, with `types.option(stroke)`, when setting `none` followed by `4pt`, the result is `stroke(4pt)`; when setting `4pt` followed by `black`, the result is `4pt + black`; when setting `black` followed by `none`, the result is `none`. (Same would happen with `types.smart(stroke)` and `auto`.)

## `types.exact`: Disable casting for a type

You can use `types.exact(typ)` to ensure there is no casting involved for this type. For example, `types.exact(float)` ensures integers won't cast to floats (they are normally accepted). Also, `types.exact(stroke)` ensures only `stroke(5pt)` can be passed to a field with that type, not `5pt` itself. Finally, `types.exact(my-custom-type)`, where `my-custom-type` has custom casts from existing types, disables those casts, allowing only an instance of `my-custom-type` itself to be used for a field with that type.

## `types.array`: Array of a type

You can use `types.array(typ)` to accept arrays of elements of the same type.

## `types.dict`: Dictionary with values of a type

You can use `types.dict(typ)` to accept dictionaries with values of the same type. (Note that dictionary keys are all strings.)

For example, `(a: 5, b: 6)` is a valid `dict(int)`, but not a valid `dict(str)`.
