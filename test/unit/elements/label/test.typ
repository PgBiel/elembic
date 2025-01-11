#import "/test/unit/base.typ": template
#show: template

#import "/src/lib.typ" as e: field

#let wock = e.element.declare(
  "wock",
  display: it => {},
  fields: (
    field("color", color, default: red),
    field("inner", content, default: [Hello!])
  ),
  labelable: true,
  prefix: ""
)

#show <badbad>: it => {
  let fields = e.fields(it)
  rect(width: 10pt, height: 5pt, fill: fields.color)
}

#wock(color: blue, label: <badbad>)

#e.select(wock.with(label: <blorb>), blorb => {
  show blorb: it => {
    let fields = e.fields(it)
    rect(width: 10pt, height: 5pt, fill: fields.color)
  }

  wock(color: green, label: <blorb>)
})
