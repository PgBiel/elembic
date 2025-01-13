# Scripting with Elements

Elements naturally contain **data**, such as **the fields specified** for them, as well as their **names, unique IDs (`eid`), counters,** and so on.

You can retrieve this data using the [dedicated data-extraction functions](../../reference/data.md) made available by Elembic. They are all based around [`e.data`](../../reference/data.md#edata), the main function which returns a data dictionary for lots of different types. Here are some of the most useful functions and tasks:

## Accessing fields

You can use `e.fields(instance)`. Note that the returned dictionary **will be incomplete if the element was just created**. It is only complete **in show rules**, when set rules and default fields have been resolved.

```rs
#show: e.set_(elem, field-c: 10)

#let instance = elem("abc", field-a: 5, field-b: 6)

// Field information incomplete: set rules not yet resolved
#assert.eq(e.fields(instance), (pos-field: "abc", field-a: 5, field-b: 6))

#show e.selector(elem): it => {
  // Field information is complete in show rules
  assert.eq(e.fields(it), (some-non-required-field: "default value", field-c: 10, pos-field: "abc", field-a: 5, field-b: 6))
}

#instance
```

## Accessing element ID and constructor

You can use `e.eid(instance)` or `e.eid(elem)` to obtain the corresponding unique element ID. This is always the same for types produced from the same element.

Similarly, `e.func(instance)` will give you the constructor used to create this instance. However, **note that the constructor may change between versions of a package without changing the element ID.** That is, `e.eid(a) == e.eid(b)` might hold (they come from the same element), but `e.func(a) == e.func(b)` might not. This leads us to the point below.

## Comparing elements

To compare two element instances `a` and `b`, the recommended procedure is

```rs
#let eq(a, b) = e.eid(a) == e.eid(b) and e.fields(a) == e.fields(b)
```

This ensures tiny changes to the element's declaration between two versions of a package, without changing the `eid`, won't cause the comparison to become `false` if you were to compare `a == b` directly, or `e.func(a) == e.func(b)` (which would also change).
