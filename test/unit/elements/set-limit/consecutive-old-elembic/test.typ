#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: field
#import "/src/data.typ": lbl-old-rule-tag

#let wock = e.element.declare(
  "wock",
  display: it => {},
  fields: (
    field("color", color, default: red),
    field("inner", content, default: [])
  ),
  prefix: ""
)

#let setter = e.set_(wock, color: red)
#let setter-old = {
  doc => {
    // Insert the old elembic rule label
    let output = setter(doc)
    assert.eq(output.children.len(), 2)
    let (body, meta) = output.children
    [#body#metadata(meta.value)#lbl-old-rule-tag]
  }
}
#show: setter
#show: setter-old
#show: setter
#show: setter-old
#show: setter
#show: setter-old
#show: setter
#show: setter-old
#show: setter
#show: setter-old
#show: setter // 10
#show: setter-old
#show: setter
#show: setter-old
#show: setter
#show: setter-old
#show: setter
#show: setter-old
#show: setter
#show: setter-old
#show: setter // 20
#show: setter-old
#show: setter
#show: setter-old
#show: setter
#show: setter-old
#show: setter
#show: setter-old
#show: setter
#show: setter-old
#show: setter // 30
#show: setter-old
#show: setter
#show: setter-old
#show: setter
#show: setter-old
#show: setter
#show: setter-old
#show: setter
#show: setter-old
#show: setter // 40
#show: setter-old
#show: setter
#show: setter-old
#show: setter
#show: setter-old
#show: setter
#show: setter-old
#show: setter
#show: setter-old
#show: setter // 50
#show: setter-old
#show: setter
#show: setter-old
#show: setter
#show: setter-old
#show: setter
#show: setter-old
#show: setter
#show: setter-old
#show: setter // 60
#show: setter-old
#show: setter
#show: setter-old
#show: setter
#show: setter-old
#show: setter
#show: setter-old
#show: setter
#show: setter-old
#show: setter // 70
#show: setter-old
#show: setter
#show: setter-old
#show: setter
#show: setter-old
#show: setter
#show: setter-old
#show: setter
#show: setter-old
#show: setter // 80
#show: setter-old
#show: setter
#show: setter-old
#show: setter
#show: setter-old
#show: setter
#show: setter-old
#show: setter
#show: setter-old
#show: setter // 90
#show: setter-old
#show: setter
#show: setter-old
#show: setter
#show: setter-old
#show: setter
#show: setter-old
#show: setter
#show: setter-old // 100

#wock()
