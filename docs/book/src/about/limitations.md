# Limitations

Please **keep in mind the following limitations** when using Elembic.

## Rule limit

Elembic has a limit of **up to 30 simultaneous rules by default**. This is due to a limitation in the
Typst compiler regarding maximum function call depth.

One **rule** may be a set rule, but also an **`apply` rule**, which has the power of **applying multiple consecutive rules at the cost of one.**
That is, an `apply` rule can even hold more than 30 rules (maybe 100) at once without a problem as it only counts for one.

Therefore, **always group set rules together into an apply rule whenever possible.** That is, **do as follows:**

```rs
#import "@preview/elembic:X.X.X" as e

// OK: Only paying for the cost of a single rule
#show: e.apply(
  e.set_(elem, fieldA: 1)
  e.set_(elem, fieldB: 2)
  e.set_(elem, fieldC: 3)
)
```

but **do not:**

```rs
#import "@preview/elembic:X.X.X" as e

// Don't do this! Paying for 3 rules instead of 1
// (There are implicit parbreaks between the rules,
// so they cannot be grouped together)
#show: e.set_(elem, fieldA: 1)

#show: e.set_(elem, fieldB: 2)

#show: e.set_(elem, fieldC: 3)
```

Note that Elembic is smart enough to group together rules **if there is absolutely nothing between them:**

```rs
#import "@preview/elembic:X.X.X" as e

// OK: These 3 are converted into an apply automatically
// (NOTHING between them)
#show: e.set_(elem, fieldA: 1)
#show: e.set_(elem, fieldB: 2)
#show: e.set_(elem, fieldC: 3)
```

but it is not recommended to rely on this behavior, as **it's easy to accidentally add some content between them,** stopping Elembic from being able to apply this optimization.

## Performance

Elembic's performance is, in general, satisfactory, but **may get worse if you use more features:**

- **Typechecking** of fields can add some overhead on each element instantiation. You can improve this by overriding Elembic's default argument parser, or even disabling typechecking altogether. (TODO)
- **Special rules** such as revoke rules may add some overhead. You may want to avoid using them if this harms your performance too much.
