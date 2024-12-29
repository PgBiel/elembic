// Create an element with the given name and constructor.
#let element(name, constructor, prefix: "") = {
  let lbl = label("__custom_element_" + prefix + name)
  let modified-constructor(..args) = [#context {
    // TODO: Reset to previous value
    set bibliography(title: auto)

    let defaults = if type(bibliography.title) == content and bibliography.title.func() == metadata and bibliography.title.at("label", default: none) == lbl { bibliography.title.value } else { () }

    constructor(..defaults, ..args)
  }#lbl]

  let set-rule(..args) = doc => [#context {
    let defaults = if type(bibliography.title) == content and bibliography.title.func() == metadata and bibliography.title.at("label", default: none) == lbl { bibliography.title.value } else { () }

    // TODO: Reset to previous value
    set bibliography(title: auto)
    show lbl: set bibliography(title: [#metadata(arguments(..defaults, ..args))#lbl])
    doc
  }#lbl]

  (modified-constructor, set-rule)
}
