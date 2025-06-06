# Constructing elements

A package you import will expose the **constructor function** for an element, used to **display a copy of it** in your document. This function may receive some arguments (**fields**) to configure the element's appearance, and creates content which you can then place in your document.

For example, a package might expose a `container` element with a single **required field**, its body. Required fields are usually specified **positionally**, without their names. It might also have a few **optional fields**, such as the box's width, which is `auto` (to adjust with the body) by default. Such fields are usually specified by their **names**.

Here's how we'd place a `container` into the document, exhibiting what the package defined that it should look like:

```rs
// Sample package name (it doesn't actually exist!)
#import "@preview/container-package:0.0.1": container

#container([Hello world!], width: 1cm)

// OR (syntactically equivalent)

#container(width: 1cm)[Hello world!]
```

````admonish tip
You can retrieve the arguments you specified above later with [`e.fields`](../../misc/reference/data.md#efields), obtained by importing `elembic` (or `e` for short):

```rs
#import "@preview/elembic:X.X.X" as e

#let my-container = container(fill: red)[Body]

#assert(e.fields(my-container.fill) == red)
#assert(e.fields(my-container.body) == [Body])
```

Arguments not specified above (not `fill` or `body`) won't be available (at least, outside of show rules), as those will depend on set rules which are not evaluated immediately (until you place `my-container` somewhere).
````

If you're repeating yourself a lot, always creating the same containers or with similar arguments, one strategy to make that easier is with a variable:

```rs
#let red-container = container.with(fill: red)

#red-container[This is already red!]
```

However, a better idea for templates and such is to use [set rules](./set-rules.md) to configure default values for each field.
