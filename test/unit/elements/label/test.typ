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
  assert.eq(fields.label, <badbad>)
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

#wock(color: blue, label: none)

#[
  #show e.selector(wock): it => {
    assert("label" not in e.fields(it))
    it
  }
  #wock(color: green)
]

#[
  #show e.selector(wock): it => {
    assert("label" not in e.fields(it))
    it
  }
  #wock(color: blue, label: none)
]

// Non-labelable elements can have a 'label' field
#let non-labelable = e.element.declare(
  "has label field",
  display: it => {
    assert.eq(it.label, [ABC])
  },
  fields: (
    field("color", color, default: red),
    field("inner", content, default: [Hello!]),
    field("label", content, default: [Hello!])
  ),
  labelable: false,
  prefix: ""
)

// Should properly cast to [ABC]
#non-labelable(label: "ABC")
