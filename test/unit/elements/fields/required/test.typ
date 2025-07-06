// Test required fields and folding (see issue GH#55)

#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: field, types

#let person = types.declare(
  "person",
  fields: (
    field("names", e.types.array(str), required: true),
    field("age", int, required: true)
  ),
  prefix: "",
  default: person => person((), 5)
)

#let door = e.element.declare(
  "door",
  display: it => {
    (it.run)(it)
  },
  fields: (
    field("names", e.types.array(str), required: true),
    field("age-data", e.types.union(int, dictionary), required: true),
    field("owner", person),
    field("run", function, default: panic),
  ),
  prefix: ""
)

// Test folding
#[
  #show: e.set_(door, owner: person(("a", "b"), 40))
  #show: e.set_(door, owner: person(("c", "d"), 50))

  #(e.data(door).get)(d => assert.eq(d.owner, person(("c", "d"), 50)))
  #(e.data(door).get)(d => assert("names" not in d))
  #door(("a", "b"), 3, run: d => assert.eq((d.owner, d.names, d.age-data), (person(("c", "d"), 50), ("a", "b"), 3)))
]
