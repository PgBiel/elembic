#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: field, types

#let bool-or-pos-float = types.wrap(
  types.union(bool, float),
  check: _ => x => if type(x) == bool { true } else { x >= 0.0 },
  error: _ => _ => "float must be positive or zero"
)

#let all-fields = (
  field("color", color, required: true),
  field("backcolor", color, required: true),
  field("extracolor", types.option(color), named: false),
  field("sign", types.smart(content)),
  field("name", types.option(content)),
  field("family", types.union(int, str), default: 5),
  field("cool", bool, required: true, named: true),
  field("sad", bool, required: true, named: true),
  field("verysad", types.union(bool), named: true, default: true),
  field("fruit", types.union(types.literal("bana"), types.literal("nana")), default: "nana"),
  field("real-quantity", types.union(float, content), default: 5.5),
  field("quantity", types.exact(types.union(float, content)), default: 5.5),
  field("quantity-lit", types.exact(types.literal(10)), default: 10),
  field("anything", types.exact(types.any), default: 50),
  field("nothing", types.option(types.never), default: none),
  field("somethings", array, default: (5, 4)),
  field("matype", type, default: int),
  field("float-or-content", types.union(color, float, content), default: red),
  field("just-float", types.union(color, float), default: red),
  field("just-content", types.union(color, content),  default: red),
  field("just-true", types.literal(true), default: true),
  field("bool-or-pos-float", bool-or-pos-float, default: 5.0)
)

#let door = e.element.declare(
  "door",
  display: it => {
    rect(fill: it.color)[#it]
  },
  typecheck: false,
  fields: all-fields,
  prefix: ""
)

#let udoor = e.element.declare(
  "udoor",
  display: it => {
    rect(fill: it.color)[#it]
  },
  typecheck: false,
  fields: all-fields,
  prefix: "",
  allow-unknown-fields: true
)

#door(red, blue, cool: true, sad: false, family: "family")
#let d = door(red, blue, cool: true, sad: false, family: 0, verysad: "b")

#assert.eq(e.data(d).fields.verysad, "b")

#let u = udoor(red, blue, cool: true, sad: false, family: 0, verysad: true, real-quantity: "a", nope-not-existing: 50)

#assert.eq(e.data(u).fields.nope-not-existing, 50)
#assert.eq(e.data(u).fields.real-quantity, "a")

#show: e.set_(door, 50, verysad: red)

#door(red, blue, cool: true, sad: true)
#e.get(get => assert.eq(get(door).extracolor, 50))
#e.get(get => assert.eq(get(door).verysad, red))

#e.select(door.with(extracolor: yellow, sad: false), prefix: "sel1", yellow-not-sad-doors => {
  show yellow-not-sad-doors: [yep, yellow door, not sad]

  door(red, blue, cool: true, sad: false)
  door(red, blue, green, cool: true, sad: true)
})

#door(red, blue, cool: true, sad: "abc", real-quantity: 5)
#door(red, blue, cool: "not checked", sad: 5, real-quantity: "abc")
#door(red, blue, cool: true, sad: false, quantity: 5.5)
#door(red, blue, cool: true, sad: false, anything: (a: 5))
#door(red, 3, cool: true, sad: 50, quantity: red)


#[
  #show: e.set_(door, just-true: true, float-or-content: 50, just-float: 5, just-content: "abc", bool-or-pos-float: false)
  #show: e.set_(udoor, just-true: true, float-or-content: 50, just-float: 5, just-content: "abc", bool-or-pos-float: false)

  #e.get(get => {
    // No casting without typechecking
    assert(type(get(door).float-or-content) == int and get(door).float-or-content == 50)
    assert(type(get(door).just-float) == int and get(door).just-float == 5)
    assert(get(door).just-content == "abc")
  })

  #e.get(get => {
    // No casting without typechecking
    assert(type(get(udoor).float-or-content) == int and get(udoor).float-or-content == 50)
    assert(type(get(udoor).just-float) == int and get(udoor).just-float == 5)
    assert(get(udoor).just-content == "abc")
  })
]
