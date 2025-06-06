# Filters

Filters are used by rules such as [show rules](../styling/show-rules.md) and [filtered rules](../styling/filtered-rules.md). They allow specifying which elements those rules should apply to.

They are mostly similar to Typst's [selectors](https://typst.app/docs/reference/foundations/selector), including some of its operators (`and_`, `or_`), but with some additional operators: `within` to match children, `not_` for negation, `xor` for either/or (not both), and `custom` to apply **any** condition.
