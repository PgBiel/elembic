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
