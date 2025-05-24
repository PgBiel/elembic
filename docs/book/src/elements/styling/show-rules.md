# Show rules

You can fully **override the appearance** of an element using show rules. They work similarly to Typst's own show rules, but use `elembic` rules.

```admonish tip
**All usage tips from set rules apply here too:** show rules are also scoped, and they should be grouped together in your template to avoid counting too heavily towards the set rule limit. You can also use `e.apply(rule 1, rule2, ...)` to explicitly group them in a visually clean way.
```

A show rule has the form `e.show_(element or filter, it => replacement)`, where you specify the element which should be visually replaced, and then pass a function which **receives the replaced element** and **returns the replacement.**

In this function, use [`e.fields(it)`](../../misc/reference/data.md#efields) to retrieve the replaced element's final field values. This can be used to decide what to replace the element by based on its fields, or to display some fields for debugging and so on.

For example, here's a show rule that would display the `width` field alongside each `container`.

```rs
#import "@preview/elembic:X.X.X" as e
#import "@preview/container-package:0.0.1": container

#show: e.show_(container, it => {
  let fields = e.fields(it)
  [Here's a container with width #fields.width: #it]
})

// This will display:
// "Here's a container with width 1cm: Hello world!"
#container(width: 1cm)[Hello world!]
```

## Conditional show rules

You can also only apply show rules to **elements with certain values for fields** with **filters**. For example, you may want to remove all containers with a red or blue `fill` property. For this, you can use the simplest filters, which just compare field values: `with` filters, akin to Typst elements' `where` filters. Here's how you'd use them:

```rs
#import "@preview/elembic:X.X.X" as e
#import "@preview/container-package:0.0.1": container

// Remove red and blue fill containers
#show: e.show_(container.with(fill: red), none)
#show: e.show_(container.with(fill: blue), none)

// This container is removed.
#container(fill: red)[Hello world!]
// This container is also removed.
#container(fill: blue)[Hello world!]

// But this container is kept (fill isn't red or blue).
#container(fill: yellow)[Hello world!]
```

For more information on filters, see the dedicated chapter. They can be much more advanced and allow more fine-grained selections of elements.
