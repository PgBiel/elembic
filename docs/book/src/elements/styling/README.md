# Styling elements

This chapter teaches you useful information on how to best customize elements created with `elembic`.

````admonish note title="Preparation"
One important tip before using custom elements is to check in the custom element's documentation if it requires _preparation_. This is the case if:

1. You intend to use a `@reference` on that element.
2. The element says it needs it, e.g. to apply some basic show rules.

In that case, write the following at the top of your document:

```rs
#show: e.prepare(elem1, elem2, ...)
```

If only custom references are needed, just `#show: e.prepare()` is enough.

````
