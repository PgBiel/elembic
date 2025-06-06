# Labels and references

## Labeling elements

Elements can be labeled with `#elem(label: <label-name>)` (unless they set `labeled: false`.

Compared to what would be a more usual syntax (`#elem() <label-name>`, which **should not be used**), using `label` as an argument has multiple benefits:

1. It works as a field, and so `#show: e.show_(elem.with(label: <label-name>), it => ...)` works (as well as in [filtered rules](../styling/filtered-rules.md) and so on), and the label is available through [`e.fields`](../../misc/reference/data.md#efields).
2. `#show <label-name>: it => ...` will have full field data available. (However, this show rule style is not revokable.)
3. It allows custom references to work, as outlined below.

## Referencing elements

To add reference support to an element, add `reference: (...)` in the element's declaration. It requires the keys `supplement` and `numbering`, which can be their usual values (content and string) or functions `final fields => value`, if you want the user to be able to override those values through `supplement` and `numbering` fields in the element. However, your reference can also be fully customized with `(custom: fields => content)`.

Then, you must tell your user to call `#show: e.prepare()` at the top of their own document, so that references will work properly.

By default, the number used by references is the element's own counter (accessible with `e.counter(elem)`), stepped by one for each element. You can use e.g. `count: counter => counter.update(n => n + 2)` or even `count: counter => fields => (something using fields)` to change this behavior.

```rs
#import "@preview/elembic:X.X.X" as e: field

// The line below must be written by the END USER for references to work!
#show: e.prepare()

#let theorem = e.element.declare(
  "theorem",
  prefix: "my-package",

  display: it => [*Theorem #e.counter(it).display("1"):* #text(fill: it.fill)[#it.body]],

  reference: (
    supplement: [Theorem],
    numbering: "1"
  ),

  fields: (
    e.field("body", content, required: true),
    e.field("fill", e.types.paint, doc: "The text fill.", default: red),
  )
)

#theorem(label: <my-thm>)[*Hello world*]
#theorem(fill: blue, label: <other-thm>)[*1 + 1 = 2*]

Here is @my-thm

Here is @other-thm
```

!["Theorem 1: Hello world" (in red), "Theorem 2: 1 + 1 = 2" (in blue), "Here is Theorem 1", "Here is Theorem 2"](https://github.com/user-attachments/assets/aeb178ba-5dbb-47cd-8369-61fdb88fd61e)
