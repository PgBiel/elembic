# Creating a custom element

Want to make a reusable and stylable component for your users? You can start by **creating your own element** as described below.

## First steps

You can use the `element.declare` function to create a custom element.
It will return the **constructor** for this element, which you should export from your package:

```rs
#import "@preview/elembic:X.X.X" as e

#let part = e.element.declare(
  // Element name.
  "part",

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
#part()
```

This will display "Hello world!" in the document.

Note that the element prefix is **fundamental for distinguishing elements with the same name.** The idea is for the element name to be simple (as that's what is displayed in errors and such), but the element **prefix should be as unique as possible.** (However, try to not make it too long to avoid expensive string comparisons in the library.)

Importantly, if you ever change the prefix (say, after a major update to your package), **users of the element with the old prefix** (i.e. in older versions) **will not be compatible with the element with the new prefix** (that is, their set rules won't target them and such). While this may sound bad, **it is necessary if you wildly change up your element's fields** to avoid bugs and incompatibility problems. Therefore, you may want to consider **adding a version number to the prefix** (could be your library's major version number or just a number specific to that element) which is changed on each breaking change to the element's fields.

## Adding fields

You may want to have your element's appearance be **configurable** by end users through **fields.**
Let's add a color field to change our part's color:

```rs
#import "@preview/elembic:X.X.X" as e

#let part = e.element.declare(
  "part",
  prefix: "my-package",

  // Default show rule receives the constructed element.
  display: it => text(fill: it.fill)[Hello world!],

  fields: (
    // Specify field name, type and default.
    // This allows us to override the color if desired.
    e.field("fill", color, default: red),
  )
)

// This part will display "Hello world!" in red.
#part()

// This part will display "Hello world!" in blue.
#part(fill: blue)
```

Note that omitting `default: red` would have caused an error, as Elembic cannot infer a default value for the color type.

However, that isn't a problem if, say, we add a **required** field with `required: true`. These fields do not need a default.

By default, required fields are **positional**, although one can also force them to be named through `named: true`.

Let's give it a shot:

```rs
#import "@preview/elembic:X.X.X" as e

#let part = e.element.declare(
  "part",
  prefix: "my-package",

  display: it => text(fill: it.fill)[#fields.body],

  fields: (
    // Force this field to be specified.
    e.field("body", content, required: true),
    e.field("fill", color, default: red),
  )
)

// This part will display "Wowzers!" in red.
#part[Wowzers!]

// This part will display "Some content" in blue.
#part(fill: blue)[Some content]
```
