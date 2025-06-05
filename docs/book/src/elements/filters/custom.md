# Custom filters

These filters can be used to implement any arbitrary logic when matching elements by passing a simple function.

For example, `e.filters.and_(mytable, e.filters.custom((it, ..) => it.cells.len() > 5))` will match any `mytable` with more than 5 cells.

The filtering function **must return a boolean** (`true` to match this element), and receives the following parameters for each potential element:

1. Fields (positional).
2. `eid: "..."`: the element's eid. Useful if more than one kind of element is being tested by this filter. Use [`e.eid(elem)`](../../misc/reference/data.md#eeid) to retrieve the `eid` of an element for comparison.
3. `ancestry: (...)`: the ancestors of the current element, including `(fields: (...), eid: "...")`
4. Extra named arguments which **must be ignored** with `..` for forwards-compatibility with future elembic versions.

```admonish warning
Don't forget the `..` at the parameter list to ignore any potentially unused parameters (there can be more in future elembic updates).
```

````admonish note title="Restricting the domain"
Similarly to [NOT filters](./logic-ops.md), custom filters may be applied to any elements in principle. Therefore, they must be used within filter operators which restrict which elements they may apply to, usually AND.

For example, the following filter only applies to `elem1` and `elem2` instances, and checks different fields depending on which one it is:

```rs
e.filters.and_(
  e.filters.or_(elem1, elem2),
  e.filters.custom((it, eid: "", ..) => (
    eid == e.eid(elem1) and it.count > 5
    or eid == e.eid(elem2) and it.cells.len() < 10
  ))
)
```
````
