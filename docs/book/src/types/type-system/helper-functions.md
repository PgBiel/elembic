# Helper functions

You can use `types.cast(element, type)` to try to cast an element to a type; this will return either `(true, casted-value)` or `(false, error-message)`.

There are also `types.typeid(value)` to obtain the "type ID" of this value (its type if it's a native type instance, or `(tid: ..., name: ...)` if it's an instance of a custom type, as well as `"custom type"` if it's a custom type literal obtained with `e.data(custom type)`), which is the format used in `input` and `output`.

In addition, `types.typename(value)` returns the name of the type of that value as a string, similar to `str(type(native type))` but extended to custom types.

Finally, `types.typeinfo(type)` will try to obtain a `typeinfo` object from that type (always succeeds if it's a typeinfo object by itself), returning `(true, typeinfo)` on success and `(false, error-message)` on failure.
