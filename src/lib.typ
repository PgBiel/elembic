// Create an element with the given name and constructor.
#let element(name, constructor, prefix: "") = {
  let eid = prefix + "_" + name
  let lbl-show = label("__custom_element_shown_" + eid)
  let lbl-get = label("__custom_element_get_" + eid)
  let lbl-where(n) = label("__custom_element_where_" + str(n) + eid)

  let default-data = (
    // How many 'where rules' have been applied so far to this
    // element. This is needed as, for each 'where rule', we have
    // to apply a unique label to matching elements, so we increase
    // this 'counter' by one each time.
    where-rule-count: 0,

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

  // Prepare a 'element.where(..args)' selector which
  // can be used in "show sel: set". This works by applying
  // a show rule to all element instances and, if they
  // match, they receive a unique label to be matched
  // by that selector. The selector is then provided
  // to the callback.
  let where-rule(receiver, ..args) = [#context {
    let defaults = if type(bibliography.title) == content and bibliography.title.func() == metadata and bibliography.title.at("label", default: none) == lbl-get { bibliography.title.value } else { default-data }

    // Amount of 'where rules' so far, so we can
    // assign a unique number to each query
    let rule-counter = defaults.where-rule-count
    let matching-label = lbl-where(rule-counter)

    let pos = args.pos()
    let named = args.named()

    // Add unique matching label to all found elements
    show lbl-show: it => {
      let (fields,) = show-rule(it)

      // Check if all positional and named arguments match
      if fields != none and fields.pos().slice(0, args.pos().len()) == pos {
        let named-fields = fields.named()
        if named.pairs().all(((k, v)) => k in named-fields and named-fields.at(k) == v) {
          return [#[#it#[]]#matching-label]
        }
      }
      it
    }

    // Increase where rule counter for further where rules
    // TODO: Reset to previous value
    set bibliography(title: auto)
    show lbl-get: set bibliography(title: [#metadata((..defaults, where-rule-count: rule-counter + 1))#lbl-get])

    // Pass usable selector to the callback
    // This selector will only match elements with
    // the correct fields
    receiver(matching-label)    
  }#lbl-get]

  (
    modified-constructor,
    (
      func: modified-constructor,
      set_: set-rule,
      get: get-rule,
      show_: show-rule,
      where: where-rule,
      sel: lbl-show
    )
  )
}
