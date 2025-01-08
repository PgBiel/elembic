#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: types, field
#import types: native
#import "/src/types/types.typ": cast

#let person = types.declare(
  "person",
  construct: person => (name: "Joe", surname: "Johnson", age: 50) => person(name + if surname != "" { " " + surname }, age),
  fields: (
    field("name", str, required: true),
    field("age", int, required: true),
  ),
  prefix: "mypkg"
)

#assert.eq(cast(person(name: "Mike", surname: "Fictional", age: 60), person), (true, person(name: "Mike", surname: "Fictional", age: 60)))
#assert.eq(person(name: "Mike", surname: "Fictional", age: 60).name, "Mike Fictional")
#assert.eq(person(name: "Mike", surname: "Fictional", age: 60).age, 60)
#assert.eq(e.data(person).func, person)
