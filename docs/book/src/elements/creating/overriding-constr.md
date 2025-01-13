# Overriding the constructor and argument parsing

## Disabling typechecking

You can use `typecheck: false` to generate an argument parser that doesn't check fields' types. This is useful to retain type information but disable checking if that's needed. The performance difference is likely to not be too significant, so that likely wouldn't be enough of a reason, unless too many advanced typesystem features are used.

## Custom constructor

You can use `construct: default-constructor => (..args) => value` to override the default constructor for your custom type. **You should use `construct:` rather than creating a wrapper function** to ensure that [data retrieval functions](../../misc/reference/data.md), such as `e.data(func)`, still work.

## Custom argument parsing

You can use `parse-args: (default arg parser, fields: dictionary, typecheck: bool) => (args, include-required: bool) => dictionary with fields` to override the built-in argument parser. This is used both for the constructor and for set rules.

Here, `args` is an [`arguments`](https://typst.app/docs/reference/foundations/arguments/) and `include-required: true` indicates the function is being called in the constructor, so **required fields must be parsed and enforced.**

However, `include-required: false` indicates a call in set rules, so **required fields must not be parsed and forbidden.**

### Argument sink

Here's how you'd use this to implement a positional argument sink:

```rs
#let sunk = e.element.declare(
  "sunk",
  display: it => {
    (it.run)(it)
  },
  fields: (
    field("values", e.types.array(stroke), required: true),
    field("run", function, required: true, named: true),
    field("color", color, default: red),
    field("inner", content, default: [Hello!]),
  ),
  parse-args: (default-parser, fields: none, typecheck: none) => (args, include-required: false) => {
    let pos = args.pos()
    let values = if include-required {
      pos
    } else {
      assert(false, message: "element 'sunk': unexpected positional arguments\n  hint: these can only be passed to the constructor")
    }

    default-parser(arguments(values, ..args.named()), include-required: include-required)
  },
  prefix: ""
)

// Use 'run: func' as an example to test and ensure we received the correct fields
#sunk(5pt, 10pt, black, 5pt + black, run: it => assert.eq(it.values, (5pt, 10pt, black, 5pt + black).map(stroke)))
```
