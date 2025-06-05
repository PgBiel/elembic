# Scripting

elembic has several utilities for using elements in scripting.

The main utility is [`e.data`](../../misc/reference/data.md#edata) and its helpers, which provide most or all data known to `elembic` about a custom element, an element instance, a custom type, and so on. This is explained in more detail in ["Fields and reflection"](./reflection.md).

However, there are other useful functions, such as [`e.query`](./query.md) to query element instances.

```admonish warning
To compare element instances for equality, especially if you're a package author, use `e.eq`, as described in ["Fields and reflection"](./reflection.md).
```
