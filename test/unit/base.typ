#import "/src/types/base.typ"

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

// Unwrap a result.
#let unwrap((res, value)) = {
  if not res {
    assert(false, message: "failing result unwrapped: " + value)
  }
  value
}

// Ensure the given value has the given type.
#let type-assert-eq(value, type_) = {
  assert.eq(base.typeid(value), type_)
}
