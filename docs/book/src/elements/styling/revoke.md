# Revoking rules

Most rules can be **temporarily revoked** in a certain scope. This is especially useful for [show rules](./show-rules.md), which often aren't easy to undo, unlike set rules. This can also be used to place an element while ignoring set rules if necessary. There are lots of possibilities!

This is also useful for **templates:** they can specify a default set of rules which the user can then revoke if they want **without changing the template's source code.**

## Naming rules

The first step to revoking a rule is **giving it a name** by using `e.named(name, rule)`. This is the name we'll use to indicate what to revoke:

```rs
#import "@preview/elembic:X.X.X" as e
#let elem = e.element.declare(/* ... */)
#show: e.named("removes elems", e.show_(elem, none))

// This is removed
#elem()

// This is removed
#elem()
```

```admonish tip
You can **assign multiple names** to the same rule (`e.named(name1, name2, ..., rule)`). Revoking any of them will revoke the rule.

In addition, **the same name can be shared** by multiple rules. Revoking that name revokes all of them. This can be used to create "groups" of revokable rules.
```

```admonish note title="Naming filtered rules"

[Filtered rules](./filtered-rules.md) need some extra attention regarding naming:

1. `e.named("name", e.filtered(filter, rule))` will assign `"name"` to `e.filtered`, but not to each `rule` created with this filter.

    - In this case, revoking `"name"` will stop any new `rule` from being applied, but will not revoke an already applied `rule` in this scope.

2. `e.filtered(filter, e.named("name", rule))` will assign `"name"` to each new `rule` created, but not to `e.filtered`. This is fairly unusual.

3. `e.named("name", e.filtered(filter, e.named("name", rule)))` will assign `"name"` to both `filtered` and each new copy of `rule`.

    - This is usually **recommended**, as revoking `"name"` will both stop `rule` from being applied and revoke an already active `rule`.
```

## `revoke` rules

Next, let's say we want to stop a rule from being applied in a certain limited scope. We can then use `e.revoke("name")` to temporarily revoke all rules with that name.

For example, let's temporarily cancel the show rule from the previous example to show just one element:

```rs
#import "@preview/elembic:X.X.X" as e
#let elem = e.element.declare(/* ... */)
#show: e.named("removes elems", e.show_(elem, none))

// This is removed
#elem()

#[
  #show: e.revoke("removes elems")

  // This is shown!
  #elem()
]

// This is removed
#elem()
```

## `reset` rules

Reset rules are more drastic and allow temporarily revoking **all previous rules** - named or not - in a certain scope.

The effect can be restricted to rules targeting only a single element, or (if nothing is specified) applied to all elements at once. **Use with caution,** as that may have unintended consequences to 3rd-party elements.

```admonish note title="Effect on filtered rules"
Reset rules targeting specific elements will stop active filtered rules targeting those elements from applying new rules, but will not revoke already applied rules unless they also target the same elements.
```

Consider the example below:

```rs
#show: e.set_(container, fill: red)
#show: e.set_(container, stroke: 5pt)

#container[This has red fill with a large black stroke.]

#[
  #show: e.reset(container)
  #show: e.set_(container, stroke: blue)

  #container[This has no fill with a normal-sized (not 5pt) blue stroke.]
]

#container[Back to red fill with large black stroke.]
```
