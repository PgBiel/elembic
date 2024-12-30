#import "fields.typ" as field-internals

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
#let element(name, constructor, fields: none, prefix: "") = {
  assert(type(fields) == array, message: "element: Please specify an array of fields.")

  let eid = prefix + "_" + name
  let lbl-show = label(lbl-show-head + eid)
  let lbl-get = label("__custom_element_get_" + eid)
  let lbl-where(n) = label("__custom_element_where_" + str(n) + eid)

  let fields = field-internals.parse-fields(fields)
  let (required-pos-fields, optional-pos-fields, named-fields, all-fields) = fields
  let required-pos-fields-amount = required-pos-fields.len()
  let optional-pos-fields-amount = optional-pos-fields.len()

  let default-fields = fields.all-fields.values().map(f => if f.required { (:) } else { ((f.name): f.default) }).sum(default: (:))

  let parse-args(args) = {
    let result = (:)

    let pos = args.pos()
    if pos.len() < required-pos-fields-amount {
      // Plural
      let s = if required-pos-fields-amount - pos.len() == 1 { "" } else { "s" }

      assert(false, message: "element '" + name + "': Missing positional field" + s + " " + fields.required-pos-fields.slice(pos.len()).map(f => "'" + f.name + "'").join(", "))
    }

    for (value, required-pos-field) in pos.zip(required-pos-fields) {
      result.insert(
        required-pos-field.name,
        field-internals.unwrap-type-accept(value, required-pos-field.typeinfo, error-prefix: "field '" + required-pos-field.name + "' of element '" + name + "': ")
      )
    }

    for (value, optional-pos-field) in pos.slice(required-pos-fields-amount).zip(optional-pos-fields) {
      result.insert(
        optional-pos-field.name,
        field-internals.unwrap-type-accept(value, optional-pos-field.typeinfo, error-prefix: "field '" + optional-pos-field.name + "' of element '" + name + "': ")
      )
    }

    let named-args = args.named()

    for field in named-fields {
      let field-name = field.name
      if field-name in named-args {
        result.insert(
          field-name,
          field-internals.unwrap-type-accept(named-args.at(field-name), field.typeinfo, error-prefix: "field '" + field-name + "' of element '" + name + "': ")
        )
      } else if field.required {
        let missing-fields = all-fields.values().filter(f => f.required and f.named and f.name not in named-args).map(f => "'" + f.name + "'")
        let s = if missing-fields.len() == 1 { "" } else { "s" }

        assert(false, message: "element '" + name + "': Missing required named field" + s + " " + missing-fields.join(", "))
      }
    }

    result
  }

  let default-data = (
    // How many 'where rules' have been applied so far to this
    // element. This is needed as, for each 'where rule', we have
    // to apply a unique label to matching elements, so we increase
    // this 'counter' by one each time.
    where-rule-count: 0,

    // The current accumulated styles (default arguments) for the element.
    args: (),
  )

  let modified-constructor(..args) = {
    let args = parse-args(args)
    context {
      let previous-bib-title = bibliography.title
      [#context {
        set bibliography(title: previous-bib-title)
  
        let defaults = if type(bibliography.title) == content and bibliography.title.func() == metadata and bibliography.title.at("label", default: none) == lbl-get { bibliography.title.value } else { default-data }
    
        let constructed-fields = default-fields + defaults.args.sum(default: (:)) + args
        let body = constructor(constructed-fields)
        let tag = [#metadata((body: body, fields: constructed-fields, func: modified-constructor))]
    
        [#[#body#tag]#lbl-show]
      }#lbl-get]
    }
  }

  let set-rule(..args) = doc => {
    let args = parse-args(args)
    context {
      let previous-bib-title = bibliography.title
      [#context {
        let defaults = if type(bibliography.title) == content and bibliography.title.func() == metadata and bibliography.title.at("label", default: none) == lbl-get { bibliography.title.value } else { default-data }
  
        set bibliography(title: previous-bib-title)
        show lbl-get: set bibliography(title: [#metadata((..defaults, args: (..defaults.args, args)))#lbl-get])
        doc
      }#lbl-get]
    }
  }

  let get-rule(receiver) = context {
    let previous-bib-title = bibliography.title
    [#context {
      let defaults = if type(bibliography.title) == content and bibliography.title.func() == metadata and bibliography.title.at("label", default: none) == lbl-get { bibliography.title.value } else { default-data }

      set bibliography(title: previous-bib-title)
      receiver(defaults.args.sum(default: (:)))
    }#lbl-get]
  }

  // Prepare a 'element.where(..args)' selector which
  // can be used in "show sel: set". This works by applying
  // a show rule to all element instances and, if they
  // match, they receive a unique label to be matched
  // by that selector. The selector is then provided
  // to the callback.
  let where-rule(receiver, ..args) = {
    let args = parse-args(args)
    context {
      let previous-bib-title = bibliography.title
      [#context {
        let defaults = if type(bibliography.title) == content and bibliography.title.func() == metadata and bibliography.title.at("label", default: none) == lbl-get { bibliography.title.value } else { default-data }
    
        // Amount of 'where rules' so far, so we can
        // assign a unique number to each query
        let rule-counter = defaults.where-rule-count
        let matching-label = lbl-where(rule-counter)
    
        // Add unique matching label to all found elements
        show lbl-show: it => {
          let (fields,) = show_(it)
    
          // Check if all positional and named arguments match
          if type(fields) == dictionary and args.pairs().all(((k, v)) => k in fields and fields.at(k) == v) {
            [#[#it#[]]#matching-label]
          } else {
            it
          }
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
