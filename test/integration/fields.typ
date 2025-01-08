#import "/src/lib.typ" as e: field, types

#let bool-or-pos-float = types.union(bool, float)
#(bool-or-pos-float.check = x => if type(x) == bool { true } else { x >= 0.0 })
#(bool-or-pos-float.error = _ => "float must be positive or zero")

#let door = e.element.declare(
  "door",
  display: it => {
    rect(fill: it.color)[#it]
  },
  fields: (
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
  ),
  prefix: ""
)

#door(red, blue, cool: true, sad: false, family: "family")
#door(red, blue, cool: true, sad: false, family: 0, verysad: false)

#show: e.set_(door, yellow)

#door(red, blue, cool: true, sad: true)
#e.get(get => assert.eq(get(door).extracolor, yellow))

#e.select(door.with(extracolor: yellow, sad: false), yellow-not-sad-doors => {
  show yellow-not-sad-doors: [yep, yellow door, not sad]

  door(red, blue, cool: true, sad: false)
  door(red, blue, green, cool: true, sad: true)
})

// Test casting
#door(red, blue, cool: true, sad: false, real-quantity: 5)
#door(red, blue, cool: true, sad: false, real-quantity: "abc")
#door(red, blue, cool: true, sad: false, quantity: 5.5)
#door(red, blue, cool: true, sad: false, anything: (a: 5))

#[
  #show: e.set_(door, just-true: true, float-or-content: 50, just-float: 5, just-content: "abc", bool-or-pos-float: false)

  #e.get(get => {
    assert(type(get(door).float-or-content) == float and get(door).float-or-content == 50.0)
    assert(type(get(door).just-float) == float and get(door).just-float == 5)
    assert(get(door).just-content == [abc])
  })
]
