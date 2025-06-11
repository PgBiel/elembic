# Accessing context

Within your element's `display` function, you may sometimes need to **access contextual values.**
For example, you may have to:

1. Read the current text font (with `text.font`), or some other Typst set rule.
2. Read an elembic element's set rule.
3. Read the value of a certain `state` variable.
4. Read a counter.

How to do this with elembic?

There are a few options. The simplest and safest option is just `display: it => e.get(get => context { ... })`.

Here are all the options:

1. **Use the default context:** more efficient, but ignores show/show-set rules not applying to the outer selector, so usually not recommended.
2. **Use `e.get`:** if you need to read an elembic set rule, you can use a [get rule](../scripting/get.md).
    ````admonish tip
    Ensure `e.get` is the _first_ step in your `display` for greater performance, as elembic will avoid creating a needless nested `context` then:

    ```rs
    e.element.declare(
      display: it => e.get(get => {
        // Do everything else here
        // including a nested context block if needed
      })
    )
    ```
    ````

3. **Use explicit `context`:** to read other contextual values, you can use a nested `context` to guarantee all show-set rules are considered.

Compare each option below.

## Default context

By default, without an explicit `context` block, your `display` function runs under the **element's original context**.

This means that the values above, by default, can be read, but **ignoring [show](../styling/show-rules.md) / show-set rules on this element** as those are applied _after_ `display()` is called.

However, show / show-set rules on the element's **outer [selector](../styling/select.md)** can be read **without an additional `context`**.

```admonish note
The outer selector is applied before any rules - set rules, show rules and so on -, which is why this works.

Its downside is that it cannot be used for filtering in a show rule, precisely because the element's fields are not yet known.

If it can be used, however, it is the most lightweight option.
```

Consider this example using default context:

```rs
#import "@preview/elembic:X.X.X" as e
#let elem1 = e.element.declare(
  "elem1",
  prefix: "@example",
  fields: (),
  display: _ => text.size,
)
#set text(size: 2pt)
#show e.selector(elem1, outer: true): set text(size: 8pt)
#show e.selector(elem1): set text(size: 12pt)
#show: e.show_(elem1, it => { set text(size: 15pt); it })

// Displays "8pt" (non-outer rules ignored)
#elem1()
```

## Explicit context

Less efficient, but more likely to be what you are looking for.

Consider this example with explicit `context`, it will display "12pt" (non-outer show-set is considered):

```rs
#import "@preview/elembic:X.X.X" as e
#let elem2 = e.element.declare(
  "elem2",
  prefix: "@example",
  fields: (),
  display: _ => e.get(_ => context text.size),
)
#set text(size: 2pt)
#show e.selector(elem2, outer: true): set text(size: 8pt)
#show e.selector(elem2): set text(size: 12pt)
#show: e.show_(elem2, it => { set text(size: 15pt); it })

// Displays "12pt" (non-outer rules considered)
#elem2()
```
