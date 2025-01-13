# Other custom type options

## Folding

If all of your fields may be omitted (for example), or if you just generally want to be able to combine fields, you could consider adding **folding** to your custom type with `fold: auto`, which will combine each field individually using their own fold methods. You can also use `fold: default constructor => (outer, inner) => combine inner with outer, giving priority to inner` for full customization.

## Custom constructor and argument parsing

Much like elements, you can use `construct: default-constructor => (..args) => value` to override the default constructor for your custom type. **You should use `construct:` rather than create a wrapper function** to ensure that data retrieval functions, such as `e.data(func)`, still work.

You can use `parse-args: default-constructor => (args, include-required: true) => dictionary with fields` to override the built-in argument parser to the constructor (instead of overriding the entire constructor). `include-required` is always true and is simply a remnant from elements' own argument parses (which share code with the one used for custom types).
