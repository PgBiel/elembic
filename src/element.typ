#import "types/types.typ"
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
  assert(type(fields) == array, message: "element: please specify an array of fields.")

  let eid = prefix + "_" + name
  let lbl-show = label(lbl-show-head + eid)
  let lbl-get = label("__custom_element_get_" + eid)
  let lbl-where(n) = label("__custom_element_where_" + str(n) + eid)

  let fields = field-internals.parse-fields(fields, name: name)
  let (required-pos-fields, optional-pos-fields, required-named-fields, all-fields, parse-args-required, parse-args-not-required) = fields
  let required-pos-fields-amount = required-pos-fields.len()
  let optional-pos-fields-amount = optional-pos-fields.len()
  let total-pos-fields-amount = optional-pos-fields-amount + required-pos-fields-amount

  let default-fields = fields.all-fields.values().map(f => if f.required { (:) } else { ((f.name): f.default) }).sum(default: (:))

  // Parse arguments into a dictionary of fields and their casted values.
  // By default, include required arguments and error if they are missing.
  // Setting 'include-required' to false will error if they are present
  // instead.
  let old-parse-args-required(args) = {
    let result = (:)

    let pos = args.pos()
    if pos.len() < required-pos-fields-amount {
      // Plural
      let s = if required-pos-fields-amount - pos.len() == 1 { "" } else { "s" }

      assert(false, message: "element '" + name + "': missing positional field" + s + " " + fields.required-pos-fields.slice(pos.len()).map(f => "'" + f.name + "'").join(", "))
    }

    if pos.len() > total-pos-fields-amount {
      assert(false, message: "element '" + name + "': too many positional arguments, expected " + str(total-pos-fields-amount))
    }

    let i = 0
    for value in pos {
      let pos-field = if i >= required-pos-fields-amount { optional-pos-fields } else { required-pos-fields }.at(i)

      if (pos-field.typeinfo.castable)(value) {
        result.insert(
          pos-field.name,
          (pos-field.typeinfo.cast)(value)
        )
      } else {
        result.insert(
          pos-field.name,
          types.force-cast(
            value,
            pos-field.typeinfo,
            error-prefix: "field '" + pos-field.name + "' of element '" + name + "': "
          )
        )
      }
      i += 1

      if i == required-pos-fields-amount {
        // Now, indices for the optional pos args
        i = 0
      }
    }

    let named-args = args.named()

    for (field-name, value) in named-args {
      let field = all-fields.at(field-name, default: none)
      if field == none or not field.named {
        let expected-pos-hint = if field == none or field.named { "" } else { "\nhint: this field must be specified positionally" }

        assert(false, message: "element '" + name + "': unknown named field '" + field-name + "'" + expected-pos-hint)
      }

      if (field.typeinfo.castable)(value) {
        result.insert(
          field-name,
          (field.typeinfo.cast)(value)
        )
      } else {
        result.insert(
          field-name,
          types.force-cast(value, field.typeinfo, error-prefix: "field '" + field-name + "' of element '" + name + "': ")
        )
      }
    }

    let missing-fields = required-named-fields.filter(f => f.name not in named-args)
    if missing-fields != () {
      let s = if missing-fields.len() == 1 { "" } else { "s" }

      assert(false, message: "element '" + name + "': missing required named field" + s + " " + missing-fields.map(f => "'" + f.name + "'").join(", "))
    }

    result
  }
  let old-parse-args-not-required(args, include-required: true) = {
    let result = (:)

    let pos = args.pos()
    if pos.len() > optional-pos-fields-amount {
      assert(false, message: "element '" + name + "': too many positional arguments, expected " + str(expected-arg-amount) + "\nhint: only optional fields are accepted here")
    }

    let i = 0
    for value in pos {
      let pos-field = optional-pos-fields.at(i)

      result.insert(
        pos-field.name,
        types.force-cast(
          value,
          pos-field.typeinfo,
          error-prefix: "field '" + pos-field.name + "' of element '" + name + "': "
        )
      )
      i += 1
    }

    let named-args = args.named()

    for (field-name, value) in named-args {
      let field = all-fields.at(field-name, default: none)
      if field == none or not field.named {
        let expected-pos-hint = if field == none or field.named { "" } else { "\nhint: this field must be specified positionally" }

        assert(false, message: "element '" + name + "': unknown named field '" + field-name + "'" + expected-pos-hint)
      }

      if field.required {
        assert(false, message: "element '" + name + "': field '" + field-name + "' cannot be specified here\nhint: only optional fields are accepted here")
      }

      result.insert(
        field-name,
        types.force-cast(value, field.typeinfo, error-prefix: "field '" + field-name + "' of element '" + name + "': ")
      )
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
    let args = parse-args-required(args)
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

  let set-rule(..args) = {
    let args = parse-args-not-required(args)
    doc => context {
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
    assert(args.pos().len() == 0, message: "unexpected positional arguments\nhint: here, specify positional fields as named arguments, using their names")
    let args = args.named()

    let unknown-fields = args.keys().filter(k => k not in all-fields)
    if unknown-fields != () {
      let s = if unknown-fields.len() == 1 { "" } else { "s" }
      assert(false, message: "unknown field" + s + " " + unknown-fields.map(f => "'" + f + "'").join(", "))
    }

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
