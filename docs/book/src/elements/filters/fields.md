# Field filter

The most basic kind of filter, only matches elements with equal field values (checked with `==`).

Create this filter with `element.with(field: expected value, other field: expected value)`. All field values must match.

```admonish note
Since `==` is used for comparisons, this means `element.with(field: 5)` will match both `element(field: 5)` and `element(field: 5.0)` as `5 == 5.0` (type conversions are possible).
```

For example, to change the supplement of theorems authored exclusively by Robert:

```typ
#show: e.cond-set(theorem.with(authors: ("Robert",)), supplement: [Robert Theorem])

// Uses the default supplement, e.g. just "Theorem"
#theorem(authors: ("John", "Kate"))[First Theorem]

// Uses "Robert Theorem" as supplement
#theorem(authors: ("Robert",))[Second Theorem]
```
