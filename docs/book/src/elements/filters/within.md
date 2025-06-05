# Nested elements

Filters created with `e.within(parent)` can be used to match **elements inside other elements**, that is, returned at some level by the element's `display()` function, or by any show rules on it.

For example, `e.filters.and_(theorem, e.within(container))` will match all `theorem` under `container` at any (known) depth.

```admonish warning title="Performance warning"
This feature can have a **potentially significant performance impact** on elements repeated hundreds or thousands of times, being more or less equivalent to [filtered rules](../styling/filtered-rules.md) in performance. Be mindful when using it. We do mitigate the performance impact through "lazy ancestry tracking", explained shortly below.
```

## Exact and max depth

You can choose to only match descendants at a certain exact depth, or at a maximum depth. This can be specified with `e.within(elem, depth: 2)` and `e.within(elem, max-depth: 2)`.

For example, within `parent(container(theorem()))` and **assuming `container` has ancestry tracking enabled** (see [Lazy ancestry tracking](#lazy-ancestry-tracking) for when that might not be the case):

- `e.within(parent, depth: 1)` matches only the `container`.
- `e.within(parent, depth: 2)` matches only the `theorem`.
- `e.within(parent, max-depth: 1)` matches only the `container`.
- `e.within(parent, max-depth: 2)` matches both the `container` and the `theorem`.

On the other hand, if `container` does not have ancestry tracking enabled, it is effectively "invisible" and `theorem` is considered to have depth 1.

## Lazy ancestry tracking

By default, elements do not keep track of ancestry (list of ancestor elements, used to match these filters) unless a rule using `e.within` is used. This is **lazy ancestry tracking** for short.

This means that descendants of `elem` are not known until the first usage of `e.within(elem)`. Therefore:
- If no `e.within(elem)` rules were used so far, it is not tracked by ancetsry, so `theorem` is considered as depth 1 in `parent(elem(theorem()))`.
- [Queries]() with `e.within(elem)` don't work if no rules were used with `e.within(elem)` (and won't match elements under `elem` coming before those rules).

This is because ancestry tracking has a notable performance impact for repeated elements and has to be disabled by default.

To **globally enable ancestry tracking** without any rules, use `e.settings(track-ancestry: (elem1, elem2, ...))` with a list of elements to enable it for:

```rs
// Force ancestry tracking for all instances of those elements in this scope
#show: e.settings(track-ancestry: (parent, container, theorem))

// This will now match properly even though `e.within(container)` isn't used
#show: e.show_(
  e.filters.and_(theorem, e.within(parent, depth: 2)),
  none
)

// Theorem here is hidden
#parent(container(theorem[Where did I go?]))

// This one is kept
#parent(theorem[I survived!])

// Same here
#theorem[I survived!]
```
