#import "template.typ" as thesis: e

// Configure template
#show: e.set_(
  thesis.settings,
  title: "Cool template",
  author: "Kate",
  advisor: "Robert",
  coadvisors: ("John", "Ana"),
)

// Have a red background in the title page
#show: e.set_(thesis.title-page, page-fill: red.lighten(50%))

// Italic text in the title page
#show: e.show_(thesis.title-page, emph)

// Apply the template
#show: thesis.template

= Introduction

#lorem(80)
