# Equality

To check if two instances of your custom type are equal, consider using:

1. `e.tid(a) == e.tid(b)` to check if both variables belong to the same custom type.
2. `e.eq(a, b)` to check if both variables have the exact same type and fields.
    - This checks only `tid` and fields recursively, ignoring changes to other custom type data between package versions, and so is safer.
    - Although it is slower than `==` for very complex types, so you can use `a == b` instead for private types, or for templates.
