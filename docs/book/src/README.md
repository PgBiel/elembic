# Introduction

**Welcome to Elembic!** Elembic is a framework that lets you **create your own elements and types in Typst**, including **support for type-checking and casting** on the fly.

> **WARNING:** Elembic is currently experimental. Expect breaking changes before 0.1.0 is released and it is published to the package manager.

Elembic supports **Typst 0.11.0 or later.**

## Elements

Elembic allows you to create custom **elements,** which are **reusable visual components** of the document with **configurable properties** (through **styling**).

Elembic's elements support styling through **show and set rules**, which allow changing the default values of element properties in bulk. They **are scoped** (that is, lose effect at the end of the current `#[]` block) and **do not use `state` or `counter` by default,** making it comparatively fast.

However, **there are some important limitations**, so **make sure to read** the ["Limitations" page](./about/limitations.md), which explains them in detail.

In addition, Elembic includes some extras not natively available such as **revoke and reset rules** (which can be used to temporarily "undo" the effect of an earlier set rule, or group of set rules, for a limited scope). Also, Elembic can guarantee type-safety and more helpful errors by **typechecking inputs to elements' fields.**

Elembic also supports **custom reference and outline support** for your element, **per-element counter support**, **get rules** (accessing the current defaults of fields, considering set rules so far); **folding** (e.g. setting a stroke to `4pt` and, later, to `red` will result in a combined stroke of `4pt + red`); **scopes** (you can have some constants and functions attached to your element); and so on. Read the chapters under "Elements" to learn more.

## Types

Elembic ships with a **considerably flexible type system** through its `types` module, with its main purpose being to typecheck fields, but **it can be used anywhere you want** through the `e.types.cast(value, type)` function.

Not only does Elembic support **using and combining Typst-native types** (e.g. a field can take `e.types.union(int, stroke)` to support integers or strokes), but it also supports **declaring your own custom, nominal types**. They are represented as dictionaries, but **are strongly-typed,** such that a dictionary with the same fields won't cast to your custom type and vice-versa by default (unless you specify otherwise). For example, a data type representing a `person` won't cast to another type `owner` even if they share the same fields.

Custom types optionally support **arbitrary casting from other types.** For example, you may allow automatic casts from integers and floats to your custom type. This is mostly useful when creating "ad-hoc" types for certain elements with fully customized behavior. You can read more in the ["Custom types" chapter](./types/custom-types/.).

## License

Elembic is licensed under MIT or Apache-2.0, at your option.
