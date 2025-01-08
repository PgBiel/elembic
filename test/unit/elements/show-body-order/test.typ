#import "/test/unit/base.typ": template
#show: template

#import "/src/lib.typ" as e: field

#let (wock, wock-e) = e.element.declare(
  "wock",
  display: it => {
    square(width: 6pt, fill: it.color)[#it.inner]
  },
  fields: (
    field("color", color, default: red),
    field("inner", content, default: [])
  )
)

// By placing the body, previous show rules have no effect (circle is gone)...
#[
  #show wock-e.sel: it => {
    let (body, fields) = e.data(it)
    circle(radius: 4pt, fill: blue, body)
  }
  #show wock-e.sel: it => {
    let (body, fields) = e.data(it)
    square(height: 8pt, body, fill: orange)
  }
  #wock(inner: rect(width: 15pt, height: 8pt, fill: black))
]

// But by placing 'it', they do
#[
  #show wock-e.sel: it => {
    let (body, fields) = e.data(it)
    circle(radius: 4pt, fill: blue, it)
  }
  #show wock-e.sel: square.with(height: 8pt, fill: orange)
  #wock(inner: rect(width: 15pt, height: 8pt, fill: black))
]

#[
  #show wock-e.sel: it => {
    let (body, fields) = e.data(it)
    circle(radius: 4pt, fill: blue, body)
  }
  #show wock-e.sel: square.with(height: 8pt, fill: orange)
  #wock(inner: rect(width: 15pt, height: 8pt, fill: black))
]
