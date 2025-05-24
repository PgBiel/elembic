# Set rules

Often, you will want to have a **common style for a particular element** across your document, without repeating that configuration by hand all the time. For example, you might want that all `container` instances have a red border. You might also want them to have a fixed height of 1cm. Let's assume that element has two fields, `border` and `height`, which configure exactly those properties.

You may then use `elembic`'s **set rules** through `#show: e.set_(element, field: value, ...)`, which are similar to Typst's own set rules: they change the values of unspecified fields for all instances of an element within the nearest `#[ scope ]`. When they are not within a scope, they apply to the whole document.

For this and other operations with custom `elembic` elements, you will have to import `elembic`. It is common to alias it to just `e` for simplicity.

```admonish tip
Make sure to **group your set rules together** at the start of the document, if possible (or wherever they are going to be applied). That is, **avoid adding text and other elements between them.** This causes `elembic` to group them up and apply them in one go, avoiding one of its main [limitations](../about/limitations.md) in its default style mode: a **limit of up to ~30 non-consecutive set rules**. (The limitation is circumventable, but at the cost of reduced performance. Read more at the [Limitations](../about/limitations.md) page.)
```

Here's how you would set the default borders of all `container` instances to red:

```rs
#import "@preview/elembic:X.X.X" as e
#import "@preview/container-package:0.0.1": container

#show: e.set_(container, border: red)

// This will implicitly have a red border
#container(width: 1cm)[Hello world!]

// But the set rule is just a default
// This will override it with a blue border
#container(width: 1cm, border: blue)[Hello world!]
```

````admonish tip title="Tip: Applying multiple rules at once"
Use `e.apply(rule 1, rule 2, ...)` to **conveniently and safely apply multiple rules at once** (set rules, but also show rules and anything else provided by `elembic`). This is what `elembic` implicitly converts consecutive set rules to for efficiency, but it's nice and convenient to do it explicitly.

For example, let's set all containers' heights to 1cm as well. This will require two set rules, which are best grouped together as such:

```rs
#import "@preview/elembic:X.X.X" as e
#import "@preview/container-package:0.0.1": container

#show: e.apply(
  e.set_(container, border: red)
  e.set_(container, height: 1cm)
)

// The above is equivalent to:
// #show: e.set_(container, border: red)
// #show: e.set_(container, height: 1cm)

// This will implicitly have a red border and a height of 1cm
#container(width: 1cm)[Hello world!]
```
````

## Scoping set rules

It is useful to **always restrict temporary set rules to a certain scope** so they don't apply to the whole document. This not only avoids unintended behavior and signals intent, but also ensures you will keep a minimal amount of set rules active at once.

You can create a scope with `#[]`:

```rs
// This container has the default border
#container[Hello world!]

#[
  #show: e.set_(container, border: red)

  // These containers have a red border
  #container[Hello world!]
  #container[Hello world!]
  #container[Hello world!]
]

// This container has the default border again
// (The set rule is no longer in effect)
#container[Hello world!]
```

## Folding

Some types have support for **folding**. When applying multiple set rules for fields with these types, **their values are joined** instead of overridden. This applies, for example, to arrays, dictionaries and strokes. Note the example below:

```rs
// More on show rules in the show chapter
#show: e.show_(theorem, it => [Authors: #e.fields(it).authors.join(", ")])

#show: e.set_(theorem, authors: ("Robson", "Jane"))
#show: e.set_(theorem, authors: ("Kate",))

// Prints "Authors: Robson, Jane, Kate, Josef, Euler"
#theorem(authors: ("Josef", "Euler"))
```

The set rules and arguments do not override each other.

To disable folding behavior for a specific field, the package author has to disable folding for their element with `e.field("name", ..., fold: false)`. If the package author disabled folding for `authors`, it'd then print just `Authors: Josef, Euler` instead, as set rules would then override instead of joining.

```admonish note title="How are types joined during folding?"
Folding is a property, `fold`, of each type ("typeinfo") in elembic's type system. It may be a function of the form `(outer, inner) => new value` where `outer` is the previous value and `inner` is the next (such as `("Robson", "Jane")` and `("Kate",)` respectively for the second set rule above), returning a joined version of the two values (in the example, `("Robson", "Jane", "Kate")`). A function that always returns `inner` is equivalent to setting `fold: none` (type has no folding).

There is more information in the [Type system](../../types/type-system) chapter. The element's author can customize the `fold:` function for any type, even types which don't usually have folding, with `e.types.wrap(type, fold: prev-fold => (outer, inner) => new value)` (see more at ["Wrapping types"](../../types/type-system/wrapping-types.md)).
```
