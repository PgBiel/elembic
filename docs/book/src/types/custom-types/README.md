# Custom types

Elembic supports creating your own **custom types**, which are used to represent data structures with specific formats and fields. They do not compare equal to existing types, not even to dictionaries, even though they are themselves represented by dictionaries. They have their own unique ID based on `prefix` and `name`, similar to custom elements. **It is assumed that custom types with the same unique ID are equal,** so it should be changed if breaking changes ensue.

Custom types can be used as the types of fields in elements, or on their own through `types.cast`.

Custom types have **typechecked fields** in the constructor and support **casting** from other types, meaning you can accept e.g. an integer for a field taking a custom type.
