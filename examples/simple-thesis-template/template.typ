#import "../../src/lib.typ" as e

#let settings = e.element.declare(
  "thesis-settings",
  doc: "Settings used by the thesis template.",
  prefix: "@preview/thesis-template,v1",

  // Not meant to be displayed
  display: it => panic("This element cannot be shown"),

  // The fields need defaults to be settable.
  fields: (
    e.field("title", str, doc: "The thesis title.", default: "My thesis"),
    e.field("author", str, doc: "The thesis author.", default: "Unspecified Author"),
    e.field("advisor", e.types.option(str), doc: "The advisor's name."),
    e.field("coadvisors", e.types.array(str), doc: "The coadvisors' names."),
  )
)

#let title-page = e.element.declare(
  "title-page",
  doc: "Title page for the thesis.",
  prefix: "@preview/thesis-template,v1",

  fields: (
    e.field("page-fill", e.types.option(e.types.paint), doc: "Optional page fill", default: none),
  ),

  display: it => e.get(get => {
    // Have a dedicated page
    show: page.with(fill: it.page-fill)
    set align(center)

    // Retrieve thesis settings
    let opts = get(settings)
    block(text(32pt)[#opts.title])
    block(text(20pt)[#opts.author])

    if opts.advisor != none {
      [Advised by #opts.advisor \ ]
    }

    for coadvisor in opts.coadvisors {
      [Coadvised by #coadvisor \ ]
    }
  }),
)

#let template = e.element.declare(
  "thesis",
  doc: "The best thesis template.",
  prefix: "@preview/thesis-template,v1",

  fields: (
    e.field("doc", content, doc: "The document to apply the template on.", required: true),
  ),

  display: it => e.get(get => {
    // Apply settings to document metadata
    set document(
      title: get(settings).title,
      author: get(settings).author,
    )

    // Apply some styles
    set heading(numbering: "1.")
    set par(first-line-indent: (all: true, amount: 2em))

    title-page()

    // Place the document, now with styles applied
    it.doc
  }),
)
