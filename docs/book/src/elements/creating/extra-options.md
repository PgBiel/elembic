# Extra declaration options

## Setting overridable default styles with `template`

You can have a custom template for your element with the `template` option. It's a function `displayed element => content` where you're supposed to apply **default styles,** such as `#set par(justify: true)`, which the user can then override using the element's **outer selector** (`e.selector(elem, outer: true)`) in a show-set rule:

```rs
#import "@preview/elembic:X.X.X" as e: field

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

## Extra preparation with `prepare`

If your element needs some special, document-wide preparation (in particular, show and set rules) to function, you can specify `prepare: (elem, doc) => ...` to `declare`.

Then, the end user will **need to write** `#show: e.prepare(your-elem, /* any other elems... */)` at the top of their document to apply those rules.

Note that `e.prepare`, with or without arguments, is also used to enable references to custom elements, as noted in the [relevant page](./labels-refs.md).

```rs
#import "@preview/elembic:X.X.X" as e: field

#let elem = e.element.declare(
  "elem",
  // ...
  display: it => {
    figure(supplement: [Special Figure], numbering: "1.", kind: "some special figure created by your element")[abc]
  },
  prepare: (elem, it) => {
    // As an example, ensure some special figure you create has some properties
    show figure.where(kind: "some special figure created by your element"): set text(red)
    it
  },
)

// End user:
#show: e.prepare(elem)

// Now the generated figure has red text
#elem()
```
