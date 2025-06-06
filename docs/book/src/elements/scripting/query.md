# Query

Typst provides `query(selector)` for built-in Typst elements. The equivalent for custom `elembic` elements is `e.query(filter)`, which, similarly, must be used within `context { ... }`. It returns a list of elements matching `filter`. Check ["Filters"](../filters) for information on filters.

For example:

```rs
#import "@preview/elembic:X.X.X" as e

#elem(fill: red, name: "A")
#elem(fill: red, name: "B")
#elem(fill: blue, name: "C")

#context {
  let red-elems = e.query(elem.with(fill: red))

  // This will be:
  // "Red element names: A, B"
  [Red element names: #red-elems.map(it => e.fields(it).name).join[, ]]
}
```

```admonish note title="Restricting filter domains"
Filters must be restricted to a finite set of potentially matching elements to be used with `e.query`.

This is only a problem with [`NOT`](../filters/logic-ops.md) and [`within`](../filters/within.md) filters, which could potentially match any elements. They can be restricted to certain elements with `e.filters.and_(e.filters.or_(elem1, elem2), e.filters.not_(elem1.with(field: 5)))` for example.

In addition, using `e.within` with `e.query` won't work as expected without using `e.settings` to manually enable ancestry tracking; see the last section of this page for details.
```

## `before` and `after`

In Typst, for built-in elements, you can write `query(selector(element).before(here()))` to get all element instances before the current location, but not after. Similarly, using `.after(here())` will restrict the query to elements after the current location, but not before.

For elembic elements, `e.query` has the parameters `before: location` and `after: location` (can be used simultaneously) for the same effect.

```rs
#import "@preview/elembic:X.X.X" as e

#elem()

#elem()

// Before: 2
// After: 1
#context [
  Before: #e.query(elem, before: here()).len()
  After: #e.query(elem, after: here()).len()
]

#elem()
```

## Using `e.within` with query

The `e.within` filter, used to [match nested elements](../filters/within.md), will not work with `e.query` unless **both** the **queried element** and **its expected parent** track ancestry, as per the rules in ["Lazy ancestry tracking"](../filters/within.md#lazy-ancestry-tracking).

That is, `e.query(e.filters.and_(elem1, e.within(elem2)))` will return an empty list unless **both** `elem1` and `elem2` had ancestry tracking enabled before they were placed, e.g. due to the usage of rules containing `e.within(elem1)` and `e.within(elem2)`. Otherwise, those elements will not provide the information `e.query` needs!

However, remember that ancestry tracking can be manually enabled by adding `e.settings` at the top of your document:

```rs
#import "@preview/elembic:X.X.X" as e

// Without the following, the query would return 0 results
#show: e.settings(track-ancestry: (child, parent))

#parent(child(name: "A"))
#child(name: "B")

#context {
  let nested-child = e.query(e.filters.and_(child, e.within(parent)))

  // "Nested child elements are A"
  // (Requires 'e.settings' at the top to work)
  [Nested child elements are #nested-child.map(it => e.fields(it).name).join[, ]]
}
```
