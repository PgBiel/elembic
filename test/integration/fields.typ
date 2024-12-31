#import "/src/lib.typ" as e: element, field, types

#let (door, door-e) = element(
  "door",
  it => {
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
  )
)

#door(red, blue, cool: true, sad: false, family: "family")
#door(red, blue, cool: true, sad: false, family: 0, verysad: false)

#show: e.set_(door-e, yellow)

#door(red, blue, cool: true, sad: true)
#(door-e.get)(v => assert.eq(v.extracolor, yellow))

#(door-e.where)(extracolor: yellow, sad: false, yellow-not-sad-doors => {
  show yellow-not-sad-doors: [yep, yellow door, not sad]

  door(red, blue, cool: true, sad: false)
  door(red, blue, green, cool: true, sad: true)
})

// Test casting
#door(red, blue, cool: true, sad: false, real-quantity: 5)
#door(red, blue, cool: true, sad: false, real-quantity: "abc")
#door(red, blue, cool: true, sad: false, quantity: 5.5)
#door(red, blue, cool: true, sad: false, anything: (a: 5))