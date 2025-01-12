# Declaring a custom type

You can use `e.types.declare`. Make sure to specify a **unique prefix** to distinguish your type from others with the same name.

You should specify fields created with `e.field`. They can have an optional documentation with `doc`.

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
)

#assert.eq(
  e.repr(person("John", age: 50, preference: "soup")),
  "person(age: 50, preference: \"soup\", name: \"John\")"
)
```

Your type, in this case `person`, can then be used as the type of an element's field, or used with [`e.types.cast`](../type-system/helper-functions.md) in other scenarios.

## Casts

You can add casts from native types (or any types supported by the type system, such as [literals](../type-system/special-types.md#typesliteral-accepting-only-a-single-value-of-a-type)) to your type, allowing fields receiving your type to also accept the casted-from types.

This is done through the `casts: (cast1, cast2, ...)` parameter. Each cast takes at least `(from: typename, with: constructor => value => constructor(...))`, where `value` was already casted to `typename` beforehand (e.g. if `typename` is float, then `value` will always have type `float`, even if the user passes an integer). It may optionally take `check: value => bool` as well to only accept that `typename` if `check(value)` is `true`.

In the future, automatic casting from dictionaries will be supported.

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

## Folding

If all of your fields may be omitted (for example), or if you just generally want to be able to combine fields, you could consider adding **folding** to your custom type with `fold: auto`, which will combine each field individually using their own fold methods. You can also use `fold: default constructor => (outer, inner) => combine inner with outer, giving priority to inner` for full customization.

## Custom constructor and argument parsing

Much like elements, you can use `construct: default-constructor => (..args) => value` to override the default constructor for your custom type. **You should use `construct:` rather than create a wrapper function** to ensure that data retrieval functions, such as `e.data(func)`, still work.

You can use `parse-args: default-constructor => (args, include-required: true) => dictionary with fields` to override the built-in argument parser to the constructor (instead of overriding the entire constructor). `include-required` is always true and is simply a remnant from elements' own argument parses (which share code with the one used for custom types).
