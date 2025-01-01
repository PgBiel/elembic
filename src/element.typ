#import "types/base.typ": type-key
#import "types/types.typ"
#import "fields.typ" as field-internals

// Prefix for the labels added to shown elements.
#let lbl-show-head = "__custom_element_shown_"

// Label for context blocks which have access to the virtual stylechain.
#let lbl-get = label("__custom_element_get")

// Convert a custom element into a dictionary with (body, fields, func),
// allowing you to access its fields and information when given content.
//
// When this is not a custom element, 'body' will be the given value,
// 'fields' will be 'body.fields()' and 'func' will be 'body.func()'
#let show_(it) = {
  if type(it) != content {
    (body: it, fields: (:), func: none)
  } else if (
    it.has("label")
    and str(it.label).starts-with(lbl-show-head)
  ) {
    it.at("children", default: ()).at(1, default: (:)).at("value", default: (body: it, fields: (:), func: none))
  } else {
    (body: it, fields: it.fields(), func: it.func())
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
  let lbl-where(n) = label("__custom_element_where_" + str(n) + eid)

  let fields = field-internals.parse-fields(fields)
  let (required-pos-fields, optional-pos-fields, required-named-fields, all-fields) = fields
  let required-pos-fields-amount = required-pos-fields.len()
  let optional-pos-fields-amount = optional-pos-fields.len()
  let total-pos-fields-amount = required-pos-fields-amount + optional-pos-fields-amount
  let all-pos-fields = required-pos-fields + optional-pos-fields

  let default-fields = fields.all-fields.values().map(f => if f.required { (:) } else { ((f.name): f.default) }).sum(default: (:))

  // Parse arguments into a dictionary of fields and their casted values.
  // By default, include required arguments and error if they are missing.
  // Setting 'include-required' to false will error if they are present
  // instead.
  let parse-args(args, include-required: true) = {
    let result = (:)

    let pos = args.pos()
    if include-required and pos.len() < required-pos-fields-amount {
      // Plural
      let s = if required-pos-fields-amount - pos.len() == 1 { "" } else { "s" }

      assert(false, message: "element '" + name + "': missing positional field" + s + " " + fields.required-pos-fields.slice(pos.len()).map(f => "'" + f.name + "'").join(", "))
    }

    let expected-arg-amount = if include-required { total-pos-fields-amount } else { optional-pos-fields-amount }

    if pos.len() > expected-arg-amount {
      let excluding-required-hint = if include-required { "" } else { "\nhint: only optional fields are accepted here" }
      assert(false, message: "element '" + name + "': too many positional arguments, expected " + str(expected-arg-amount) + excluding-required-hint)
    }

    let pos-fields = if include-required { all-pos-fields } else { optional-pos-fields }
    let i = 0
    for value in pos {
      let pos-field = pos-fields.at(i)
      let typeinfo = pos-field.typeinfo
      let kind = typeinfo.at(type-key)

      result.insert(
        pos-field.name,
        if kind == "any" {
          value
        } else if kind == "native" and type(value) in typeinfo.input {
          if typeinfo.input.len() == 1 {
            value
          } else if typeinfo.output.first() == content {
            [#value]
          } else {
            (typeinfo.cast)(value)
          }
        } else if kind == "literal" and value == typeinfo.output.first() {
          value
        } else if (typeinfo.castable)(value) {
          (typeinfo.cast)(value)
        } else {
          types.force-cast(value, typeinfo, error-prefix: "field '" + pos-field.name + "' of element '" + name + "': ")
        }
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

      if not include-required and field.required {
        assert(false, message: "element '" + name + "': field '" + field-name + "' cannot be specified here\nhint: only optional fields are accepted here")
      }

      let typeinfo = field.typeinfo
      let kind = typeinfo.at(type-key)
      result.insert(
        field-name,
        if kind == "any" {
          value
        } else if kind == "native" and type(value) in typeinfo.input {
          if typeinfo.input.len() == 1 {
            value
          } else if typeinfo.output.first() == content {
            [#value]
          } else {
            (typeinfo.cast)(value)
          }
        } else if kind == "literal" and value == typeinfo.output.first() {
          value
        } else if (typeinfo.castable)(value) {
          (typeinfo.cast)(value)
        } else {
          types.force-cast(value, typeinfo, error-prefix: "field '" + field-name + "' of element '" + name + "': ")
        }
      )
    }

    if include-required {
      let missing-fields = required-named-fields.filter(f => f.name not in named-args)
      if missing-fields != () {
        let s = if missing-fields.len() == 1 { "" } else { "s" }

        assert(false, message: "element '" + name + "': missing required named field" + s + " " + missing-fields.map(f => "'" + f.name + "'").join(", "))
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

    // The current accumulated styles (overridden values for arguments) for the element.
    chain: (),
  )

  let modified-constructor(..args) = {
    let args = parse-args(args, include-required: true)
    context {
      let previous-bib-title = bibliography.title
      [#context {
        set bibliography(title: previous-bib-title)

        let data = if type(bibliography.title) == content and bibliography.title.func() == metadata and bibliography.title.at("label", default: none) == lbl-get { bibliography.title.value } else { (:) }
        let element-data = data.at(eid, default: default-data)

        let constructed-fields = default-fields + default-data.chain.sum(default: (:)) + args
        let body = constructor(constructed-fields)
        let tag = [#metadata((body: body, fields: constructed-fields, func: modified-constructor))]

        [#[#body#tag]#lbl-show]
      }#lbl-get]
    }
  }

  let set-rule(..args) = {
    let args = parse-args(args, include-required: false)
    doc => context {
      let previous-bib-title = bibliography.title
      [#context {
        let data = if type(bibliography.title) == content and bibliography.title.func() == metadata and bibliography.title.at("label", default: none) == lbl-get { bibliography.title.value } else { (:) }
        if eid in data {
          data.at(eid).chain.push(args)
        } else {
          data.insert(eid, (..default-data, chain: (args,)))
        }

        set bibliography(title: previous-bib-title)
        show lbl-get: set bibliography(title: [#metadata(data)#lbl-get])
        doc
      }#lbl-get]
    }
  }

  let get-rule(receiver) = context {
    let previous-bib-title = bibliography.title
    [#context {
      let data = if type(bibliography.title) == content and bibliography.title.func() == metadata and bibliography.title.at("label", default: none) == lbl-get { bibliography.title.value } else { (:) }

      set bibliography(title: previous-bib-title)
      receiver(
        data.at(eid, default: default-data).chain.sum(default: (:))
      )
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
        let data = if type(bibliography.title) == content and bibliography.title.func() == metadata and bibliography.title.at("label", default: none) == lbl-get { bibliography.title.value } else { (:) }
        let element-data = data.at(eid, default: default-data)

        // Amount of 'where rules' so far, so we can
        // assign a unique number to each query
        let rule-counter = element-data.where-rule-count
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

        if eid in data {
          data.at(eid).where-rule-count += 1
        } else {
          element-data.where-rule-count += 1
          data.insert(eid, element-data)
        }

        // Increase where rule counter for further where rules
        set bibliography(title: previous-bib-title)
        show lbl-get: set bibliography(title: [#metadata(data)#lbl-get])

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
