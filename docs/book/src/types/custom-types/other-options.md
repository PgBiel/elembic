# Other custom type options

## Folding

If all of your fields may be omitted (for example), or if you just generally want to be able to combine fields, you could consider adding **folding** to your custom type with `fold: auto`, which will combine each field individually using their own fold methods. You can also use `fold: default constructor => (outer, inner) => combine inner with outer, giving priority to inner` for full customization.

## Custom constructor and argument parsing

Much like elements, you can use `construct: default-constructor => (..args) => value` to override the default constructor for your custom type. **You should use `construct:` rather than create a wrapper function** to ensure that [data retrieval functions](../../misc/reference/data.md), such as `e.data(func)`, still work.

You can use `parse-args: (default arg parser, fields: dictionary, typecheck: bool) => (args, include-required: true) => dictionary with fields` to override the built-in argument parser to the constructor (instead of overriding the entire constructor). `include-required` is always true and is simply a remnant from elements' own argument parser (which share code with the one used for custom types).

### Argument sink

Here's how you'd use this to implement a positional argument sink:

```rs
#let sunk = e.types.declare(
  "sunk",
  fields: (
    field("values", e.types.array(stroke), required: true),
    field("color", color, default: red),
    field("inner", content, default: [Hello!]),
  ),
  parse-args: (default-parser, fields: none, typecheck: none) => (args, include-required: true) => {
    let pos = args.pos()
    let values = if include-required {
      pos
    } else {
      // include-required is always true for types, but keep this here just for completeness
      assert(false, message: "type 'sunk': unexpected positional arguments\n  hint: these can only be passed to the constructor")
    }

    default-parser(arguments(values, ..args.named()), include-required: include-required)
  },
  prefix: ""
)

#assert.eq(e.fields(sunk(5pt, black, 5pt + black, inner: [A])), (values: (stroke(5pt), stroke(black), 5pt + black), inner: [A], color: red))
```
