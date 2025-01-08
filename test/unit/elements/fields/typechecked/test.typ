#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: element, field, types

#let bool-or-pos-float = types.wrap(
  types.union(bool, float),
  check: _ => x => if type(x) == bool { true } else { x >= 0.0 },
  error: _ => _ => "float must be positive or zero"
)

#let singleton-array = types.wrap(
  types.any,
  name: "value wrapped in singleton array",
  output: (array,),
  cast: _ => v => if type(v) == array and v.len() == 1 { v } else { (v,) },
  default: (("b",),),
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
  field("bool-or-pos-float", bool-or-pos-float, default: 5.0),
  field("stroke", stroke),
  field("singleton-array", singleton-array),
)

#let (door, door-e) = element(
  "door",
  display: it => {
    rect(fill: it.color)[#it]
  },
  fields: all-fields
)

#let (udoor, udoor-e) = element(
  "udoor",
  display: it => {
    rect(fill: it.color)[#it]
  },
  fields: all-fields,
  allow-unknown-fields: true
)

#door(red, blue, cool: true, sad: false, family: "family")
#door(red, blue, cool: true, sad: false, family: 0, verysad: false)

#udoor(red, blue, cool: true, sad: false, family: 0, verysad: false)
#let u = udoor(red, blue, cool: true, sad: false, family: 0, verysad: true, nope-not-existing: 50)

#assert.eq(e.data(u).fields.nope-not-existing, 50)

#show: e.set_(door, yellow)
#show: e.set_(door, singleton-array: "a")
#show: e.set_(udoor, yellow)
#show: e.set_(udoor, this-does-not-exist: [abc])

#(udoor-e.get)(v => assert.eq(v.this-does-not-exist, [abc]))

#door(red, blue, cool: true, sad: true)
#(door-e.get)(v => assert.eq(v.extracolor, yellow))
#(door-e.get)(v => assert.eq(v.singleton-array, ("a",)))

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

#[
  #show: e.set_(door, just-true: true, float-or-content: 50, just-float: 5, just-content: "abc", bool-or-pos-float: false)

  #(door-e.get)(v => {
    assert(type(v.float-or-content) == float and v.float-or-content == 50.0)
    assert(type(v.just-float) == float and v.just-float == 5)
    assert(v.just-content == [abc])
  })
]

// Test folding
#show: e.set_(udoor, stroke: 4pt, unknown-field-here: 50)
#show: e.set_(udoor, stroke: black, unknown-field-here: 80)

#(e.data(udoor).get)(u => assert.eq(u.stroke, 4pt + black))
#(e.data(udoor).get)(u => assert.eq(u.unknown-field-here, 80))
