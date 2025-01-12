# Outline

To enable outline support, you may either use `outline: auto` on an element that already supports references - in which case it will simply reuse the reference supplement and numbering in the outline - or use `outline: (caption: fields => content)`, which will show an extra caption beside `supplement` and `numbering` if they exist, otherwise (if the element doesn't support references, or uses `(custom: ...)` for references) it will simply display the `caption` by itself.

Note that the user doesn't need `#show: e.prepare()` for outline support to work, but it's good practice since it's needed for references.

The user may then display the element's outline using `#outline(target: e.selector(elem, outline: true))`.

```rs
#import "@preview/elembic:X.X.X" as e: field

#show: e.prepare()

#let theorem = e.element.declare(
  "theorem",
  prefix: "my-package",

  display: it => [*Theorem #e.counter(it).display("1"):* #text(fill: it.fill)[#it.body]],

  reference: (
    supplement: [Theorem],
    numbering: "1"
  ),

  outline: auto,

  fields: (
    e.field("body", content, required: true),
    e.field("fill", e.types.paint, doc: "The text fill.", default: red),
  )
)

#outline(target: e.selector(theorem, outline: true))

#theorem(label: <my-thm>)[*Hello world*]
#theorem(fill: blue, label: <other-thm>)[*1 + 1 = 2*]
```

![Outline shows: "Contents", "Theorem 1 ... 1", "Theorem 2 ... 1", referring to the two theorems below](https://github.com/user-attachments/assets/4235bacf-6aed-41d9-81aa-5113c4c28349)
