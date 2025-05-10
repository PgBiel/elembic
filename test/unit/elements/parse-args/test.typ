#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: field

#let missing() = {}
#let std-color = color
#let wock-parser-req(run, color: missing, inner: missing, some-extra-thing: missing) = {
  let res = (:)
  if run != missing {
    if type(run) != function {
      return (false, "field 'run' of element 'wock': must be a function, got " + e.types.typename(run))
    }
    res.run = run
  }
  if color != missing {
    if type(color) != std-color {
      return (false, "field 'color' of element 'wock': color must be a color, got " + e.types.typename(color))
    }
    res.color = color
  }
  if inner != missing {
    if type(inner) not in (str, content, type(none)) {
      return (false, "field 'inner' of element 'wock': must be content, got " + e.types.typename(inner))
    }
    res.inner = [#inner]
  }
  if some-extra-thing != missing {
    res.some-extra-thing = 10
  }

  (true, res)
}
#let wock-parser-not-req(color: missing, inner: missing, some-extra-thing: missing) = {
  wock-parser-req(missing, color: color, inner: inner, some-extra-thing: some-extra-thing)
}

#let wock = e.element.declare(
  "wock",
  display: it => {
    (it.run)(it)
  },
  fields: (
    field("run", function, required: true),
    field("color", color, default: red),
    field("inner", content, default: [Hello!]),
  ),
  parse-args: (..) => (args, include-required: false) => {
    if include-required {
      wock-parser-req(..args)
    } else {
      wock-parser-not-req(..args)
    }
  },
  prefix: ""
)

#wock(it => {
  assert.eq(it.color, red)
  assert.eq(it.inner, [Hello!])
})
#wock(color: blue, it => {
  assert.eq(it.color, blue)
  assert.eq(it.inner, [Hello!])
})
#wock(color: blue, inner: [Bye!], it => {
  assert.eq(it.color, blue)
  assert.eq(it.inner, [Bye!])
})
#wock(color: blue, inner: [Bye!], some-extra-thing: true, it => {
  assert.eq(it.color, blue)
  assert.eq(it.inner, [Bye!])
  assert.eq(it.some-extra-thing, 10)
})

#show: e.set_(wock, color: yellow, some-extra-thing: true)

#wock(it => {
  assert.eq(it.color, yellow)
  assert.eq(it.inner, [Hello!])
  assert.eq(it.some-extra-thing, 10)
})

#e.get(get => {
  assert.eq(get(wock).color, yellow)
  assert.eq(get(wock).some-extra-thing, 10)
  assert("run" not in get(wock))
})

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
    let args = if include-required {
      // Convert positional arguments into a single 'values' argument
      let values = args.pos()
      arguments(values, ..args.named())
    } else if args.pos() == () {
      args
    } else {
      return (false, "element 'sunk': unexpected positional arguments\n  hint: these can only be passed to the constructor")
    }

    default-parser(args, include-required: include-required)
  },
  prefix: ""
)

#show: e.set_(sunk, color: blue)

#sunk(5pt, 10pt, black, 5pt + black, run: it => {
  let fields = e.fields(it)
  _ = fields.remove("run")
  assert.eq(fields, (values: (5pt, 10pt, black, 5pt + black).map(stroke), color: blue, inner: [Hello!]))
})
