#import "template.typ" as thesis: e

#set page(paper: "a6")

// Configure template
#show: e.set_(thesis.global-settings, primary-color: red.darken(20%))

// Have a red background in the title page
#show: e.set_(thesis.title-page, page-fill: purple.lighten(90%))

// Override the bold text set rule
#show e.selector(thesis.title-page, outer: true): set text(weight: "regular")

// Apply italic text formatting in the title page
#show: e.show_(thesis.title-page, emph)

// Apply the template
#show: thesis.template.with(
  title: "My Awesome Thesis",
  author: "Kate",
  // These fields are optional
  advisor: "Robert",
  co-advisors: (
    "John",
    "Ana",
  ),
)

= Introduction

The _first_ paragraph.
#lorem(80)
