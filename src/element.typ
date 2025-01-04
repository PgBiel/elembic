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

#let lbl-stateful-mode = <__custom_element_stateful_mode>
#let lbl-light-mode = <__custom_element_light_mode>
#let lbl-normal-mode = <__custom_element_normal_mode>
#let lbl-auto-mode = <__custom_element_auto_mode>

// Special dictionary key to indicate this is a prepared rule.
#let prepared-rule-key = "__prepared-rule"

#let element-key = "__custom_element"
#let element-data-key = "__custom_element_data"
#let global-data-key = "__custom_element_global_data"

#let sequence = [].func()

// Potential modes for configuration of styles.
// This defines how we declare a set rule (or similar)
// within a certain scope.
#let style-modes = (
  // Normal mode: we store metadata in a bibliography.title set rule.
  //
  // Before doing so, we retrieve the original value for bibliography.title,
  // allowing us to restore it later. The effect is that the library is
  // fully hygienic, that is, the change to bibliography.title is not perceptible.
  //
  // The downside is that retrieving the original value for bibliography.title costs
  // an additional nested context { } call, of which there is a limit of 64. This means
  // that, in this mode, you can have up to 32 non-consecutive set rules.
  normal: 0,

  // Light mode: similar to normal mode, but we don't try to preserve the value of bibliography.title
  // after applying our changes to the document. This doubles the limit to up to 64 non-consecutive
  // set rules since we no longer have an extra step to retrieve the old value, but, as a downside,
  // we lose the original value of bibliography.title. While, in a future change, we might be able to
  // preserve the FIRST known value, we can't generally preserve its value at later points, so the
  // value of bibliography.title is effectively frozen before the first custom set rule.
  //
  // This mode should be used by package authors which know there won't be a bibliography (or, really,
  // any custom user input) at some point to avoid consuming the set rule cost. End users can also use
  // this mode if they hit a "max show rule depth exceeded" error.
  //
  // Note that this mode can only be enabled on individual set rules.
  light: 1,

  // Stateful mode: this is entirely different from the other modes and should only be set by the end
  // user (not by packages). This stores the style chain - and, thus, set rules' updated fields - in
  // a 'state()'. This is more likely to be slower and lead to trouble as it triggers at least one
  // document relayout. However, **this mode does not have a set rule limit.** Therefore, it can be
  // used as a last resort by the end user if they can't fix the "max show rule depth exceeded error".
  //
  // Enabling this mode is as simple as using `#show: e.stateful.toggle(true)` at the beginning of the
  // document. This will trigger a compatibility behavior where existing set rules will push to the
  // state, even if they're not in the stateful mode. It will also push existing set rule data into
  // the style 'state()'. Therefore, existing set rules are compatible with stateful mode, but this
  // only effectively fixes the error if the set rules are individually switched to stateful mode
  // with `e.stateful.set_` instead of `e.set_`.
  stateful: 2
)

// When on stateful mode, this state holds the sequence of 'data' for each scope.
// The last element on the list is the "current" data.
#let style-state = state("__custom_element_state", ())

// Default library-wide data.
#let default-global-data = (
  (global-data-key): true,

  // Keep track of versions in case we need some backwards-compatibility behavior
  // in the future.
  version: element-version,

  // If the style state should be read by set rules as the user has
  // enabled stateful mode with `#shoW: e.stateful.toggle(true)`.
  stateful: false,

  // Per-element data (set rules and other style chain info).
  elements: (:)
)

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

  // List of active revokes, of the form:
  // (index: last-chain-index, revoking: name-revoked, name: none / name of the revoke itself)
  revoke-chain: ()
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

// Changes stateful mode settings within a certain scope.
// This function will sync all data between all modes (data from normal mode
// goes to state and data from stateful mode goes to normal mode).
//
// Setting it to 'true' tells all set rules to update the state, and also ensures
// getters retrieve the value from the state, even if not explicitly aware of
// stateful mode.
//
// By default, this function will not trigger any changes if one attempts to
// change the stateful mode to its current value. This behavior can be disabled
// with 'force: true', though that is not expected to make a difference in any way.
#let toggle-stateful-mode(enable, force: false) = doc => {
  context {
    let previous-bib-title = bibliography.title
    [#context {
      let data = if (
        type(bibliography.title) == content
        and bibliography.title.func() == metadata
        and bibliography.title.at("label", default: none) == lbl-get
      ) {
        bibliography.title.value
      } else {
        default-global-data
      }

      set bibliography(title: previous-bib-title)

      if data.stateful != enable or force {
        if not enable {
          // Enabling stateful mode => use data from the style chain
          //
          // Disabling stateful mode => need to sync stateful with non-stateful,
          // so we use data from the state
          let chain = style-state.get()
          data = if chain == () {
            default-global-data
          } else {
            chain.last()
          }
        }

        // Notify both modes about it (non-stateful and stateful)
        data.stateful = enable

        let (show-normal, show-light, show-stateful) = if enable {
          // TODO: Have a way to keep track of previous toggles and undo them
          (none, none, it => it.value.body)
        } else {
          (it => it.value.body, none, none)
        }

        show lbl-auto-mode: none
        show lbl-normal-mode: show-normal
        show lbl-light-mode: show-light
        show lbl-stateful-mode: show-stateful

        // Sync data with style chain for non-stateful modes
        show lbl-get: set bibliography(title: [#metadata(data)#lbl-get])

        // Sync data with state for stateful mode
        // Push at the start of the scope, pop at the end
        [#style-state.update(chain => {
          chain.push(data)
          chain
        })#doc#style-state.update(chain => {
          _ = chain.pop()
          chain
        })]
      } else {
        // Nothing to do: it is already toggled to this value
        doc
      }
    }#lbl-get]
  }
}

// Apply set and revoke rules to the current per-element data.
#let apply-rules(data, rules) = {
  for rule in rules {
    let kind = rule.kind
    if kind == "set" {
      let (element, args) = rule
      let (eid, default-data) = element
      if eid in data {
        data.at(eid).chain.push(args)
      } else {
        data.insert(eid, (..default-data, chain: (args,)))
      }

      if rule.name != none {
        let element-data = data.at(eid)
        let index = element-data.chain.len() - 1

        // Lazily fill the data chain with 'none'
        data.at(eid).data-chain += (none,) * (index - element-data.data-chain.len())
        data.at(eid).data-chain.push((kind: "set", name: rule.name))
        data.at(eid).names.insert(rule.name, true)
      }
    } else if kind == "revoke" {
      for (name, _) in data {
        // Can only revoke what's before us.
        // If this element has no rules with this name, there is nothing to revoke;
        // we shouldn't revoke names that come after us (inner rules).
        // Note that this potentially includes named revokes as well.
        if rule.revoking in data.at(name).names {
          data.at(name).revoke-chain.push((name: none, index: data.at(name).chain.len(), revoking: rule.revoking))
        }
      }
    } else {
      assert(false, message: "element: invalid rule kind '" + rule.kind + "'")
    }
  }

  data
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
          // Note: apply should automatically distribute modes across its children,
          // so it's okay if we don't inherit its own mode here.
          rules += inner-rule.rules
        } else {
          rules.push(inner-rule)
        }

        // Convert this into an 'apply' rule
        rule = ((prepared-rule-key): true, version: element-version, kind: "apply", rules: rules, mode: auto)

        // Place what's inside, don't place the context block that would run our code again
        doc = last.value.doc
      }
    }

    let mode = if rule.mode != auto {
      // This is more of an optimization, but, to prevent problems when flattening
      // 'apply', we expect it to automatically pass its mode to its children.
      rule.mode
    } else {
      rules.fold(auto, (mode, rule) => {
        if (
          rule.mode == style-modes.stateful
          or mode != style-modes.stateful and rule.mode == style-modes.light
          or mode != auto
        ) {
          // Prioritize more explicit modes:
          // stateful > light > normal
          rule.mode
        } else {
          mode
        }
      })
    }

    // Stateful mode: no context, just push in a state at the start of the scope
    // and pop to previous data at the end.
    let stateful = {
      style-state.update(chain => {
        let data = if chain == () {
          default-global-data
        } else {
          chain.last()
        }

        data.elements = apply-rules(data.elements, rules)

        chain.push(data)
        chain
      })
      doc
      style-state.update(chain => {
        _ = chain.pop()
        chain
      })
    }

    // Normal mode: two nested contexts: one retrieves the current bibliography title,
    // and the other retrieves the title with metadata and restores the current title.
    let normal = context {
      let previous-bib-title = bibliography.title
      [#context {
        let data = if (
          type(bibliography.title) == content
          and bibliography.title.func() == metadata
          and bibliography.title.at("label", default: none) == lbl-get
        ) {
          bibliography.title.value
        } else {
          default-global-data
        }

        if data.stateful {
          if mode == auto {
            // User chose something else.
            // Don't even place anything.
            return none
          } else {
            // Use state instead!
            return {
              set bibliography(title: previous-bib-title)
              stateful
            }
          }
        }

        // TODO: Read from and update to state in global stateful mode.
        data.elements = apply-rules(data.elements, rules)

        set bibliography(title: previous-bib-title)
        show lbl-get: set bibliography(title: [#metadata(data)#lbl-get])
        doc
      }#lbl-get]
    }

    // Light mode: only one context, but bibliography title is permanently clobbered.
    // TODO: Save the old value.
    let light = (
      [#context {
        let data = if (
          type(bibliography.title) == content
          and bibliography.title.func() == metadata
          and bibliography.title.at("label", default: none) == lbl-get
        ) {
          bibliography.title.value
        } else {
          default-global-data
        }

        if data.stateful {
          if mode == auto {
            // User chose something else.
            // Don't even place anything.
            return none
          } else {
            // Use state instead!
            return {
              set bibliography(title: auto)
              stateful
            }
          }
        }

        // TODO: Read from and update to state in global stateful mode.
        data.elements = apply-rules(data.elements, rules)

        // TODO: keep track of first seen bibliography title
        set bibliography(title: auto)
        show lbl-get: set bibliography(title: [#metadata(data)#lbl-get])
        doc
      }#lbl-get]
    )

    let body = if mode == auto {
      // Allow user to pick the mode through show rules.
      [#metadata((body: stateful))#lbl-stateful-mode]
      [#metadata((body: light))#lbl-light-mode]
      [#metadata((body: normal))#lbl-normal-mode]
      [#normal#lbl-auto-mode]
    } else if mode == style-modes.normal {
      normal
    } else if mode == style-modes.light {
      light
    } else if mode == style-modes.stateful {
      stateful
    }

    // Add the rule tag after each rule application.
    // This allows extracting information about the rule before it is applied.
    // It also allows combining the rule with an outer rule before application,
    // as we do earlier.
    [#body#metadata((doc: doc, rule: rule))#lbl-rule-tag]
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
    ((prepared-rule-key): true, version: element-version, kind: "set", name: none, mode: auto, element: (eid: elem.eid, default-data: elem.default-data), args: args)
  )
}

// Apply multiple rules (set rules, etc.) at once.
//
// USAGE:
// #show: apply(
//   set_(elem, fields),
//   set_(elem, fields)
// )
#let apply(mode: auto, ..args) = {
  assert(args.named() == (:), message: "element.apply: unexpected named arguments")
  assert(mode == auto or mode == style-modes.normal or mode == style-modes.light or mode == style-modes.stateful, message: "element.apply: invalid mode, must be auto or e.style-modes.(normal / light / stateful)")

  let rules = args.pos().map(
    rule => {
      assert(type(rule) == function, message: "element.apply: invalid rule of type " + str(type(rule)) + ", please use 'set_' or some other function from this library to generate it")

      // Call it as if it we were in a show rule.
      // It will have some trailing metadata indicating its arguments.
      let inner = rule([])
      let rule-data = inner.children.last().value.rule

      if rule-data.kind == "apply" {
        // Flatten 'apply'
        if mode == auto {
          // Don't touch its own rules
          rule-data.rules
        } else {
          // Override rule modes
          rule-data.rules.map(r => { if r.mode != mode { r.mode = mode }; r })
        }
      } else if mode == auto or rule-data.mode == mode {
        (rule-data,)
      } else {
        // Forcefully change children's modes if requested
        rule-data.mode = mode
        (rule-data,)
      }
    }
  ).sum(default: ())

  // Set this apply rule's mode as an optimization, but note that we have forcefully altered
  // its children's modes above.
  prepare-rule(((prepared-rule-key): true, version: element-version, kind: "apply", rules: rules, mode: mode))
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
      assert(inner-rule.kind == "set", message: "element.named: can only name set rules at this moment, not '" + inner-rule.kind + "'")

      rule.rules.at(i).insert("name", name)

      i += 1
    }
  } else {
    assert(rule.kind == "set", message: "element.named: can only name set rules at this moment, not '" + rule.kind + "'")
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
#let revoke(name, mode: auto) = {
  assert(type(name) == str, message: "element.revoke: rule name must be a string, not " + str(type(name)))
  assert(mode == auto or mode == style-modes.normal or mode == style-modes.light or mode == style-modes.stateful, message: "element.revoke: invalid mode, must be auto or e.style-modes.(normal / light / stateful)")

  prepare-rule(((prepared-rule-key): true, version: element-version, kind: "revoke", revoking: name, name: none, mode: mode))
}

// Stateful variants
#let stateful-set(..args) = {
  apply(set_(..args), mode: style-modes.stateful)
}
#let stateful-apply(..args) = {
  apply(..args, mode: style-modes.stateful)
}
#let stateful-revoke(..args) = {
  revoke(..args, mode: style-modes.stateful)
}

// Apply revokes and other modifications to the chain and generate a final set
// of fields.
#let fold-chain(chain, data-chain, revoke-chain) = {
  // Map name -> up to which index (exclusive) it is revoked.
  //
  // Importantly, a revoke at index B will apply to
  // all rules with the revoked name before that index.
  // If that revoke rule is, itself, revoked, that either
  // completely eliminates the name from being revoked,
  // or it simply leads the name to be revoked up to
  // an index A < B. That, or it was also being revoked
  // by another unrevoked revoke rule at index C > B,
  // in which case the name is still revoked up to C.
  // In all cases, the name is always revoked from the
  // start until some end index. Otherwise, it isn't
  // revoked at all (end index 0).
  let active-revokes = (:)

  // Revoke revoked revokes by analyzing revokes in reverse
  // order: a revoke that came later always takes priority.
  for revoke in revoke-chain.rev() {
    // This revoke will revoke rules named 'revoking' up to 'index' in the chain, which
    // automatically revokes revoke rules before it as well, since they were added when
    // the chain length was smaller (or the same), and 'index' is always the chain length
    // at the moment the revoke rule was added.
    //
    // We don't explicitly add revoke rules to the chain as their order in the revoke-chain
    // list is enough to know which revoke rules can revoke others, and the index indicates
    // which set rules are revoked.
    //
    // Regarding the first part of the AND, note that, if a name is already revoked up to
    // index C from a later revoke (since we're going in reverse, so this one appears earlier
    // than the previous ones), then revoking it up to index B <= C for this revoke is
    // unnecessary since the index interval [0, B) is already contained in [0, C).
    //
    // In other words, only the last revoke for a particular name matters, which is the
    // first one we find in this loop.
    //
    // (As you can see, we assume above that, if revoke 1 comes before revoke 2 in the revoke-chain
    // (before reversing), with revoke 1 applying up to chain index B and revoke 2 up to index C,
    // then B <= C. This is enforced in 'prepare-rules' as we analyze revokes and push their
    // information to the chain in order (outer to inner / earlier to later).)
    if revoke.revoking not in active-revokes and (revoke.name == none or revoke.name not in active-revokes) {
      active-revokes.insert(revoke.revoking, revoke.index)
    }
  }

  // Use map to filter and transform at the same time before joining.
  chain
    .enumerate()
    .map(((i, c)) => {
      let data = data-chain.at(i, default: none)
      if data == none or data.name not in active-revokes or i >= active-revokes.at(data.name) {
        c
      } else {
        // Nullify changes at this stage
        (:)
      }
    })
    .sum(default: (:))
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

        let data = if (
          type(bibliography.title) == content
          and bibliography.title.func() == metadata
          and bibliography.title.at("label", default: none) == lbl-get
        ) {
          bibliography.title.value
        } else {
          default-global-data
        }

        if data.stateful {
          let chain = style-state.get()
          data = if chain == () {
            default-global-data
          } else {
            chain.last()
          }
        }

        let element-data = data.elements.at(eid, default: default-data)

        let folded-chain = if element-data.revoke-chain == default-data.revoke-chain {
          // Sum the chain of dictionaries so that the latest value specified for
          // each property wins.
          element-data.chain.sum(default: (:))
        } else {
          // We can't just sum, we need to filter first.
          // Memoize this operation through a function.
          fold-chain(element-data.chain, element-data.data-chain, element-data.revoke-chain)
        }

        let constructed-fields = default-fields + folded-chain + args

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
      let data = if (
        type(bibliography.title) == content
        and bibliography.title.func() == metadata
        and bibliography.title.at("label", default: none) == lbl-get
      ) {
        bibliography.title.value
      } else {
        default-global-data
      }

      if data.stateful {
        let chain = style-state.get()
        data = if chain == () {
          default-global-data
        } else {
          chain.last()
        }
      }

      let element-data = data.elements.at(eid, default: default-data)
      let folded-chain = if element-data.revoke-chain == default-data.revoke-chain {
        element-data.chain.sum(default: (:))
      } else {
        fold-chain(element-data.chain, element-data.data-chain, element-data.revoke-chain)
      }

      set bibliography(title: previous-bib-title)
      receiver(
        default-fields + folded-chain
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
        let data = if (
          type(bibliography.title) == content
          and bibliography.title.func() == metadata
          and bibliography.title.at("label", default: none) == lbl-get
        ) {
          bibliography.title.value
        } else {
          default-global-data
        }

        if data.stateful {
          panic("TODO")
        }

        let element-data = data.elements.at(eid, default: default-data)

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
          data.elements.at(eid).where-rule-count += 1
        } else {
          element-data.where-rule-count += 1
          data.elements.insert(eid, element-data)
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
      default-global-data: default-global-data,
      default-fields: default-fields,
      all-fields: all-fields,
    )
  )
}
