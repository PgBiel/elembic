#import "/test/unit/base.typ": template
#show: template

#import "/src/lib.typ" as e: field

#let wock = e.element.declare(
  "wock",
  display: it => {
    (it.run)(it)
  },
  fields: (
    field("run", function, required: true),
    field("border", stroke, default: red + 5pt),
    // No default
    field("second-border", stroke),
  ),
  prefix: ""
)

#let dock = e.element.declare(
  "dock",
  display: it => {
    (it.run)(it)
  },
  fields: (
    field("required-stroke", stroke, required: true),
    field("run", function, required: true),
  ),
  prefix: ""
)

// Native rectangle for comparison
#set rect(stroke: 2pt)
#set rect(stroke: orange)

#rect()

// Testing required folding field
#dock(5pt, it => assert.eq(it.required-stroke, stroke(5pt)))

// Testing without any set rules
#wock(it => {
  assert.eq(it.border, red + 5pt)
  assert.eq(it.second-border, stroke())
})
#e.get(
  get => {
    assert.eq(get(wock).border, red + 5pt)
    assert.eq(get(wock).second-border, stroke())
  }
)

#show: e.set_(wock, border: blue)
#show: e.set_(wock, border: 4pt)

#wock(it => {
  assert.eq(it.border, blue + 4pt)
  assert.eq(it.second-border, stroke())
})
#e.get(
  get => {
    assert.eq(get(wock).border, blue + 4pt)
    assert.eq(get(wock).second-border, stroke())
  }
)

#show: e.set_(wock, second-border: 5pt)
#show: e.named("gradient", e.set_(wock, second-border: gradient.linear(red, blue)))
#show: e.set_(wock, border: stroke(cap: "square"))
#show: e.named("bevel", e.set_(wock, border: stroke(join: "bevel")))
#show: e.set_(wock, border: stroke(dash: "dotted"))
#show: e.set_(wock, border: stroke(miter-limit: 40))

#let expected-border = stroke(paint: blue, thickness: 4pt, cap: "square", join: "bevel", dash: "dotted", miter-limit: 40)
#wock(it => {
  assert.eq(it.border, expected-border)
  assert.eq(it.second-border, 5pt + gradient.linear(red, blue))
})
#e.get(
  get => {
    assert.eq(get(wock).border, expected-border)
    assert.eq(get(wock).second-border, 5pt + gradient.linear(red, blue))
  }
)

#show: e.revoke("bevel")

#let expected-border = stroke(paint: blue, thickness: 4pt, cap: "square", dash: "dotted", miter-limit: 40)
#wock(it => {
  assert.eq(it.border, expected-border)
  assert.eq(it.second-border, 5pt + gradient.linear(red, blue))
})
#e.get(
  get => {
    assert.eq(get(wock).border, expected-border)
    assert.eq(get(wock).second-border, 5pt + gradient.linear(red, blue))
  }
)

#show: e.revoke("gradient")
#wock(it => {
  assert.eq(it.border, expected-border)
  assert.eq(it.second-border, stroke(5pt))
})
#e.get(
  get => {
    assert.eq(get(wock).border, expected-border)
    assert.eq(get(wock).second-border, stroke(5pt))
  }
)

#show: e.set_(wock, border: yellow)
#show: e.reset()
#show: e.set_(wock, border: 10pt)

// Note: we fold with the field default (red + 5pt), so 'red' remains for border
#wock(it => {
  assert.eq(it.border, stroke(red + 10pt))
  assert.eq(it.second-border, stroke())
})
#e.get(
  get => {
    assert.eq(get(wock).border, stroke(red + 10pt))
    assert.eq(get(wock).second-border, stroke())
  }
)

#wock(border: yellow, it => assert.eq(it.border, yellow + 10pt))
#wock(second-border: blue, it => assert.eq(it.second-border, stroke(blue)))
