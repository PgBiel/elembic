// Base template for tests
#let template(doc) = {
  set page(width: 120pt, height: auto, margin: 10pt)
  set text(10pt)

  doc
}

// Template for tests without any output
#let empty(doc) = {
  set page(width: 0pt, height: 0pt, margin: 0pt)
  set text(0pt)

  doc
}
