#import "/src/lib.typ" as e: field, types

#[
  #let bigbox = e.element.declare(
    "bigbox",
    prefix: "@preview/my-package,v1",
    display: it => block(fill: it.fill, stroke: it.stroke, inset: 5pt, it.body),
    fields: (
      field("body", types.option(content), doc: "Box contents", required: true),
      field("fill", types.option(types.paint), doc: "Box fill"),
      field("stroke", types.option(stroke), doc: "Box border", default: red)
    )
  )

  #bigbox[abc]

  #show: e.set_(bigbox, fill: red)

  #bigbox(stroke: blue + 2pt)[def]
]

#[
  #let person = e.types.declare(
    "person",
    prefix: "@preview/my-package,v1",
    fields: (
      field("name", str, doc: "Person's name", required: true),
      field("age", int, doc: "Person's age", default: 40),
      field("preference", types.any, doc: "Anything the person likes", default: none)
    ),
    casts: (
      (from: str, with: person => name => person(name)),
    )
  )

  #assert.eq(
    e.repr(person("John", age: 50, preference: "soup")),
    "person(age: 50, name: \"John\", preference: \"soup\")"
  )

  // Manually invoke typechecking and cast
  #assert.eq(
    types.cast("abc", person),
    (true, person("abc"))
  )
]
