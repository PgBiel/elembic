# Filtered rules

Sometimes, you need to apply certain rules only to the **children of certain elements.** For example, you may want to add a blue background to all `thmref` elements inside `theorem` elements. For this, `e.filtered(filter, rule)` can be used. This is a special rule that applies an elembic `rule` on the children of each element matching `filter`.

```admonish warning
This rule has a **potential performance impact** if the filter matches too many elements, in the hundreds.
```

```admonish note
The filtered `rule` is **not** applied to elements matching the `filter`. Only to their children (output of the `display` function and any show rules).

This means `e.filtered(theorem, e.set_(theorem, supplement: [Abc]))` will only change the supplements of theorems inside other theorems, for example.
```

```rs
// Only apply to thmref inside theorem
#show: e.filtered(theorem, e.show_(thmref, block.with(fill: red)))

// This one does not have a red fill: it is outside a theorem.
#thmref(<abc>)


#theorem[
  // The 'thmref' here will have red fill.
  *A Theorem:* theorem #thmref(<abc>) also applies to rectangles.
]
```
