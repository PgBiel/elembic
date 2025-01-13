# elembic
Framework for custom elements and types in Typst. Supports Typst 0.11.0 or later.

**WARNING:** elembic is currently experimental. Expect breaking changes before 0.1.0 is released and it is published to the package manager.

**Read the book:** https://pgbiel.github.io/elembic

## About

Elembic lets you create **custom elements,** which are **reusable document components,** with support for **typechecked fields, show and set rules** (without using any `state` by default), **revoke and reset rules, reference and outline support,** and more. In addition, Elembic lets you create **custom types,** which also support **typechecked fields** but also **custom casting**, and can be used in element fields or by themselves in arbitrary Typst code.

Elembic's name comes from "element" + ["alembic"](https://en.wikipedia.org/wiki/Alembic), to indicate that one of Elembic's goals is to experiment with different approaches for this functionality, and to help shape a future update to Typst that includes native custom elements, which will eventually remove the need for using this package.

It has a few limitations which are [appropriately noted in the book.](https://pgbiel.github.io/elembic/about/limitations.html)

## Installation

You should copy the repository's contents either to your project or as a **local package.**

Instructions for using local packages can be found at [https://github.com/typst/packages](https://github.com/typst/packages), and involve
moving the directory with elembic's code to `$LOCAL_PACKAGES_DIR/elembic/0.0.1`, where `$LOCAL_PACKAGES_DIR`
depends on your operating system, as explained in the link.

If you're on Linux, you can run the following one-liner command on your terminal to download the latest development version:

```sh
pkgbase="${XDG_DATA_HOME:-$HOME/.local/share}/typst/packages/local/elembic" && mkdir -p "$pkgbase/0.0.1" && curl -L https://github.com/PgBiel/elembic/archive/main.tar.gz | tar xz --strip-components=1 --directory="$pkgbase/0.0.1"
```

## Example

### Custom element

```typ
#import "@local/elembic:0.0.1" as e: field, types

#let bigbox = e.element.declare(
  "bigbox",
  prefix: "@preview/my-package,v1",
  display: it => block(fill: it.fill, stroke: it.stroke, inset: 5pt, it.body),
  fields: (
    field("body", types.option(content), doc: "Box contents", required: true),
    field("fill", types.option(types.paint), doc: "Box fill"),
    field("stroke", types.option(stroke), doc: "Box border", default: red)
  )
)

#bigbox[abc]

#show: e.set_(bigbox, fill: red)

#bigbox(stroke: blue + 2pt)[def]
```

!['abc' with no fill and a thin red stroke, followed by 'def' with red fill and blue thicker stroke](https://github.com/user-attachments/assets/c852cfcd-c0de-446a-999b-5ecaa44809b7)

### Custom type

```typ
#import "@local/elembic:0.0.1" as e: field, types

#let person = e.types.declare(
  "person",
  prefix: "@preview/my-package,v1",
  fields: (
    field("name", str, doc: "Person's name", required: true),
    field("age", int, doc: "Person's age", default: 40),
    field("preference", types.any, doc: "Anything the person likes", default: none)
  ),
  casts: (
    (from: str, with: person => name => person(name)),
  )
)

#assert.eq(
  e.repr(person("John", age: 50, preference: "soup")),
  "person(age: 50, name: \"John\", preference: \"soup\")"
)

// Manually invoke typechecking and cast
#assert.eq(
  types.cast("abc", person),
  (true, person("abc"))
)

// Can then use 'person' as the type of an element's field, for example
```

## Source structure

- `pub/`: Contains public re-exports of each module (so we can keep some things private)
- `data`: Functions and constants related to extracting data from elements and types
- `element`: Functions related to creating and using elements and their rules (set rules, revoke rules and so on)
- `types`: Functions and constants related to Elembic's custom type system
- `fields`: Functions related to element and type field parsing

## License

Licensed under MIT or Apache-2.0, at your option.
