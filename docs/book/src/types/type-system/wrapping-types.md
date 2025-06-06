# Wrapping types

You may use the `types.wrap(type, ..overrides)` to override certain behaviors and properties of a type.

For each override, if you pass a function, you receive the old value and must return the new value.

Some examples:

1. **Positive integers:** You can use `let pos-int = types.wrap(int, check: old-check => value => value > 0)` to only accept positive integers.
2. **New default:** You can use `types.wrap(int, default: (5,))` to have an int type with a default value of 5 (note that we use an array with a single element, as opposed to `()` (empty array) which means no default);
    - If you're using this for a single field, considering specifying `e.field(..., default: new default)` instead.
3. **Always casting integers:** Use `types.wrap(int, output: (float,), cast: old-cast => float)` to only accept integers, but cast all of them to floats.
    - Note that we **overrode `output`** to indicate that only floats can be returned now (notably, not integers).

```admonish note title="Overriding a function with another"
If an override must set a property to a function, due to ambiguity with the notation above, it must be a function that returns the new function, e.g. `cast: old-cast => new-cast` where `new-cast` can be `some-input => casted output value`.
```

```admonish warning
Make sure to follow the [`typeinfo` format in the chapter's top-level page](./). Invalid overrides, such as malformed casts, may lead to elembic behaving incorrectly.

There are safeguards for the most common potential mistakes, but some mistakes cannot be caught, such as misbehaving cast and fold functions.

In particular:
- If you override `cast` and/or `fold`, **make sure to also override `output: (type 1, type 2, ...)`**. Anything that can be returned by `cast` or `fold` must be listed as an output type, e.g. `output: (int, float)` if both can only return integers or floats. **Do not** return a type outside `output`.
  - You can also use `output: ("any",)` in an extreme case, but **this is discouraged.**

- If you override `check` or `input`, make sure to also adjust `output` like above, especially if your new check is more permissive than the previous one.
```
