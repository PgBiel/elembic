#import "/src/lib.typ": element

#let (wock, set-wock, get-wock) = element(
  "wock",
  (color: red, inner: [Hello!]) => {
    text(color)[#inner]
  }
)

#wock()

#[
  #show: set-wock(color: blue)

  #wock()

  #get-wock(v => assert.eq(v.at("color"), blue))

  #[
    #show: set-wock(inner: [Buh bye!])

    #get-wock(v => assert.eq(v.at("inner"), [Buh bye!]))
    #get-wock(v => v)

    #wock()
  ]

  #[
    #show: set-wock(color: green)
    #get-wock(v => assert.eq(v.at("color"), green))
  ]

  #get-wock(v => assert.eq(v.at("color"), blue))
  #wock()

  #wock(color: yellow)

  #wock(inner: [Okay])
]

#wock()