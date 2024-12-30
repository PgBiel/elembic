#import "/src/lib.typ": element

#let (wibble, set-wibble, get-wibble) = element(
  "wibble",
  (color: red, inner: [Wibble!]) => {
    text(color)[#inner]
  }
)

#let (wobble, set-wobble, get-wobble) = element(
  "wobble",
  (fill: orange, inner: [Wobble...]) => {
    rect(fill: fill, inner)
  }
)

#wibble()
#wobble()

#[
  #show: set-wibble(color: blue)

  #wibble()
  #wobble()

  #show: set-wobble(fill: yellow)

  #wibble()
  #wobble()

  #get-wibble(v => assert.eq(v.at("color"), blue))
  #get-wobble(v => assert.eq(v.at("fill"), yellow))

  #[
    #show: set-wibble(inner: [Buh bye!])

    #get-wibble(v => assert.eq(v.at("inner"), [Buh bye!]))
    #get-wibble(v => v)

    #[
      #show: set-wobble(inner: [Dance!])
      #get-wobble(v => assert.eq(v.at("inner"), [Dance!]))
      #get-wobble(v => v)

      #wobble()
    ]

    #wibble()
  ]

  #[
    #show: set-wibble(color: green)
    #get-wibble(v => assert.eq(v.at("color"), green))
  ]

  #get-wibble(v => assert.eq(v.at("color"), blue))
  #wibble()

  #wibble(color: yellow)

  #wibble(inner: [Okay])
]

#wibble()
#wobble()