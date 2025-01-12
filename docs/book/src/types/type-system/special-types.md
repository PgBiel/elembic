# Special types

There are some special types which don't correspond precisely to a single native or custom type, but have special behavior.

## `types.any`: Accepting any values

You can use `types.any` to ensure a field can receive any value (disables typechecking, folding, and any kind of special behavior).

## `types.never`: Accepts no values

This exists more for completeness, but this is a type with no input types, so it is impossible to cast to it.

## `types.literal`: Accepting only a single value of a type

You can use `types.literal("abc")` to only accept values equal to `"abc"`. As a shorthand, you can write just `"abc"` as the type for the field (unless it is a dictionary or function, as it'd then be ambiguous with other types).

To accept more than one literal, you can use [`types.union`](./type-combinators.md#typesunion-either-of-multiple-types), e.g. `types.union("abc", "def")` for either `"abc"` or `"def"`.

Note that casting is preserved: `types.literal(5.0)` will accept either the integer `5` or the float `5.0`. To accept **just** the float `5.0`, you can use `types.exact(types.literal(5.0))`, for example.

## `types.custom-type`: Accept custom types themselves

To accept any custom type as a value, you can use `types.custom-type`. However, note that, due to ambiguity when passing functions, the user will have to pass `e.data(the-custom-type-constructor)` instead of just the constructor itself for the cast to work / for the field to typecheck.

The same goes for literals: to receive one of multiple custom types, you'll have to use `union(literal(e.data(type1)), literal(e.data(type2)))`. Note that you have to use `literal` to disambiguate.

For native types, you can just use `type` as the type, and they will be accepted without any special ceremony by the user (they can pass `int` to a `type` field and it works). However, note that writing `literal(int)` explicitly, for example, is still required to only accept certain native types' constructors.

Native and custom elements are not currently supported on their own, although you may have some success in accepting `function`.
