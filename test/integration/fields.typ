#import "/src/lib.typ" as e: element, fields
#import fields: field

#let (door, door-e) = element(
  "door",
  it => {
    rect(fill: it.color)[#it]
  },
  fields: (
    field("color", color, required: true),
    field("backcolor", color, required: true),
    field("extracolor", fields.option(color), named: false),
    field("sign", fields.smart(content)),
    field("name", fields.option(content)),
    field("family", fields.union(int, str), default: 5),
    field("cool", bool, required: true, named: true),
    field("sad", bool, required: true, named: true),
    field("verysad", fields.union(bool), named: true, default: true),
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