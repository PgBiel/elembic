# Creating Typst selectors

Sometimes, you might need to use Typst selectors - not elembic filters - to match custom elements, such as:

1. To match built-in elements and elembic elements simultaneously, e.g. in a show rule or built-in query;
2. To use `show elembic-elem: set native-typst-elem()` (show-set on native elements inside custom elements).

You can obtain native Typst selectors which match elements in two ways:

## Using `e.selector`

`e.selector(element)` returns a selector which matches all instances of that element for show rules and show-set rules.

You can also use `e.selector(element, outer: true)` specifically for show-set rules. This only matters if the element needs to read the final value of the set rule for its `display` logic, and is optional otherwise.

For example:

```rs
#show e.selector(theorem): set text(red)

#theorem[This text is red!!!]
```

## Using `e.select`

Since `e.selector(elem)` matches all instances, it does not take a filter. To pick which elements should be matched by a selector, use `e.select(filters..., (selectors...) => body, prefix: "...")` to create a scope where any new elements (inside `body`) matching an elembic filter will be matched by the corresponding selectors passed by parameter. This function effectively converts a filter to a Typst selector in a scope.

The `prefix` is used to avoid conflicts between separate calls to `e.select`. There is no conflict between nested `e.select` calls regardless of prefix, but with the same prefix, _sibling_ calls (or in totally separate places) will clash.

```admonish note
Since `e.select` can only match elements placed inside it, it may be wise to use it at the very top of the document, perhaps as part of your template, to match as many elements as possible.
```

```rs
#e.select(
  container.with(fill: red),
  container.with(fill: blue),
  prefix: "@preview/my-package/1",
  (red-container, blue-container) => [
    #show red-container: set text(red)
    #show blue-container: set text(red)

    #container(fill: red)[This text is red!]
    #container(fill: blue)[This text is red!]
    #container(fill: yellow)[This text is not red.]

    // "Matched red: 1"
    #context [Matched red: #query(red-container).len()]
  ]
)

// This one is outside that `select` and not picked up
#container(fill: red)
```
