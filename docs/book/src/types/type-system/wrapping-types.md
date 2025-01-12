# Wrapping types

You may use the `types.wrap(type, ..overrides)` to override certain aspects of a type. For example, you can use `types.wrap(int, default: (5,))` to have an int type with a default value of 5 (note that we use an array with a single element, as opposed to `()` (empty array) which means no default), `types.wrap(int, check: old-check => value => value > 0)` to only accept positive integers, or `types.wrap(int, output: (float,), cast: old-cast => float)` to cast all integers to floats.

**It is important you update the `output:` if you override `cast:`** to indicate the new list of possibly casted-to types. Otherwise, Elembic will just guess and replace it with `("any",)`.

For each override, if you pass a function, you receive the old value and must return the new value (which can, itself, be a function, if that property supports it).

For more information on which properties are supported, you can [read about the `typeinfo` format in the chapter's top-level page](./).
