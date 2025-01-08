/// Test set with multiple elements.

#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: field, types

#let wibble = e.element.declare(
  "wibble",
  display: it => {
    (it.run)(it)
  },
  fields: (
    field("number", int, default: 5),
    field("data", str, default: "data"),
    field("run", function, default: panic),
  )
)

#let wobble = e.element.declare(
  "wobble",
  display: it => {
    (it.run)(it)
  },
  fields: (
    field("color", color, default: red),
    field("inner", content, default: [Hello!]),
    field("run", function, default: panic),
  )
)

#let assert-fields(num, data, clr, inner) = {
  wibble(run: it => assert.eq(it.number, num))
  wibble(run: it => assert.eq(it.data, data))
  wobble(run: it => assert.eq(it.color, clr))
  wobble(run: it => assert.eq(it.inner, inner))
}

#wibble(run: it => assert.eq(it.number, 5))
#wibble(run: it => assert.eq(it.data, "data"))

#wobble(run: it => assert.eq(it.color, red))
#wobble(run: it => assert.eq(it.inner, [Hello!]))

#show: e.set_(wobble, color: blue)
#assert-fields(5, "data", blue, [Hello!])

#[
  #show: e.set_(wobble, inner: [Bye!])

  #assert-fields(5, "data", blue, [Bye!])

  #[
    #show: e.set_(wibble, number: 10)

    #assert-fields(10, "data", blue, [Bye!])

    #[
      #show: e.set_(wobble, color: yellow)

      #assert-fields(10, "data", yellow, [Bye!])

      #show: e.set_(wibble, data: "abc")

      #assert-fields(10, "abc", yellow, [Bye!])
    ]

    #assert-fields(10, "data", blue, [Bye!])
  ]

  #assert-fields(5, "data", blue, [Bye!])
]

#assert-fields(5, "data", blue, [Hello!])
