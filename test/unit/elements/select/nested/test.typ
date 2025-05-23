#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: field

#let wock = e.element.declare(
  "wock",
  display: it => {},
  fields: (
    field("color", color, default: red),
    field("size", length, default: 10pt)
  ),
  prefix: ""
)

#let blue-counter = counter("blue")
#let yellow-counter = counter("yellow")
#e.select(wock.with(color: blue), prefix: "sel1", blue-wock => [
  #e.select(wock.with(color: yellow), prefix: "sel1", yellow-wock => {
    show blue-wock: it => {
      blue-counter.step()
      it
    }
    show yellow-wock: it => {
      yellow-counter.step()
      it
    }

    wock(color: red, size: 10pt)
    wock(color: blue, size: 10pt)
    wock(color: yellow, size: 20pt)
    wock(color: yellow, size: 20pt)
    wock(color: blue, size: 20pt)
    wock(color: blue, size: 20pt)
  })
]))

#context assert.eq(blue-counter.get().first(), 3)
#context assert.eq(yellow-counter.get().first(), 2)
