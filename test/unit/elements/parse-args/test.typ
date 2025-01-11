#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: field

#let missing() = {}
#let std-color = color
#let wock-parser-req(run, color: missing, inner: missing, some-extra-thing: missing) = {
  let res = (:)
  if run != missing {
    res.run = run
  }
  if color != missing {
    assert(type(color) == std-color, message: "field 'color' of element 'wock': color must be a color, got " + e.types.typename(color))
    res.color = color
  }
  if inner != missing {
    assert(type(inner) in (str, content, type(none)), message: "field 'inner' of element 'wock': must be content, got " + e.types.typename(color))
    res.inner = [#inner]
  }
  if some-extra-thing != missing {
    res.some-extra-thing = 10
  }

  res
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
  parse-args: (args, include-required: false) => {
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
