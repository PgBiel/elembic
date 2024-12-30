// Create an element with the given name and constructor.
#let element(name, constructor, prefix: "") = {
  let lbl-get = label("__custom_element_get_" + prefix + name)

  let default-data = (
    // The current accumulated styles (default arguments) for the element.
    args: arguments(),
  )

  let modified-constructor(..args) = [#context {
    // TODO: Reset to previous value
    set bibliography(title: auto)

    let defaults = if type(bibliography.title) == content and bibliography.title.func() == metadata and bibliography.title.at("label", default: none) == lbl-get { bibliography.title.value } else { default-data }

    constructor(..defaults.args, ..args)
  }#lbl-get]

  let set-rule(..args) = doc => [#context {
    let defaults = if type(bibliography.title) == content and bibliography.title.func() == metadata and bibliography.title.at("label", default: none) == lbl-get { bibliography.title.value } else { default-data }

    // TODO: Reset to previous value
    set bibliography(title: auto)
    show lbl-get: set bibliography(title: [#metadata((..defaults, args: arguments(..defaults.args, ..args)))#lbl-get])
    doc
  }#lbl-get]

  let get-rule(receiver) = [#context {
    let defaults = if type(bibliography.title) == content and bibliography.title.func() == metadata and bibliography.title.at("label", default: none) == lbl-get { bibliography.title.value } else { default-data }

    // TODO: Reset to previous value
    set bibliography(title: auto)
    receiver(defaults.args)
  }#lbl-get]

  (modified-constructor, set-rule, get-rule)
}
