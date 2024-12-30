// Prefix for the labels added to shown elements.
#let lbl-show-head = "__custom_element_shown_"

// Convert a custom element into a dictionary with (body, fields, func),
// allowing you to access its fields and information when given content.
//
// When this is not a custom element, 'body' will be the given value,
// 'fields' will be 'body.fields()' and 'func' will be 'body.func()'
#let show_(it) = {
    if type(it) != content {
    // TODO: switch to dict
    (body: it, fields: arguments(), func: none)
  } else if str(it.at("label", default: "")).starts-with(lbl-show-head) and it.has("children") {
    let data = it.children.at(1, default: (:)).at("value", default: (:))

    // TODO: switch fields to dict
    let body = data.at("body", default: it)
    let fields = data.at("fields", default: arguments())
    let func = data.at("func", default: it.func())

    (body: body, fields: fields, func: func)
  } else {
    // TODO: switch to dict
    (body: it, fields: arguments(..it.fields()), func: it.func())
  }
}

#let set_(elem, ..fields) = {
  assert(type(elem) != function, message: "Specify the element's dictionary, not the constructor function (e.g. wibble-e, which contains 'func' and other properties, rather than the wibble function).")

  (elem.set_)(..fields)
}

// Create an element with the given name and constructor.
#let element(name, constructor, prefix: "") = {
  let eid = prefix + "_" + name
  let lbl-show = label(lbl-show-head + eid)
  let lbl-get = label("__custom_element_get_" + eid)
  let lbl-where(n) = label("__custom_element_where_" + str(n) + eid)

  let default-data = (
    // How many 'where rules' have been applied so far to this
    // element. This is needed as, for each 'where rule', we have
    // to apply a unique label to matching elements, so we increase
    // this 'counter' by one each time.
    where-rule-count: 0,

    // The current accumulated styles (default arguments) for the element.
    args: (),
  )

  let modified-constructor(..args) = context {
    let previous-bib-title = bibliography.title
    [#context {
      set bibliography(title: previous-bib-title)

      let defaults = if type(bibliography.title) == content and bibliography.title.func() == metadata and bibliography.title.at("label", default: none) == lbl-get { bibliography.title.value } else { default-data }
  
      let args = arguments(..defaults.args.fold(arguments(), (a, b) => arguments(..a, ..b)), ..args)
      let body = constructor(..args)
      let tag = [#metadata((body: body, fields: args, func: modified-constructor))]
  
      [#[#body#tag]#lbl-show]
    }#lbl-get]
  }

  let set-rule(..args) = doc => context {
    let previous-bib-title = bibliography.title
    [#context {
      let defaults = if type(bibliography.title) == content and bibliography.title.func() == metadata and bibliography.title.at("label", default: none) == lbl-get { bibliography.title.value } else { default-data }

      set bibliography(title: previous-bib-title)
      show lbl-get: set bibliography(title: [#metadata((..defaults, args: (..defaults.args, args)))#lbl-get])
      doc
    }#lbl-get]
  }

  let get-rule(receiver) = context {
    let previous-bib-title = bibliography.title
    [#context {
      let defaults = if type(bibliography.title) == content and bibliography.title.func() == metadata and bibliography.title.at("label", default: none) == lbl-get { bibliography.title.value } else { default-data }

      set bibliography(title: previous-bib-title)
      receiver(defaults.args.fold(arguments(), (a, b) => arguments(..a, ..b)))
    }#lbl-get]
  }

  // Prepare a 'element.where(..args)' selector which
  // can be used in "show sel: set". This works by applying
  // a show rule to all element instances and, if they
  // match, they receive a unique label to be matched
  // by that selector. The selector is then provided
  // to the callback.
  let where-rule(receiver, ..args) = context {
    let previous-bib-title = bibliography.title
    [#context {
      let defaults = if type(bibliography.title) == content and bibliography.title.func() == metadata and bibliography.title.at("label", default: none) == lbl-get { bibliography.title.value } else { default-data }
  
      // Amount of 'where rules' so far, so we can
      // assign a unique number to each query
      let rule-counter = defaults.where-rule-count
      let matching-label = lbl-where(rule-counter)
  
      let pos = args.pos()
      let named = args.named()
  
      // Add unique matching label to all found elements
      show lbl-show: it => {
        let (fields,) = show_(it)
  
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
      set bibliography(title: previous-bib-title)
      show lbl-get: set bibliography(title: [#metadata((..defaults, where-rule-count: rule-counter + 1))#lbl-get])
  
      // Pass usable selector to the callback
      // This selector will only match elements with
      // the correct fields
      receiver(matching-label)    
    }#lbl-get]
  }

  (
    modified-constructor,
    (
      func: modified-constructor,
      set_: set-rule,
      get: get-rule,
      where: where-rule,
      sel: lbl-show
    )
  )
}
