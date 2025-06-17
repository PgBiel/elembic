#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: field

#show: e.prepare()

#let refs = counter("refs")
#let refnums = state("refnums", ())
#let wock = e.element.declare(
  "wock",
  display: it => {},
  fields: (
    field("color", color, default: red),
    field("inner", content, default: [Hello!])
  ),
  reference: (
    supplement: [#refs.step()],
    numbering: _ => n => refnums.update(s => s + (n,)),
  ),
  labelable: true,
  prefix: ""
)

#wock(color: blue) <my-wock>
@my-wock

#wock(color: blue) <my-wock2>
@my-wock2
@my-wock2[abc]

#context assert.eq(refs.get().first(), 2)
#context assert.eq(refnums.get(), (1, 2, 2))
