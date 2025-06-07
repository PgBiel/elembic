# Specifying fields

The [previous section on declaring custom elements](./declaring.md) provided examples on how to declare fields to specify **user-configurable data for your element**. Here, we will go more in depth.

When specifying an element's fields, you should use the `field` function for each field, which supports a number of options.

## Type

The field's type is a fundamental piece of information. Elembic uses this to **automatically check for invalid input** by the user when constructing your element. The [type system](../../types/type-system) chapter has more information on what you can do with types.

You can use `e.types.any` to disable typechecking for a single field, or `typechecks: false` on the element to disable it for all fields.

```admonish tip
To check for a custom data structure (usually dictionary-based) in a field, consider creating your own [custom type](../../types/custom-types).
```

```admonish tip title="Changing types"

To change existing types slightly, check out [type wrapping with `e.types.wrap`](../../types/type-system/wrapping-types.md). This can be used to:

1. Add custom [folding](../styling/set-rules.md#folding) behavior to your field (override `fold` with a function);

2. Add a custom check to your field with e.g. `e.types.wrap(int, check: prev => i => i > 0)` instead of just `int` to only accept positive integers
    - Here `prev` can be ignored since it is `none` (`int` has no checks by default), but make sure to invoke it as needed.

3. Add a custom cast with `cast`.
```

## Metadata

Several options may be specified to attach metadata to fields. This metadata can be retrieved later with `e.fields(element).all-fields.FIELD-NAME`, so it is useful for docs generators, and otherwise has no practical effects:

1. `doc` (string): Field documentation.
2. `internal` (bool): If set to `true`, should be hidden in the documentation.
3. `meta` (dictionary): Arbitrary key/value pairs to attach to this field.

## Synthesizing fields

Some elements will have conveniently **auto-generated fields**, which are created after set rules are applied, but **before show rules.** To do this, there are two steps:

1. **List those fields as "synthesized" fields in the `fields` array.** To do this, just specify `e.field(..., synthesized: true)`.
    - Such fields cannot be manually specified by users, however they can be matched on by [filters.](../filters)

2. **Create a synthesis step for your element with `synthesize: fields => updated fields`.** Here, you can, for example, access Typst context, as well as use `e.counter(it)` to read the counter, and so on.

Here's a bit of an artificial example just to showcase the functionality: we combine a `stroke` field and a `body` field to generate an `applied` field, which is what is effectively displayed.

```rs
#import "@preview/elembic:X.X.X" as e: field, types

#let frame = e.element.declare(
  "frame",
  prefix: "@preview/my-package,v1",
  doc: "Displays its body in a frame.",
  display: it => it.applied,
  fields: (
    field("body", content, doc: "Body to display.", required: true),
    field("stroke", types.option(stroke), doc: "Stroke to add around the body."),
    field("applied", content, doc: "Frame applied to the body.", synthesized: true)
  ),
  synthesize: it => {
    it.applied = block(stroke: it.stroke, it.body)
    it
  }
)

#show: e.show_(frame, it => {
  let applied = e.fields(it).applied
  [The applied field was #raw(repr(applied)), as seen below:]
  it
})

#frame(stroke: red + 2pt)[abc]
```

!["The applied field was `block(stroke: 2pt + rgb("#ff4136"), body: [abc])`, as seen below:", followed by "abc" inside a box with red stroke](https://github.com/user-attachments/assets/5de445b9-5a28-4200-808f-e13d927d0472)

## All field options

`e.field` has the following arguments:

1. `name` (string, positional): the field name, by which it will be accessed in the dictionary returned by `e.fields(element instance)`.
2. `type_` (type / typeinfo, positional): the field's type, defines how to check whether user input to this field is valid (read more about types in [the Type system chapter](../../types/type-system.md)).
3. `doc` (string, named, optional): documentation for the field. **It is recommended to always set this.** The documentation (and other field metadata) can later be retrieved by accessing `e.data(elem).all-fields`, and can be used to auto-generate documentation, for example.
4. `required` (boolean, named, optional): whether this field is **required** (and thus can only be specified at the constructor, as it will have no default). This defaults to **false**.
5. `named` (boolean or `auto`, named, optional): whether this field should be specified **positionally** (`false` - that is, without its name) to the constructor and set rules, or **named** (`true` - the user must specify the field by name). By default, this is `auto`, which is `true` for required fields and `false` for optional fields (but you can have required named fields and optional positional fields by changing both parameters accordingly).
6. `default` (any, named, optional): the default value for this field if `required` is `false`. If this argument is omitted, the type's default is used (as explained below), or otherwise the field has no default (only possible if it is required). If a value is specified, that value becomes the field's default value (**it will be cast to the given field type**). It was done this way so you can also specify `none` as a default (which is common).

    Note that many types have their own default values, so you can usually omit `default` entirely, as the field will then just use that type's default. For example, if the type is `int`, then `default` will automatically be set to `0` for such optional fields.
    If the type doesn't have its own default and the field is optional, you must specify your own default.

7. `synthesized` (boolean, named, optional): this is used to indicate that this is an **automatically generated field** during **synthesis**. A synthesized field **cannot be manually set by the user** - be it through the constructor or through set rules. However, **it can be matched on** in filters, such as for selecting elements through [`e.select`](../../misc/reference/elements.md#eselect). For example, if you have a synthesized field called `level`, a user can match on `elem.with(level: 10)`.

    Therefore, **you should always list automatically generated fields as synthesized fields.** Elembic won't forbid you from adding "hidden fields" during synthesis, but then they will be seen as inexistent by the framework, so it is recommended to always list auto-generated fields as synthesized fields, with proper documentation for them.

    Read more about synthesis below.

8. `folds` (boolean, named, optional): if `false`, set rules and arguments changing this field will always completely override the previous value instead of joining. This only has an effect on foldable types, such as arrays, dictionaries and strokes. For other types, that is already what happens: no joining.

9. `internal` (boolean, named, optional): if `true`, indicates this field should be hidden from documentation. Has no effect on `elembic` itself and is only meant to be read by external tools.

10. `meta` (dictionary, named, optional): an optional dictionary with arbitrary keys and values to be read by external tools, such as documentation generators.
