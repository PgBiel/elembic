#import "../../src/lib.typ" as e

/// General settings for the thesis template
#let global-settings = e.element.declare(
  "thesis-settings",
  doc: "General settings for the best thesis template.",
  prefix: "@preview/thesis-template,v1",

  // Not meant to be displayed, only receives set rules
  display: it => panic("This element cannot be shown"),

  // The fields need defaults to be settable.
  fields: (
    e.field("primary-color", e.types.paint, doc: "Primary color for the thesis.", default: blue),
    e.field("secondary-color", e.types.paint, doc: "Secondary color for the thesis.", default: gray.darken(40%)),
  ),
)

// Reusable title page that is configurable
#let title-page = e.element.declare(
  "title-page",
  doc: "Title page for the thesis.",
  prefix: "@preview/thesis-template,v1",

  fields: (
    e.field("page-fill", e.types.option(e.types.paint), doc: "Optional page fill", default: none),
    e.field("title", str, doc: "Thesis title", named: true, required: true),
    e.field("author", str, doc: "Thesis author"),
    e.field("advisor-block", e.types.option(content), doc: "Block with advisor information"),
  ),

  // Default, overridable show-set rules
  template: it => {
    set align(center)
    set text(weight: "bold")
    it
  },

  display: it => e.get(get => {
    // Have a dedicated page with configurable fill
    show: page.with(fill: it.page-fill)

    // Retrieve thesis settings
    let opts = get(global-settings)
    block(text(32pt, fill: opts.primary-color)[#it.title])
    block(text(20pt)[#it.author])
    if it.advisor-block != none {
      block({
        set text(12pt, fill: opts.secondary-color)
        it.advisor-block
      })
    }
  }),
)

#let template = e.element.declare(
  "thesis-template",
  doc: "A simple thesis template.",
  prefix: "@preview/thesis-template,v1",

  display: it => e.get(get => {
    let opts = get(global-settings)
    set document(
      title: it.title,
      author: it.author,
    )

    // Apply some styles
    set heading(numbering: "1.")
    set par(first-line-indent: (all: true, amount: 2em))

    title-page(title: it.title, author: it.author, advisor-block: {
      if it.advisor != none {
        [Advised by #it.advisor \ ]
      }

      for co-advisor in it.co-advisors {
        [Co-advised by #co-advisor \ ]
      }
    })

    // Highlight emphasized text with the primary color
    show emph: it => text(fill: opts.primary-color, it)
    // Place the document, now with styles applied
    it.body
  }),

  fields: (
    // A required field that is not `named: true` will be a positional argument
    e.field("body", content, doc: "Thesis content.", required: true),
    // Setting `named: true` on this argument means it will use the `title: [...]` syntax to be set
    e.field("title", str, doc: "The thesis title.", required: true, named: true),
    // Arguments with defaults or without `required: true` are optional
    e.field("author", str, doc: "The thesis author.", required: true, named: true),
    e.field("advisor", e.types.option(content), doc: "The advisor's name."),
    e.field("co-advisors", e.types.array(content), doc: "The co-advisors' names."),
  ),
)
