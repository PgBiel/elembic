# Type combinators

Here's some information about some special types combining other types.

## `types.union`: Either of multiple types

You can use `types.union(int, str)` to indicate that a field depends on either an integer or a string.

As special aliases, there are `types.option(typ)` and `types.smart(typ)` for `types.union(none, typ)` and `types.union(auto, typ)` respectively.

At the moment, general unions (so, other than `option` and `smart`) completely disable folding, e.g. `types.union(int, stroke)` will disable folding between `4pt` and `black`, with `black` overriding the previous value. This could change in the future for some cases, but it cannot be kept in all cases since fold operates on `output` types, of which we have already lost the original type information, so it is generally ambiguous on which fold function to use.

## `types.exact`: Disable casting for a type

You can use `types.exact(typ)` to ensure there is no casting involved for this type. For example, `types.exact(float)` ensures integers won't cast to floats (they are normally accepted). Also, `types.exact(stroke)` ensures only `stroke(5pt)` can be passed to a field with that type, not `5pt` itself. Finally, `types.exact(my-custom-type)`, where `my-custom-type` has custom casts from existing types, disables those casts, allowing only an instance of `my-custom-type` itself to be used for a field with that type.

## `types.array`: Array of a type

You can use `types.array(typ)` to accept arrays of elements of the same type.
