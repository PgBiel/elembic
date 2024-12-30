// Create an element with the given name and constructor.
#let element(name, constructor, prefix: "") = {
  let lbl-show = label("__custom_element_shown_" + prefix + name)
  let lbl-get = label("__custom_element_get_" + prefix + name)

  let default-data = (
    // The current accumulated styles (default arguments) for the element.
    args: arguments(),
  )

  let modified-constructor(..args) = [#context {
    // TODO: Reset to previous value
    set bibliography(title: auto)

    let defaults = if type(bibliography.title) == content and bibliography.title.func() == metadata and bibliography.title.at("label", default: none) == lbl-get { bibliography.title.value } else { default-data }

    let args = arguments(..defaults.args, ..args)
    let body = constructor(..args)
    let tag = [#metadata((body: body, fields: args))]

    [#[#body#tag]#lbl-show]
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

  // "Apply show rules" to a placed element of this kind.
  // Basically, takes the output of the modified constructor,
  // of the form [#body#tag], and returns
  // '(body: tag.value.body, fields: tag.value.fields)'.
  //
  // If 'it' is not an element of this kind, returns
  // '(body: it, fields: none)' to indicate that this
  // is not an element of this kind, however still allow
  // just returning '.body' to keep the element unchanged.
  let show-rule = it => {
    if it.at("label", default: none) == lbl-show and it.has("children") {
      let data = it.children.at(1, default: (:)).at("value", default: (:))
      let body = data.at("body", default: it)
      let fields = data.at("fields", default: none)
      (body: body, fields: fields)
    } else {
      (body: it, fields: none)
    }
  }

  (modified-constructor, set-rule, get-rule, show-rule, lbl-show)
}
