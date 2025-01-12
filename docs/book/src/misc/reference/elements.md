# Elements

At the moment, all of the functions in this module are exported exclusively at the top-level of the package, other than `declare` which must be used as `e.element.declare`.

## Declaration

### `e.element.declare`

Creates a new element, returning its constructor. Read the ["Creating custom elements" chapter](../../elements/creating) for more information.

**Signature:**

```rs
#e.declare(
  name,
  prefix: str,
  display: function,
  fields: array,
  parse-args: auto | function(arguments, include-required: bool) -> dictionary = auto,
  typecheck: bool = true,
  allow-unknown-fields: bool = false,
  template: none | function(displayed element) -> content = none,
  prepare: none | function(elem, document) -> content = none,
  construct: none | function(constructor) -> function(..args) -> content = none,
  scope: none | dictionary | module = none,
  count: none | function(counter) -> content | function(counter) -> function(fields) -> content = counter.step,
  labelable: bool = true,
  reference: none | (supplement: none | content | function(fields) -> content, numbering: none | function(fields) -> str | function, custom: none | function(fields) -> content) = none,
  outline: none | auto | (caption: content) = none,
  synthesize: none | function(fields) -> synthesized fields,
  contextual: bool = false,
) = {
```

**Arguments:**

- `name`: The element's name.
- `prefix`: The element's prefix, used to distinguish it from elements with the same name. This is usually your package's name alongside a (major) version.
- `display`: Function `fields => content` to display the element.
- `fields`: Array with this element's fields. They must be created with `e.field(...)`.
- `parse-args`: Optional override for the built-in argument parser (or `auto` to keep as is). Must be in the form `function(args, include-required: bool) => dictionary`, where `include-required: true` means required fields are enforced (constructor), while `include-required: false` means they are forbidden (set rules).
- `typecheck`: Set to `false` to disable field typechecking.
- `allow-unknown-fields`: Set to `true` to allow users to specify unknown fields to your element. They are not typechecked and are simply forwarded to the element's fields by the argument parser.
- `template`: Optional function `displayed element => content` to define overridable default set rules for your elements, such as paragraph settings. Users can override these settings with show-set rules on elements.
- `prepare`: Optional function `(element, document) => content` to define show and set rules that should be applied to the whole document for your element to properly function.
- `construct`: Optional function that overrides the default element constructor, returning arbitrary content. This should be used over manually wrapping the returned constructor as it ensures set rules and data extraction from the constructor still work.
- `scope`: Optional scope with associated data for your element. This could be a module with constructors for associated elements, for instance. This value can be accessed with `e.scope(elem)`, e.g. `#import e.scope(elem): sub-elem`.
- `count`: Optional function `counter => (content | function fields => content)` which inserts a counter step before the element. Ensures the element's display function has updated context to get the latest counter value (after the step / update) with `e.counter(it).get()`. Defaults to `counter.step` to step the counter once before each element placed.
- `labelable`: Defaults to `true` and allows specifying `#element(label: <abc>)`, which not only ensures show rules on that label work and have access to the element's final fields, but also allows referring to that element with `@abc` if the `reference` option is configured and `#show: e.prepare()` is applied. When `false`, the element may have a field named `label` instead, but it won't have these effects.
- `reference`: When not `none`, allows referring to the new element with Typst's built-in `@ref` syntax. Requires the user to execute `#show: e.prepare()` at the top of their document (it is part of the default rules, so `prepare` needs no arguments there). Specify either a `supplement` and `numbering` for references looking like "Name 2", and/or `custom` to show some fully customized content for the reference instead.
- `outline`: When not `none`, allows creating an outline for the element's appearances with `#outline(target: e.selector(elem, outline: true))`. When set to `auto`, the entries will display "Name 2" based on reference information. When a `caption` is specified via a dictionary, it will display as "Name 2: caption", unless supplement and numbering for reference are both none, in which case it will only display `caption`.
- `synthesize`: Can be set to a function to override final values of fields, or create new fields based on final values of fields, before the first show rule. When computing new fields based on other fields, please specify those new fields in the fields array with `synthesized: true`. This forbids the user from specifying them manually, but allows them to filter based on that field.
- `contextual`: When set to `true`, functions `fields => something` for other options, including `display`, will be able to access the current values of set rules with `(e.ctx(fields).get)(other-elem)`. In addition, an additional context block is created, so that you may access the correct values for `native-elem.field` in the context. In practice, this is a bit expensive, and so this option shouldn't be enabled unless you need precisely `bibliography.title`, or you really need to get set rule information from other elements within functions such as `synthesize` or `display`.

**Example:**

```rs
#import "@preview/elembic:X.X.X" as e: field

// For references to apply
#show: e.prepare()

#let elem = e.element.declare(
  "elem",
  prefix: "@preview/my-package,v1",
  display: it => {
    [== #it.title]
    block(fill: it.fill)[#it.inner]
  },
  fields: (
    field("fill", e.types.option(e.types.paint)),
    field("inner", content, default: [Hello!]),
    field("title", content, default: [Hello!]),
  ),
  reference: (
    supplement: [Elem],
    numbering: "1"
  ),
  outline: (caption: it => it.title),
)

#outline(target: e.selector(elem, outline: true))

#elem()
#elem(title: [abc], label: <abc>)
@abc
```

## Rules and styles

### `e.apply`

Apply multiple rules (set rules, etc.) at once.

These rules do not count towards the "set rule limit" observed in [Limitations](../../about/limitations.md); `apply` itself will always count as a single rule regardless of the amount of rules inside it (be it 5, 50, or 500). Therefore, **it is recommended to group rules together under `apply` whenever possible.**

Note that Elembic will automatically wrap consecutive rules (only whitespace or native set/show rules inbetween) into a single `apply`, bringing the same benefit.

**Signature:**

```rs
#e.apply(
  ..rules: e.apply(...) | e.set_(...) | e.revoke(...) | e.reset(...),
  mode: auto | style-modes.normal | style-modes.leaky | style-modes.stateful = auto
)
```

**Example:**

```rs
#show: e.apply(
  set_(superbox, fill: red),
  set_(superbox, width: 100)
)
```

### `e.get`

Reads the current values of element fields after applying set rules.

The callback receives a 'get' function which can be used to read the values for a given element. The content returned by the function, which depends on those values, is then placed into the document.

**Signature:**

```rs
#e.get(
    receiver: function(function) -> content
)
```

**Example:**

```rs
#show: e.set_(elem, fill: green)
// ...
#e.get(get => {
  // OK
  assert(get(elem).fill == green)
})
```

### `e.named`
Name a certain rule. Use `e.apply` to name multiple rules at once. This is used to be able to revoke the rule later with [`e.revoke`](#erevoke).

Please note that, at the moment, each rule can only have one name. This means that applying multiple `named` on the same set of rules will simply replace the previous names.

However, more than one rule can have the same name, allowing both to be revoked at once if needed.

**Signature:**

```rs
#e.named(
  name: str,
  rule: e.apply(...) | e.set_(...) | e.revoke(...) | e.reset(...),
)
```

**Example:**

```rs
#show: e.named("cool rule", e.set_(elem, fields))
```

### `e.prepare`

Applies necessary show rules to the entire document so that custom elements behave properly. This is usually only needed for elements which have custom references, since, in that case, the document-wide rule `#show ref: e.ref` is required. **It is recommended to always use `e.prepare` when using Elembic.**

However, **some custom elements also have their own `prepare` functions.** (Read their documentation to know if that's the case.) Then, you may specify their functions as parameters to this function, and this function will run the `prepare` function of each element. Not specifying any elements will just run the default rules, which may still be important.

As an example, an element may use its own `prepare` function to apply some special behavior to its `outline`.

**Signature:**

```rs
#e.prepare(
  ..elems: function
)
```

**Example:**

```rs
// Apply default rules + special rules for these elements (if they need it)
#show: e.prepare(elemA, elemB)

// Apply default rules only
#show: e.prepare()
```

### `e.ref`

This is meant to be used in a show rule of the form `#show ref: e.ref` to ensure references to custom elements work properly.

Please use [`e.prepare`](#eprepare) as it does that automatically, and more if necessary.

**Signature:**

```rs
#e.ref(
  ref: content
)
```

**Example:**

```rs
#show ref: e.ref
```

### `e.reset`

**Temporarily revoke all active set rules for certain elements** (or even all elements, if none are specified). Applies only to the current scope, like other rules.

**Signature:**

```rs
#e.reset(
  ..elems: function,
  mode: auto | style-modes.normal | style-modes.leaky | style-modes.stateful = auto
)
```

**Example:**

```rs
#show: e.set_(element, fill: red)
#[
  // Revoke all previous set rules on 'element' for this scope
  #show: e.reset(element)
  #element[This is using the default fill (not red)]
]

// Rules not revoked outside the scope
#element[This is using red fill]
```

### `e.revoke`

Revoke all rules with a certain name, temporarily disabling their effects within the current scope. This is supported for named [set rules](#eset_), [reset rules](#ereset) and even revoke rules themselves (which prompts the originally revoked rules to temporarily apply again).

This is intended to be **used temporarily, in a specific scope**. This means you are supposed to only revoke the rule for a short portion of the document. If you wish to do the opposite, that is, only apply the rule for a short portion for the document (and have it never apply again afterwards), then **please just scope the set rule itself** instead.

You should use [`e.named`](#enamed) to add names to rules.

**Signature:**

```rs
#e.revoke(
  name: str,
  mode: auto | style-modes.normal | style-modes.leaky | style-modes.stateful = auto
)
```

**Example:**

```typ
#show: e.named("name", set_(element, fields))
...
#[
  #show: e.revoke("name")
  // rule 'name' doesn't apply here
  ...
]

// Applies here again
...
```

### `e.select`

Prepare selectors which **only match elements with a certain
set of values for their fields.** Receives filters in the format
`element.with(field: A, other-field: B)`. Note that the fields
must be specified through their names, even if they are usually
positional. These filters are similar in spirit to native
elements' `element.where(..fields)` selectors.

For each filter specified, an additional selector argument
is passed to the callback function. These selectors can be used
for **show rules** and **querying**. Note that `#show sel: set (...)`
will only apply to the element's body (which could be fine). In addition,
rules applied as `#show sel: e.set_(...)` **are applied in reverse** due
to how Typst works, so be careful when doing that, especially when using
something like [`e.revoke`](#erevoke).

You must wrap the remainder of the document that depends on those selectors
as the value returned by the callback.

It is thus recommended to **only use this function once, at the very top of the
document,** to get all the needed selectors. This is because this function
**can only match elements within the returned callback.** Elements outside it
are not matched by the selectors, even if their fields' values match.

**Signature:**

```rs
#e.select(
  ..filters: element.with(one-field: expected-value, another-field: expected-value),
  receiver: function(..selectors) -> content
)
```

**Example:**

```rs
#e.select(superbox.with(fill: red), superbox.with(width: auto), (red-superbox, auto-superbox) => {
  // Hide superboxes with red fill or auto width
  show red-superbox: none
  show auto-superbox: none

  // This one is hidden
  #superbox(fill: red)

  // This one is hidden
  #superbox(width: auto)

  // This one is kept
  #superbox(fill: green, width: 5pt)
})
```

### `e.set_`

Apply a set rule to a custom element. Check out [the Styling guide](../../elements/using/styling.md)
for more information.

Note that this function only accepts non-required fields (that have a `default`). Any required fields
must always be specified at call site and, as such, are always be prioritized, so it is pointless
to have set rules for those.

Keep in mind the [limitations](../../about/limitations.md) when using set rules, as well as
revoke, reset and apply rules.

As such, when applying **many set rules at once**, **please use [`e.apply`](#eapply) instead**
(or specify them consecutively so `elembic` does that automatically).

**Signature:**

```rs
#e.set_(
  elem: function,
  ..fields
)
```

**Example:**

```rs
#show: e.set_(superbox, fill: red)
#show: e.set_(superbox, optional-pos-arg1, optional-pos-arg2)

// This call will be equivalent to:
// #superbox(required-arg, optional-pos-arg1, optional-pos-arg2, fill: red)
#superbox(required-arg)
```

### `e.style-modes`

Dictionary with an integer for each style mode:

- `normal` (**normal mode** - default): limit of ~30 non-consecutive rules.
- `leaky` (**leaky mode**): limit of ~60 non-consecutive rules.
- `stateful` (**stateful mode**): no rule limit, but slower.

You will normally not use these values directly, but rather e.g.
use `e.stateful.set_(...)` to use a stateful-only rule.

Read [limitations](../../about/limitations.md) for more information.

## Data extraction

### `e.counter`
### `e.ctx`
### `e.data`
### `e.fields`
### `e.scope`
### `e.selector`
