# Data retrieval functions

Functions used to retrieve data from custom elements, custom types, and their instances.

## Main functions

### `e.data`

This is the main function used to retrieve data from custom elements and custom types and their instances.
The other functions listed under "Helper functions" are convenient wrappers over this function to reduce typing.
It receives any input and returns a dictionary with one of the following values for the `data-kind` key:

1. `"element"`: dictionary with an element's relevant parameters and data generated it was declared.
  This is the data kind returned by `e.data(constructor)`. Importantly, it contains information such as
  `eid` for the element's unique ID (combining its `prefix` and `name`, used to distinguish it from elements
  with the same name), `sel` for the element's selector, `outer-sel` for the **outer selector** (used exclusively for
  show-set rules), `counter` for the element's counter, `func` for the element's constructor,
  `fields` for a parsed list of element fields, and more.

2. `"custom-type-data"`: conceptually similar to `"element"` but for custom types, including their data at declaration time.
  This is returned by `e.data(custom-type-constructor)`. Contains `tid` for the type's unique ID (combining `prefix` and `name`),
  as well as `typeinfo` for the type's typeinfo, `fields` with field information and `func` for the constructor.

3. `"element-instance"`: returned from `e.data(it)` in a show rule on custom elements, or when using
  `e.data(some-element(...))`. Relevant keys here include `eid` for the element ID (prefix + name),
  `func` for the element's constructor, as well as `fields`, dictionary containing the values specified for each field
  for this instance.

    It also contains `body`, which, in show rules, contains the value returned by the element's `display`
    function (the element's effective body), but note that the `body` shouldn't be placed directly; you should return `it` from
    the show rule to preserve the element. You usually will never need to use `body`. In addition, outside of show rules, it is
    rather meaningless and only contains the element itself.

    Note that, in show rules, the returned data will have `fields-known: true` which indicates that the final values of all fields,
    after synthesizing and set rules are applied, are known and stored in `fields`. Outside of show rules, however
    (e.g. on recently-constructed elements), the dictionary will have `fields-known: false` indicating that the
    dictionary of `fields` is incomplete and only contains the arguments initially passed to the constructor, as
    set rules and default values for missing fields haven't been applied yet.

    Note also that this data kind is also returned when applying to elements matched in a show rule on filtered selectors returned by
    [`e.select`](./elements.md#eselect).

4. `"type-instance"`: similar to `"element-instance"`, except `fields` are always known and complete
  since there are no show or set rules for custom types, so `e.data(my-type(...))` will always have
  a complete set of fields, as well as `tid` for the type's ID and `func` for its constructor.

5. `"incomplete-element-instance"`: this is only obtained when trying to `e.data(it)` on a show rule
  on an element's **outer selector** (obtained from [`e.selector(elem, outer: true)`](#eselector) or `e.data(elem).outer-sel`).
  The only relevant information it contains is the `eid` of the matched element. The rest is all unknown.

6. `"content"`: returned when some arbitrary `content` with native elements is received. In this case,
  `eid` will be `none`, but `func` will be set to `it.func()`, `fields` will be set to `it.fields()`
  and `body` will be set to `it` (the given parameter) itself.

7. `"unknown"`: something that wasn't content, an element, a custom type, or their instances was given.
  For example, an integer (no data to extract).

**Signature:**

```rs
#e.data(
  any
) -> dictionary
```

**Example:**

```rs
// Element
// (Equivalent to e.data(elem).sel)
#let sel = e.selector(elem)

// Instance
#show sel: it => {
  // (Equivalent to e.data(it).fields)
  let fields = e.fields(it)
  [Given color: #fields.color]

  [Counter value is #e.counter(elem).display("1.")]

  // (Equivalent to e.data(it).eid, ...)
  assert.eq(e.eid(it), e.eid(elem))
  // (Equivalent to e.data(it).func)
  assert.eq(e.func(it), elem)

  it
}

// Custom type data
#let name = e.data(my-type).name
#let typeinfo = e.data(my-type).typeinfo

// Custom type instance data
#assert.eq(e.func(my-type(...)), my-type)

// Equivalent to e.data(my-type(a: 5, b: 6)).fields
#assert.eq(e.fields(my-type(a: 5, b: 6)), (a: 5, b: 6))
```

### `e.repr`

This is used to obtain a debug representation of custom types.

In the future, this will support elements as well.

Also supports native types (just calls `repr()` for them).

**Signature:**

```rs
#e.repr(
  any
) -> str
```

**Example:**

```rs
// -> "person(name: \"John\", age: 40)"
#e.repr(person(name: "John", age: 40))
```

## Helper functions

Functions which simply wrap and return some specific `data`.

### `e.counter`

Helper function to obtain an element's associated counter.

This is a wrapper over `e.data(arg).counter`.

**Signature:**

```rs
#e.counter(
  element
) -> counter
```

**Example:**

```rs
#e.counter(elem).step()

#context e.counter(elem).display("1.")
```

### `e.ctx`

Helper function to obtain context from element instances within show rules and functions used by [`e.element.declare`](./elements.md#eelementdeclare).

This is only available if the element was declared with `contextual: true`, as it is otherwise expensive to store. When available, it is a dictionary containing `(get: function)`, where `get(elem)` returns the current default values of fields for `elem` considering set rules.

This is a wrapper over `e.data(arg).ctx`.

**Signature:**

```rs
#e.ctx(
  any
) -> dictionary | none
```

**Example:**

```rs
// For references to work
#show: e.prepare()

#let elem = e.element.declare(
  "elem",
  prefix: "@preview/my-package,v1",
  contextual: true,
  reference: (
    custom: it => [#(e.ctx(it).get)(other-elem).field]
  )
)

#elem(label: <a>)

// Will display the value of the other element's field
@a
```

### `e.eid`

Helper function to obtain an element's unique ID (modified combination of prefix + name).

Can also be used on element instances.

This is a wrapper over `e.data(arg).eid`.

**Signature:**

```rs
#e.eid(
  any
) -> str | none
```

**Example:**

### `e.fields`

Helper function to obtain an element or custom type instance's fields as a dictionary.

For elements, this will be incomplete outside of show rules. For custom types, it is always complete.

This is a wrapper over `e.data(arg).fields`.

**Signature:**

```rs
#e.fields(
  any
) -> dictionary | none
```

**Example:**

```rs
#assert.eq(e.fields(my-elem(a: 5)), (a: 5))
```

### `e.func`

Helper function to obtain the constructor used to create an element or custom type instance.

Can also be used on elements or custom types themselves.

This is a wrapper over `e.data(arg).func`.

**Signature:**

```rs
#e.func(
  any
) -> function | none
```

### `e.func-name`

Get the name of a content's constructor function as a string.

Returns `none` on invalid input.

**Signature:**

```rs
#e.func-name(
  content | custom element function
) -> function | none
```

**Example:**

```rs
assert.eq(func-name(my-elem()), "my-elem")
assert.eq(func-name([= abc]), "heading")
```

### `e.scope`

Helper function to obtain an element or custom type's associated scope.

This is a wrapper over `e.data(arg).scope`.

**Signature:**

```rs
#e.scope(
  any
) -> module | dictionary | none
```

**Example:**

```rs
#import e.scope(elem): sub-elem

#sub-elem(...)
```

### `e.selector`

Returns one of the element's selectors:

- By default, returns its main selector, used for show rules and querying. This is equivalent to `e.data(arg).sel`.
- With `outer: true`, returns a selector that can be used for show-set rules. This is equivalent to `e.data(arg).outer-sel`.
- With `outline: true`, returns a selector that can be used in `outline(target: /* here */)` for outlinable elements. This is equivalent to `e.data(arg).outline-sel`.

**Signature:**

```rs
#e.selector(
  element,
  outer: bool = false,
  outline: bool = false,
) -> label | selector | none
```

**Example:**

```rs
#show: e.show_(elem, strong)
#show e.selector(elem, outer: true): set par(justify: false)

#outline(target: e.selector(elem, outline: true))
```

### `e.tid`

Helper function to obtain the type ID of a custom type, or of an instance's custom type.

This is a wrapper over `e.data(arg).tid`.

**Signature:**

```rs
#e.tid(
  any
) -> str | none
```
