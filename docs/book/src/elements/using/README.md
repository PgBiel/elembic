# Using elements

This chapter is meant to provide insight on how end users of custom elements created with Elembic can use them to their full potential, including customization and features.

## Prepare

One important procedure to remember is to use `e.prepare` if the element demands it. Most elements might only need support for custom references, which can be enabled with the following show rule at the top of the end user's document:

```rs
#show: e.prepare()

// Great! Now custom references from all elements will work
```

However, some elements have their own custom document-wide preparation functions. If this is the case for one or more elements you'll need to use (read their documentation to know), you can include them as arguments to `prepare`:

```rs
#show: e.prepare(elem1, elem2)

// Great! Those elements have run their 'prepare' functions (if needed - depends on the element).
```
