# Conditional set rules

Some set rules that modify certain fields should only be applied if _other_ fields have specific values. For example, if a theorem has `kind: "lemma"`, you may want to set its `supplement` field to display as `[Lemma]`.

In this case, you can use `e.cond-set(filter, field1: value1, field2: value2, ...)`. `filter` determines which element instances should be changed, and what comes after are the fields to set.

The filter must be restricted to matching a single element, or it will be rejected. This is only a problem for certain filters, such as [NOT filters](../filters/logic-ops.md), [custom filters](../filters/custom.md) and [`e.within` filters](../filters/within.md). In that case, you can use `e.filters.and_(element, filter)` to force it to only apply to that element.

```admonish note
`e.cond-set(element.with(...), field: value)` is **not recursive**. This means that a separate `element` nested inside a matched `element` will **not** be affected.

This makes it differ from Typst's show-set rule, such as `show heading.where(level: 1): set heading(supplement: [Chapter])`, which would also affect any nested `heading`.

To also affect children and descendants similarly to Typst's show-set, use `e.filtered(element.with(...), e.set_(element, field: value))` together with `e.cond-set`.
```

For example:

```rs
#show: e.cond-set(theorem.with(kind: "lemma"), supplement: "Lemma")

// This will display "Theorem 1: The fact is true."
#theorem[The fact is true.]

// This will display "Lemma 1: The fact is also true."
#theorem(kind: "lemma")[This fact is also true.]
```
