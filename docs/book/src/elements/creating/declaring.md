# Declaring a custom element

Want to make a reusable and stylable component for your users? You can start by **creating your own element** as described below.

## First steps

You can use the `element.declare` function to create a custom element.
It will return the **constructor** for this element, which you should **export from your package or file**:

```rs
#import "@preview/elembic:X.X.X" as e

#let theorem = e.element.declare(
  // Element name.
  "theorem",

  // A prefix to disambiguate from elements with the same name.
  // Elements with the same name and prefix are treated as equal
  // by the library, which may cause bugs when mixing them up,
  // so conflicts should be avoided.
  prefix: "@preview/my-package,v1",

  // Default show rule: how this element displays itself.
  display: it => [Hello world!],

  // No fields for now.
  fields: ()
)

// Place it in the document:
#theorem()
```

This will display "Hello world!" in the document. Great!

Note that the element `prefix` is **fundamental for distinguishing elements with the same name.** The idea is for the element name to be simple (as that's what is displayed in errors and such), but the element **prefix should be as unique as possible.** (However, try to not make it _way_ too long either!)

Importantly, if you ever change the prefix (say, after a major update to your package), **users of the element with the old prefix** (i.e. in older versions) **will not be compatible with the element with the new prefix** (that is, their set rules won't target them and such). While this could be frustrating at first, **it is necessary if you change up your element's fields in a breaking way** to avoid bugs and incompatibility problems. Therefore, you may want to consider **adding a version number to the prefix** (could be your library's major version number or just a number specific to that element) which is changed on each breaking change to the element's fields.

## Adding fields

You may want to have your element's appearance be **configurable** by end users through **fields.**
Let's add a color field to change the fill of text inside our theorem:

```rs
#import "@preview/elembic:X.X.X" as e

#let theorem = e.element.declare(
  "theorem",
  prefix: "my-package",

  // Default show rule receives the constructed element.
  display: it => text(fill: it.fill)[Hello world!],

  fields: (
    // Specify field name, type, brief description and default.
    // This allows us to override the color if desired.
    e.field("fill", e.types.paint, doc: "The text fill.", default: red),
  )
)

// This theorem will display "Hello world!" in red.
#theorem()

// This theorem will display "Hello world!" in blue.
#theorem(fill: blue)
```

Here we use `e.types.paint` instead of just `color` because the `fill` could be a gradient or tiling as well, for example; `paint` is a shorthand for `e.types.union(color, gradient, tiling)`.

To read more about the types that can be used for fields, read the [Type system](../../types/type-system) chapter.

Note that omitting `default: red` in the field creation would have caused an error, as Elembic cannot infer a default value for the color type.

However, that isn't a problem if, say, we add a **required** field with `required: true`. These fields do not need a default.

By default, required fields are **positional**, although one can also force them to be named through `named: true` (and vice-versa: you can have non-required fields be positional with `named: false`).

Let's give it a shot by allowing the user to **customize what goes inside the element:**

```rs
#import "@preview/elembic:X.X.X" as e

#let theorem = e.element.declare(
  "theorem",
  prefix: "my-package",

  display: it => text(fill: it.fill)[#fields.body],

  fields: (
    // Force this field to be specified.
    e.field("body", content, required: true),
    e.field("fill", e.types.paint, doc: "The text fill.", default: red),
  )
)

// This theorem will display "Wowzers!" in red.
#theorem[Wowzers!]

// This theorem will display "Some content" in blue.
#theorem(fill: blue)[Some content]
```

Note that this also allows users to **override the default values of fields** through **set rules**
(see [Styling elements](../using/styling.md) for more information):

```rs
#import "@preview/elembic:X.X.X" as e

#let theorem = e.element.declare(
  "theorem",
  prefix: "my-package",

  display: it => text(fill: it.fill)[#fields.body],

  fields: (
    // Force this field to be specified.
    e.field("body", content, required: true),
    e.field("fill", e.types.paint, doc: "The text fill.", default: red),
  )
)

#show: e.set_(theorem, fill: green)

// This theorem will display "Impressed!" in green.
#theorem[Impressed!]
```

## Setting overridable default styles with `template`

You can have a custom template for your element with the `template` option. It's a function `displayed element => content` where you're supposed to apply **default styles,** such as `#set par(justify: true)`, which the user can then override using the element's **outer selector** (`e.selector(elem, outer: true)`) in a show-set rule:

```rs
#let elem = e.element.declare(
  "elem",
  // ...
  template: it => {
    set par(justify: true)
    it
  },
)

// Par justify is enabled
#elem()

// Overriding:
#show e.selector(elem, outer: true): set par(justify: false)

// Par justify is disabled
#elem()
```
