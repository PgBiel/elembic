# Get rules

Set rules are not only useful to set default parameters. They are also useful for **configuration** more broadly. This is particularly useful for **templates**, which can use elements for fine-grained configuration.

Get rules (`e.get`) allow you to **read the currently set values** for each element's fields. Here's a basic example:

```rs
#import "@preview/elembic:X.X.X" as e

#show: e.set_(elem, count: 1, names: ("Robert",))
#show: e.set_(elem, count: 5, names: ("John", "Kate"))

// Output:
// "The chosen count is 5."
// "The chosen names are Robert, John, Kate."
#e.get(get => {
  [The chosen count is #get(elem).count.]
  [The chosen names are #get(elem).names.join[, ].]
})
```

```admonish tip title="Usage in templates"
A template can use get rules for fine-grained settings. Check out the ["Simple Thesis Template" example](../examples/simple-thesis.md) for a sample.
```
