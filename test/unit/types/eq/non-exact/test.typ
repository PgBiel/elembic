// Test e.eq()

#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: field, types

#let arbitrary = e.element.declare(
  "arbitrary",
  fields: (
    field("asrt", str, required: true),
  ),
  prefix: "a",
  display: _ => {},
  contextual: false,
)
#let arbitrary2 = e.element.declare(
  "arbitrary",
  fields: (
    field("asrt", str, required: true),
  ),
  prefix: "a",
  display: _ => {},
  contextual: true,
)

#let person = types.declare(
  "person",
  fields: (
    field("name", str, required: true),
    field("age", int, required: true),
    field("other", e.types.option(arbitrary)),
    field("payload", e.types.any, default: none)
  ),
  prefix: "",
  default: person => person("Joe", 5)
)

#let person2 = types.declare(
  "person",
  fields: (
    field("name", str, required: true),
    field("age", int, required: true),
    field("other", e.types.option(arbitrary2)),
    field("payload", e.types.any, default: none)
  ),
  prefix: "",
  default: person => person("Joe", 2),
  scope: (a: 10),
)

#let elem-fields = (
  field("string", str, required: true),
  field("integer", int, required: true),
  field("person", e.types.option(person)),
)

#let elem = e.element.declare(
  "elem",
  fields: elem-fields + (
    field("owner", e.types.option(person)),
  ),
  prefix: "a",
  display: _ => {},
  contextual: false,
)

// Same eid and fields, can still compare equal
#let elem2 = e.element.declare(
  "elem",
  fields: elem-fields + (
    field("owner", e.types.option(person2)),
  ),
  prefix: "a",
  display: _ => 55,
  contextual: true,
)

#assert(e.eq(1, 1))
#assert(e.eq(1.0, 1))
#assert(not e.eq(1, 2))
#assert(e.eq((1, 2), (1, 2)))
#assert(not e.eq((1, 2), (1, 3)))

#assert(elem("a", 10) != elem2("a", 10))
#assert(e.eid(elem("a", 10)) == e.eid(elem2("a", 10)))
#assert(e.fields(elem("a", 10)) == e.fields(elem2("a", 10)))
#assert(e.eq(elem("a", 10), elem("a", 10)))
#assert(e.eq(elem("a", 10), elem2("a", 10)))

#assert(person("Rob", 2) != person2("Rob", 2))
#assert(e.eq(person("Rob", 2), person2("Rob", 2)))
#assert(e.eq(person("Rob", 2, other: arbitrary("t")), person2("Rob", 2, other: arbitrary2("t"))))
#assert(not e.eq(person("Rob", 2), person2("Robb", 2)))
#assert(not e.eq(person("Rob", 2, other: arbitrary("tt")), person2("Rob", 2, other: arbitrary2("t"))))

#assert(not e.eq(elem("a", 10), elem("a", 20)))
#assert(not e.eq(elem("a", 10), elem2("a", 20)))
#assert(e.eq(elem("a", 10, person: person("Rob", 2)), elem("a", 10, person: person("Rob", 2))))
#assert(e.eq(elem("a", 10, person: person("Rob", 2)), elem2("a", 10, person: person("Rob", 2))))

#assert(e.eq(elem("a", 10, owner: person("Rob", 2)), elem2("a", 10, owner: person2("Rob", 2))))
#assert(not e.eq(elem("a", 10, owner: person("Rob", 2)), elem2("a", 10, owner: person2("Rob", 20))))

#assert(e.eq(
  (elem("a", 10), (elem("a", 10, person: person("Rob", 2)), elem("a", 10, person: person("Rob", 10)))),
  (elem2("a", 10), (elem2("a", 10, person: person("Rob", 2)), elem2("a", 10, person: person("Rob", 10))))
))
// Array order matters
#assert(not e.eq(
  (elem("a", 10), (elem("a", 10, person: person("Rob", 2)), elem("a", 10, person: person("Rob", 10)))),
  (elem2("a", 10), (elem2("a", 10, person: person("Rob", 10)), elem2("a", 10, person: person("Rob", 2))))
))
// Test array length
#assert(not e.eq(
  (elem("a", 10),),
  (elem2("a", 10), (elem2("a", 10, person: person("Rob", 10)), elem2("a", 10, person: person("Rob", 2))))
))

// Content fields
#assert(e.eq(box(elem("a", 10)), box(elem2("a", 10))))
#assert(e.eq(figure([a], caption: elem("a", 10)), figure([a], caption: elem2("a", 10))))
#assert(not e.eq(box(elem("a", 10)), box(elem2("a", 20))))
#assert(not e.eq(box(elem("a", 10)), strong(elem("a", 10))))
#assert(not e.eq(box(elem("a", 10)), strong(elem2("a", 10))))

// Dictionaries
#assert(e.eq((a: elem("a", 10)), (a: elem2("a", 10))))
#assert(not e.eq((a: elem("a", 10)), (a: elem2("a", 20))))
#assert(not e.eq((a: elem("a", 10)), (b: elem2("a", 10))))
#assert(not e.eq((b: elem("a", 10)), (a: elem2("a", 10))))

// Float / int casting
#assert(e.eq(4, 4.0))
#assert(e.eq(person("a", 2, payload: 4), person("a", 2, payload: 4.0)))
