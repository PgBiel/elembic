#import "/src/lib.typ": element

#let (wock, set-wock) = element(
  "wock",
  (color: red, inner: [Hello!]) => {
    text(color)[#inner]
  }
)

#wock()

#[
  #show: set-wock(color: blue)

  #wock()

  #[
    #show: set-wock(inner: [Buh bye!])

    #wock()
  ]

  #wock()

  #wock(color: yellow)

  #wock(inner: [Okay])
]

#wock()