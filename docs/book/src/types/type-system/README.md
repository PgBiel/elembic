# Type system

In order to ensure type-safety for your element's fields, Elembic has its own **type system** which is worth being aware about. It not only allows you to customize how types are checked for each field, but even **create your own, brand new types**, much like you can create elements!

## Purpose

Types are an important guarantee that **users of your elements will specify the correct types** for each field. However, note that **Elembic's type-checking utilities can be used anywhere,** not only for elements!

Note that, for elements, when a field is created with `field`, it is necessary to specify a field name and a type, or `any` to accept any type:

```rs
#let elem = e.element.declare(
  // ...
  fields: (
    field("amount", int /* <--- here! */, required: true),
    field("anything", e.types.any, default: none)  // <--- anything goes!
  )
)

#elem(5)  // OK!
// #elem("abc")  // Error: "expected integer, found string"
#elem(5, anything: "string")  // OK!
#elem(5, anything: 20pt)  // OK!
```

Native types (such as `int`) or `any` are not the only types which can be specified for element fields. In general, anything that is representable in the **typeinfo format**, described below, can be used as a field type.

## Typeinfo

"Typeinfo" is the structure (represented as a Typst dictionary) that describes, in each field:

1. `type-kind`: The **kind** of a type - `"native"` for native types, `"custom"` for custom types, and other values for other special types (such as `"any"`, `"never"`, `"union"` for the output of `types.union`, `"wrapped"` as the output of `types.wrap`, `"collection"` for `types.array`, and so on);
2. `name`: the **name** of a type;
3. `input`: which **basic types** may **be cast to it** (e.g.: integer or string). This uses the [**type ID format** for custom types](./helper-functions.md), obtained with `types.typeid(value)`, of the form `(tid: ..., name: ...)`. For native types, the output of `type(value)` is used;
4. `output`: which **basic types** the input may **be cast to** (e.g.: just string). This uses the same format as `input`;
5. `check`: an extra check (function `input value => true / false`) that tells **whether a basic input type may be cast** to this type, or `none` for no such check;
6. `cast`: an optional function to cast an input value that passed the check to an output value (function `input value => output value`). Must always succeed, or panic. If `none`, the input type is kept unchanged as an output after casting to this type. An integer would remain an integer without a cast, for example (which may be the intention).
7. `error`: an optional function that is called when the check fails (`input value => string`), indicating why the check may have failed.
8. `default`: the default value for the type when using it for a field. This is used if the field isn't required and the element author didn't specify a default. This must either be an empty array `()` for no default, or a singleton array `(value,)` (**note the trailing comma**) to specify a default.
9. `fold`: an optional function `(outer output value, inner output value) => new output value` to indicate how to combine two consecutive values of this type, where `inner` is more prioritized over `outer`. For example, for the `stroke` type, one would have `(5pt, black) => 5pt + black`, but `(5pt + black, red) => 5pt + red` since `red` is the inner value in that case. If this is `none`, the inner value always completely overrides the outer value (the default behavior). This is used in set rules: they don't completely override the value of the field if its type has `fold`.
    - Note that `fold` may also be `auto` to mean `(a, b) => a + b`, for performance reasons.
10. `data`: some extra data giving an insight into how this typeinfo was generated. What this is varies per kind of typeinfo. For example, for native types such as `int`, this will be the native type itself.
