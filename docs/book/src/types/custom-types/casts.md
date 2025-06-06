# Casts

You can add casts from native types (or any types supported by the type system, such as [literals](../type-system/special-types.md#typesliteral-accepting-only-a-single-value-of-a-type)) to your custom type, allowing fields receiving your type to also accept the casted-from types.

## Dictionary cast

The simplest cast, allows casting dictionaries to your type when they have the correct structure. In summary, the dictionary's keys must correspond to **named fields** in your type. To use its default implementation, simply add `casts: ((from: dictionary),)` and the rest is sorted out. (You can add other casts, as explained below, by adding more casts to that list.)

Fails if there are required positional fields.

For example:

```rs
#import "@preview/elembic:X.X.X" as e: field, types

#let person = e.types.declare(
  "person",
  prefix: "@preview/my-package,v1",
  fields: (
    // All fields named, one required
    field("name", str, doc: "Person's name", required: true, named: true),
    field("age", int, doc: "Person's age", default: 40),
    field("preference", types.any, doc: "Anything the person likes", default: none)
  ),
  casts: ((from: dictionary),) // <-- note the comma!
)

#assert.eq(
  types.cast((name: "Johnson", age: 20, preference: "ice cream"), person),
  // Same as using the default constructor
  (true, person(name: "Johnson", age: 20, preference: "ice cream"))
)
```

## Custom casts

Additional casts are given by the `casts: (cast1, cast2, ...)` parameter. Each cast takes at least `(from: typename, with: constructor => value => constructor(...))`, where `value` was already casted to `typename` beforehand (e.g. if `typename` is float, then `value` will always have type `float`, even if the user passes an integer). It may optionally take `check: value => bool` as well to only accept that `typename` if `check(value)` is `true`.

In the future, automatic casting from dictionaries will be supported (although it can already be manually implemented).

```admonish note
**Casts are ordered.** This means that specifying a cast from `int` and then `float` is different from specifying a cast from `float` followed by `int`, for example.

This is relevant when two or more types in the union can accept the same native type as input, with differing checks or casts. In the case of `int` and `float`, the integer `5` will trigger the cast from `int` as you'd expect if the `int` cast comes first, but will converted to `5.0` before triggering the cast from `float` if the `float` cast is specified first. (Of course, a float such as `4.0` will trigger the cast from `float` in both cases, since it isn't accepted by `int`).
```

These principles are made evident in the example below:

```rs
#import "@preview/elembic:X.X.X" as e: field, types

#let person = e.types.declare(
  "person",
  prefix: "@preview/my-package,v1",
  fields: (
    field("name", str, doc: "Person's name", required: true),
    field("age", int, doc: "Person's age", default: 40),
    field("preference", types.any, doc: "Anything the person likes", default: none)
  ),
  casts: (
    (from: "Johnson", with: person => name => person(name, age: 45)),
    (from: str, check: name => name.starts-with("Alfred "), with: person => name => person(name, age: 30)),
    (from: str, with: person => name => person(name)),
  )
)

// Manually invoke typechecking and cast
// Notice how the first succeeding cast is always made
#assert.eq(
  types.cast("Johnson", person),
  (true, person("Johnson", age: 45))
)
#assert.eq(
  types.cast("Alfred Notexistent", person),
  (true, person("Alfred Notexistent", age: 30))
)
#assert.eq(
  types.cast("abc", person),
  (true, person("abc", age: 40))
)
```

## Wait, that sounds a lot like a [`union`](../type-system/type-combinators.md#typesunion-either-of-multiple-types)!

That's right: most of the casting generation code is shared with `union`! The `union` code also contains optimizations for simple types, which we take advantage of here.

The main difference here is that these casts become **part of the custom type itself.** This means that they will always be there when using this custom type as the type of a field.

However, it's possible to override this behavior: users of the type **can disable the casts** by wrapping the custom type in [the `types.exact` combinator](../type-system/type-combinators.md#typesexact-disable-casting-for-a-type).
