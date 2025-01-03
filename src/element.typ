#import "types/base.typ": custom-type-key, type-key
#import "types/types.typ"
#import "fields.typ" as field-internals

#let element-version = 1

// Prefix for the labels added to shown elements.
#let lbl-show-head = "__custom_element_shown_"

// Label for context blocks which have access to the virtual stylechain.
#let lbl-get = label("__custom_element_get")

// Label for metadata indicating an element's initial properties post-construction.
#let lbl-tag = label("__custom_element_tag")

// Label for metadata indicating a rule's parameters.
#let lbl-rule-tag = label("__custom_element_rule")

// Special dictionary key to indicate this is a prepared rule.
#let prepared-rule-key = "__prepared-rule"

#let element-key = "__custom_element"
#let element-data-key = "__custom_element_data"

#let sequence = [].func()

// Default per-element data.
#let default-data = (
  (element-data-key): true,

  version: element-version,

  // How many 'where rules' have been applied so far to this
  // element. This is needed as, for each 'where rule', we have
  // to apply a unique label to matching elements, so we increase
  // this 'counter' by one each time.
  where-rule-count: 0,

  // The current accumulated styles (overridden values for arguments) for the element.
  chain: (),

  // Maps each style in the chain to some data.
  // This is used to assign names to styles, so they can be revoked later.
  data-chain: (),

  // All known names, so we can be aware of invalid revoke rules.
  names: (:),

  // Revoked rules by name.
  revokes: (:),
)

// Convert a custom element into a dictionary with (body, fields, func),
// allowing you to access its fields and information when given content.
//
// When this is not a custom element, 'body' will be the given value,
// 'fields' will be 'body.fields()' and 'func' will be 'body.func()'
#let decompose(it) = {
  if type(it) != content {
    (body: it, fields: (:), func: none, eid: none)
  } else if (
    it.has("label")
    and str(it.label).starts-with(lbl-show-head)
  ) {
    // Decomposing an element inside a show rule
    it.children.at(1).value
  } else if it.func() == sequence and it.children != () {
    let last = it.children.last()
    if last.at("label", default: none) == lbl-tag {
      // Decomposing a recently-constructed (but not placed) element
      last.value
    } else {
      (body: it, fields: it.fields(), func: it.func(), eid: none)
    }
  } else {
    (body: it, fields: it.fields(), func: it.func(), eid: none)
  }
}

// Prepare rule(s), returning a function `doc => ...` to be used in
// `#show: rule`. The rule is attached as metadata to the returned
// content so it can still be accessed outside of a show rule.
#let prepare-rule(rule) = {
  let rules = if rule.kind == "apply" { rule.rules } else { (rule,) }

  doc => {
    let rule = rule
    let rules = rules

    // If there are two 'show:' in a row, flatten into a single set of rules
    // instead of running this function multiple times, reducing the
    // probability of accidental nested function limit errors.
    //
    // Note that all rules replace the document with
    // [#context { ... doc .. }#metadata(doc: doc, rule: rule)]
    // We get the second child to extract the original rule information.
    if [#doc].func() == sequence and doc.children.len() == 2 {
      let last = doc.children.last()
      if last.at("label", default: none) == lbl-rule-tag {
        let inner-rule = last.value.rule

        // Process all rules below us together with this one
        if inner-rule.kind == "apply" {
          rules += inner-rule.rules
        } else {
          rules.push(inner-rule)
        }

        // Convert this into an 'apply' rule
        rule = ((prepared-rule-key): true, version: element-version, kind: "apply", rules: rules)

        // Place what's inside, don't place the context block that would run our code again
        doc = last.value.doc
      }
    }

    // Inner must run later
    rules = rules.rev()
    {
      show lbl-get: it => {
        let data = if type(bibliography.title) == content and bibliography.title.func() == metadata and bibliography.title.at("label", default: none) == lbl-get { bibliography.title.value } else { (:) }

        for rule in rules {
          let (name, kind) = rule
          if kind == "set" {

            let (element, args) = rule
            let (eid, default-data) = element
            if eid in data {
              if name != none and name in data.at(eid).revokes {
                // Some inner, un-revoked rule is revoking us, abort.
                continue
              }

              // NOTE: This will insert in reverse
              // Each element will have to reverse later.
              data.at(eid).chain.push(args)
            } else {
              data.insert(eid, (..default-data, chain: (args,)))
            }

            if name != none {
              let element-data = data.at(eid)
              let index = element-data.chain.len() - 1

              // Lazily fill the data chain with 'none'
              data.at(eid).data-chain += (none,) * (element-data.data-chain.len() - index)
              data.at(eid).data-chain.push((kind: "set", name: rule.name))
              data.at(eid).names.insert(rule.name, true)
            }
          } else if kind == "revoke" {
            if name == none {
              for (eid, _) in data {
                // Can't revoke this revoke rule!
                data.at(eid).revokes.insert(rule.revoking, true)
              }
            } else {
              for (eid, _) in data {
                if name not in data.at(eid).revokes {
                  // Only revoke if this revoke rule wasn't, itself, revoked.
                  data.at(eid).revokes.insert(rule.revoking, true)
                }
              }
            }
          } else {
            assert(false, message: "element: invalid rule kind '" + rule.kind + "'")
          }
        }

        set bibliography(title: [#metadata(data)#lbl-get])
        it
      }
      doc
    }
    [#metadata((doc: doc, rule: rule))#lbl-rule-tag]
  }
}

// Apply a set rule to a custom element.
//
// USAGE:
// #show: set_(elem, fields)
//
// When applying many set rules at once, please use 'apply' instead.
#let set_(elem, ..fields) = {
  assert(type(elem) != function, message: "element.set_: specify the element's dictionary, not the constructor function (e.g. wibble-e, which contains 'func' and other properties, rather than the wibble function)")
  let args = (elem.parse-args)(fields, include-required: false)

  prepare-rule(
    ((prepared-rule-key): true, version: element-version, kind: "set", name: none, element: (eid: elem.eid, default-data: elem.default-data), args: args)
  )
}

// Apply multiple rules (set rules, etc.) at once.
//
// USAGE:
// #show: apply(
//   set_(elem, fields),
//   set_(elem, fields)
// )
#let apply(..args) = {
  assert(args.named() == (:), message: "element.apply: unexpected named arguments")
  let rules = args.pos().map(
    rule => {
      assert(type(rule) == function, message: "element.apply: invalid rule of type " + str(type(rule)) + ", please use 'set_' or some other function from this library to generate it")

      // Call it as if it we were in a show rule.
      // It will have some trailing metadata indicating its arguments.
      let inner = rule([])
      let rule-data = inner.children.last().value.rule

      if rule-data.kind == "apply" {
        // Flatten 'apply'
        rule-data.rules
      } else {
        (rule-data,)
      }
    }
  ).sum(default: ())

  prepare-rule(((prepared-rule-key): true, version: element-version, kind: "apply", rules: rules))
}

// Name a certain rule. Use 'apply' to name a group of rules.
#let named(name, rule) = {
  assert(type(name) == str, message: "element.named: rule name must be a string, not " + str(type(name)))
  assert(name != "", message: "element.named: name must not be empty")
  assert(type(rule) == function, message: "element.named: this is not a valid rule (not a function), please use functions such as 'set_' to create one.")

  let rule = rule([]).children.last().value.rule
  if rule.kind == "apply" {
    let i = 0
    while i < rule.rules.len() {
      let inner-rule = rule.rules.at(i)
      assert(inner-rule.kind == "set" or inner-rule.kind == "revoke", message: "element.named: can only name set and revoke rules at this moment, not '" + inner-rule.kind + "'\n  hint: move the 'named' call inside the 'apply', applying only to rules which can be named")

      rule.rules.at(i).insert("name", name)

      i += 1
    }
  } else {
    assert(rule.kind == "set" or rule.kind == "revoke", message: "element.named: can only name set and revoke rules at this moment, not '" + rule.kind + "'")
    rule.insert("name", name)
  }

  // Re-prepare the rule
  prepare-rule(rule)
}

// Revoke all rules with a certain name.
//
// USAGE:
//
// #show: named("name", set_(element, fields))
// #show: revoke("name")
#let revoke(name) = {
  assert(type(name) == str, message: "element.revoke: rule name must be a string, not " + str(type(name)))

  prepare-rule(((prepared-rule-key): true, version: element-version, kind: "revoke", revoking: name, name: none))
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
      let casted = value

      if kind != "any" {
        if kind == "literal" {
          if value != typeinfo.data {
            assert(false, message: "field '" + pos-field.name + "' of element '" + name + "': " + types.generate-cast-error(value, typeinfo))
          }
        } else {
          let value-type = type(value)
          if value-type == dictionary and custom-type-key in value {
            value-type = value.at(custom-type-key)
          }
          if (
            value-type not in typeinfo.input
            or typeinfo.check != none and not (typeinfo.check)(value)
          ) {
            assert(false, message: "field '" + pos-field.name + "' of element '" + name + "': " + types.generate-cast-error(value, typeinfo))
          }

          if typeinfo.cast != none {
            casted = if kind == "native" and typeinfo.data == content {
              [#value]
            } else {
              (typeinfo.cast)(value)
            }
          }
        }
      }

      result.insert(pos-field.name, casted)

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
      let casted = value

      if kind != "any" {
        if kind == "literal" {
          if value != typeinfo.data {
            assert(false, message: "field '" + field-name + "' of element '" + name + "': " + types.generate-cast-error(value, typeinfo))
          }
        } else {
          let value-type = type(value)
          if value-type == dictionary and custom-type-key in value {
            value-type = value.at(custom-type-key)
          }
          if (
            value-type not in typeinfo.input
            or typeinfo.check != none and not (typeinfo.check)(value)
          ) {
            assert(false, message: "field '" + field-name + "' of element '" + name + "': " + types.generate-cast-error(value, typeinfo))
          }

          if typeinfo.cast != none {
            casted = if kind == "native" and typeinfo.data == content {
              [#value]
            } else {
              (typeinfo.cast)(value)
            }
          }
        }
      }

      result.insert(field-name, casted)
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

  let modified-constructor(..args) = {
    let args = parse-args(args, include-required: true)
    let inner = context {
      let previous-bib-title = bibliography.title
      [#context {
        set bibliography(title: previous-bib-title)

        let data = if type(bibliography.title) == content and bibliography.title.func() == metadata and bibliography.title.at("label", default: none) == lbl-get { bibliography.title.value } else { (:) }
        let element-data = data.at(eid, default: default-data)

        // Data is appended in reverse order.
        // We don't need to handle revokes as this is done automatically as a
        // consequence.
        let chain = element-data.chain.rev()

        let constructed-fields = default-fields + chain.sum(default: (:)) + args

        let body = constructor(constructed-fields)
        let tag = [#metadata((body: body, fields: constructed-fields, func: modified-constructor, eid: eid))]

        [#[#body#tag]#lbl-show]
      }#lbl-get]
    }

    inner + [#metadata((body: inner, fields: args, func: modified-constructor, eid: eid))#lbl-tag]
  }

  let set-rule = set_.with((parse-args: parse-args, eid: eid, default-data: default-data))

  let get-rule(receiver) = context {
    let previous-bib-title = bibliography.title
    [#context {
      let data = if type(bibliography.title) == content and bibliography.title.func() == metadata and bibliography.title.at("label", default: none) == lbl-get { bibliography.title.value } else { (:) }

      let element-data = data.at(eid, default: default-data)

      // Data is appended in reverse order.
      let chain = element-data.chain.rev()

      set bibliography(title: previous-bib-title)
      receiver(
        default-fields + chain.sum(default: (:))
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
          let (fields,) = decompose(it)

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
      (element-key): true,
      version: 1,
      eid: eid,
      func: modified-constructor,
      set_: set-rule,
      get: get-rule,
      where: where-rule,
      sel: lbl-show,
      parse-args: parse-args,
      default-data: default-data,
      default-fields: default-fields,
      all-fields: all-fields,
    )
  )
}
