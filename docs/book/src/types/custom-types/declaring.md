# Declaring a custom type

You can use `e.types.declare`. Make sure to specify a **unique prefix** to distinguish your type from others with the same name.

You should specify fields created with `e.field`. They can have an optional documentation with `doc`.

```rs
#import "@preview/elembic:X.X.X" as e: field, types

#let person = e.types.declare(
  "person",
  prefix: "@preview/my-package,v1",
  doc: "Relevant data for a person.",
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

Take a look at the following chapters, such as [Casts](./casts.md), to read about more options that can be used to customize your new type.
