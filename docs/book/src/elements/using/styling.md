# Using, styling and configuring elements

Are you writing a document and using an element created by a third-party package using `elembic`? This page has some useful information for you.

## Creating and customizing an element instance

A package will expose the **constructor function** for the element. This function may receive some arguments (**fields**) to configure the element's appearance, and creates content which you can then place in your document.

For example, a package might expose a `container` element with a single **required field**, its body. Those fields are usually specified **positionally**, without their names. It might also have a few **optional fields**, such as the box's width, which is `auto` (to adjust with the body) by default. Such fields are usually specified by their names.

Here's how we'd place a `container` into the document, exhibiting what the package defined that it should look like:

```rs
// Sample package name (it doesn't actually exist!)
#import "@preview/container-package:0.0.1": container

#container([Hello world!], width: 1cm)

// OR (syntactically equivalent)

#container(width: 1cm)[Hello world!]
```

## Show rules: fully overriding appearance

You can fully override the appearance of an element using **show rules**. For this and other operations with custom `elembic` elements, you will have to import `elembic`. It is common to alias it to just `e` for simplicity.

You can use the `e.selector(element)` function to retrieve a selector you can use in show rules. This selector will match all occurrences of the element. You can then use `e.fields(it)` inside the show rule (where `it` is the element instance being replaced) to receive the final value provided for each of its fields. This can be used to conditionally override its appearance based on the element's properties.

For example, here's a show rule that would display the `width` field alongside each `container`.

```rs
#import "@preview/elembic:X.X.X" as e
#import "@preview/container-package:0.0.1": container

#show e.selector(container): it => {
  let fields = e.fields(it)
  [Here's a container with width #fields.width: #it]
}

// This will display:
// "Here's a container with width 1cm: Hello world!"
#container(width: 1cm)[Hello world!]
```

### Conditional show rules: matching elements with certain properties

You can also only apply show rules to elements with certain properties. For example, you may want to remove all containers with a red or blue `fill` property. This requires using the `e.select(..filters, (..selectors) => your document)` function, which will generate selectors for the given filters to allow you to apply show rules on them:

```rs
#import "@preview/elembic:X.X.X" as e
#import "@preview/container-package:0.0.1": container

#e.select(
  container.with(fill: red),
  container.with(fill: blue),
  (red-container, blue-container) => [
    // Remove red and blue fill containers
    #show red-container: none
    #show blue-container: none

    // This container is removed.
    #container(fill: red)[Hello world!]
    // This container is also removed.
    #container(fill: blue)[Hello world!]

    // But this container is kept.
    #container(fill: yellow)[Hello world!]
  ]
)
```

## Set rules: Configuring default values for fields

Often, you will want to have a **common style for a particular element** across your document, without repeating that configuration by hand all the time. For example, you might want that all `container` instances have a red border. You might also want them to have a fixed height of 1cm. Let's assume that element has two fields, `border` and `height`, which configure exactly those properties.

You may then use `elembic`'s **set rules** through `#show: e.set_(element, field: value, ...)`, which are similar to Typst's own set rules: they change the values of unspecified fields for all instances of an element within a certain scope. When they are not within a scope, they apply to the whole document.

> **Tip:** Make sure to **group your set rules together** at the start of the document, if possible (or wherever they are going to be applied). That is, **avoid adding text and other elements between them.** This causes `elembic` to group them up and apply them in one go, avoiding one of its main [limitations](../about/limitations.md) in its default style mode: a **limit of up to ~30 non-consecutive set rules**. (The limitation is circumventable, but at the cost of reduced performance. Read more at the [Limitations](../about/limitations.md) page.)

Here's how you would set the borders of all `container` instances to red:

```rs
#import "@preview/elembic:X.X.X" as e
#import "@preview/container-package:0.0.1": container

#show: e.set_(container, border: red)

// This will implicitly have a red border
#container(width: 1cm)[Hello world!]
```

Now, let's set all containers' heights to 1cm as well. Note that you can use `e.apply` to **conveniently and safely apply multiple rules at once** (while also circumventing the limitation mentioned above):

```rs
#import "@preview/elembic:X.X.X" as e
#import "@preview/container-package:0.0.1": container

#show: e.apply(
  e.set_(container, border: red)
  e.set_(container, height 1cm)
)

// This will implicitly have a red border and a height of 1cm
#container(width: 1cm)[Hello world!]
```

### Scoping set rules

As a general tip, and also having the above limitation in mind, it is useful to **always restrict temporary set rules to a certain scope** so they don't apply to the whole document. This not only avoids unintended behavior and signals intent, but also ensures you will keep a minimal amount of set rules active at once.

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

## Revoke and reset rules: temporarily reverting the effect of a set rule

Now, about the opposite situation: what if you want to ensure a particular set rule **has no effect for a limited part** of the document? For example, you might be setting all container borders to red, but maybe there's this particular, small section of the document where you want them to use the default border instead.

To do this, you can **give a name to the set rule** which you can then **revoke in a limited scope**, with `elembic`'s **revoke rules**:

```rs
// 1. Give a name to the rule
#show: e.named("red border", e.set_(container, border: red))

// This container has a red border
#container[Hello world!]

#[
  // Temporarily revoke our border-changing set rule from earlier
  #show: e.revoke("red border")

  // These containers have the default border again!
  #container[Hello world!]
  #container[Hello world!]
  #container[Hello world!]
]

// This container has a red border again
// (The revoke rule is no longer in effect,
// so the initial set rule is back in action)
#container[Hello world!]
```

However, if you have **many set rules** you want to revert, or if you want to revert unnamed set rules that a particular template chose and you cannot change, you can even use a **reset rule** to **temporarily undo all set rules to a certain element,** reverting it to its default state:

```rs
// A bunch of set rules which we may want to revert later
// (We could just name the 'apply' and it will set the names
// of all of them, but let's pretend we can't do that)
#show: e.apply(
  e.set_(container, border: red),
  e.set_(container, height: 2cm),
  e.set_(container, fill: yellow),
  e.set_(container, width: 1cm),
)

// This container has a red border, yellow fill,
// 2cm of height and 1cm of width (that's a lot
// of changes!)
#container[Hello world!]

#[
  // Temporarily reset ALL set rules for containers here
  #show: e.reset(container)

  // These containers have the default appearance again!
  #container[Hello world!]
  #container[Hello world!]

  // Might even want to temporarily change some properties
  // for these containers...
  #[
    #show: e.set_(container, border: red)
    #container[Hello world!]
    #container[Hello world!]
  ]
]

// This container has all the field values we set earlier
// again (red border, yellow fill, 2cm height, 1cm width),
// since the 'reset' is no longer in effect
#container[Hello world!]
```
