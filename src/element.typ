#import "types/base.typ" as base: custom-type-key, custom-type-data-key, type-key, special-data-values
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
#let lbl-normal-mode = <__custom_element_normal_mode>
#let lbl-auto-mode = <__custom_element_auto_mode>

// Special dictionary key to indicate this is a prepared rule.
#let prepared-rule-key = "__prepared-rule"

#let element-key = "__custom_element"
#let element-data-key = "__custom_element_data"
#let global-data-key = "__custom_element_global_data"

// Basic elements for our document tree analysis
#let sequence = [].func()
#let space = [ ].func()
#let styled = { set text(red); [a] }.func()
#let state-update-func = state(".").update(1).func()
#let counter-update-func = counter(".").update(1).func()

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

  // leaky mode: similar to normal mode, but we don't try to preserve the value of bibliography.title
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
  leaky: 1,

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

  // First known bib title.
  // This is used by leaky mode to attempt to preserve the correct bibliography.title
  // property. Evidently, it's not perfect, and leaky mode should be avoided.
  first-bib-title: (),

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

  // Chain for foldable fields, that is, fields which have special behavior
  // when changed through more than one set rule. By default, specifying the
  // same field in two subsequent set rules will have the innermost set rule
  // override the value from the previous one, but this can be overridden
  // for certain types where it makes sense to combine the two values in
  // some way instead. For example, stroke fields have custom folding: if
  // you specify 4pt for a stroke field in one set rule and orange in another,
  // the final stroke will be 4pt + orange, not orange.
  //
  // This data structure has an entry for each changed foldable field, laid out as follows:
  // (
  //   foldable-field-name: (
  //     folder: auto or (outer, inner) => combined value  // how to combine two values, auto = simple sum, equivalent to (a, b) => a + b
  //     default: stroke(),  // default value for this field to begin folding. This is 'field.default' unless 'required = true'.
  //                         // Then, it is the type's default.
  //     values: (4pt, orange, ...)  // list of all set values for this field (length = amount of times this field was changed)
  //                                 // only 'values' is used if possible, for efficiency. E.g.: values.sum(default: stroke())
  //     data: (                                   // list to associate each value with the real style chain index and name.
  //       (index: 3, name: none, value: 4pt),     // If 'revoke' or 'reset' are used, this list is used instead
  //       (index: 5, name: none, value: orange),  // so we can know which values were revoked.
  //       ...
  //     )
  //   ),
  //   ...
  // )
  //
  // The final argument passed to the constructor, if any, also has to be folded with the latest folded value,
  // or with the field's default value if nothing was changed. However, that step is done separately. So, if
  // no set rules change a particular foldable field, it is not present in this dictionary at all.
  fold-chain: (:),

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

// Extract data from an element's constructor, as well as convert
// a custom element instance into a dictionary with (body, fields, func),
// allowing you to access its fields and information when given content.
//
// When this is not a custom element, 'body' will be the given value,
// 'fields' will be 'body.fields()' and 'func' will be 'body.func()'
#let data(it) = {
  if type(it) == function {
    it(__elemmic_data: special-data-values.get-data)
  } else if type(it) == dictionary and element-key in it {
    (data-kind: "element", ..it)
  } else if type(it) == dictionary and custom-type-data-key in it {
    (data-kind: "custom-type-data", ..it)
  } else if type(it) != content {
    (data-kind: "unknown", body: it, fields: (:), func: none, eid: none, fields-known: false, valid: false)
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
      (data-kind: "content", body: it, fields: it.fields(), func: it.func(), eid: none, fields-known: false, valid: false)
    }
  } else {
    (data-kind: "content", body: it, fields: it.fields(), func: it.func(), eid: none, fields-known: false, valid: false)
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
      let (global-data, was-first-bib-title) = if (
        type(bibliography.title) == content
        and bibliography.title.func() == metadata
        and bibliography.title.at("label", default: none) == lbl-get
      ) {
        (bibliography.title.value, false)
      } else {
        ((..default-global-data, first-bib-title: previous-bib-title), true)
      }

      set bibliography(title: previous-bib-title)

      if global-data.stateful != enable or force {
        if not enable {
          // Enabling stateful mode => use data from the style chain
          //
          // Disabling stateful mode => need to sync stateful with non-stateful,
          // so we use data from the state
          let chain = style-state.get()
          global-data = if chain == () {
            default-global-data
          } else {
            chain.last()
          }

          // Store the first known bib title in the state as well
          if global-data.first-bib-title == () and was-first-bib-title {
            global-data.first-bib-title = previous-bib-title
          }
        }

        // Notify both modes about it (non-stateful and stateful)
        global-data.stateful = enable

        let (show-normal, show-stateful) = if enable {
          // TODO: Have a way to keep track of previous toggles and undo them
          (none, it => it.value.body)
        } else {
          (it => it.value.body, none)
        }

        show lbl-auto-mode: none
        show lbl-normal-mode: show-normal
        show lbl-stateful-mode: show-stateful

        // Sync data with style chain for non-stateful modes
        show lbl-get: set bibliography(title: [#metadata(global-data)#lbl-get])

        // Sync data with state for stateful mode
        // Push at the start of the scope, pop at the end
        [#style-state.update(chain => {
          chain.push(global-data)
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
      let (eid, default-data, fields) = element
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

      if fields.foldable-fields != (:) and args.keys().any(n => n in fields.foldable-fields) {
        // A foldable field was specified in this set rule, so we need to record the fold
        // data in the corresponding data structures separately for later.
        let element-data = data.at(eid)
        let index = element-data.chain.len() - 1
        for (field-name, fold-data) in fields.foldable-fields {
          if field-name in args {
            let value = args.at(field-name)
            let value-data = (index: index, name: rule.name, value: value)
            if field-name in element-data.fold-chain {
              data.at(eid).fold-chain.at(field-name).values.push(value)
              data.at(eid).fold-chain.at(field-name).data.push(value-data)
            } else {
              data.at(eid).fold-chain.insert(
                field-name,
                (
                  folder: fold-data.folder,
                  default: fold-data.default,
                  values: (value,),
                  data: (value-data,)
                )
              )
            }
          }
        }
      }
    } else if kind == "revoke" {
      for (name, _) in data {
        // Can only revoke what's before us.
        // If this element has no rules with this name, there is nothing to revoke;
        // we shouldn't revoke names that come after us (inner rules).
        // Note that this potentially includes named revokes as well.
        if rule.revoking in data.at(name).names {
          data.at(name).revoke-chain.push((kind: "revoke", name: rule.name, index: data.at(name).chain.len(), revoking: rule.revoking))

          if rule.name != none {
            data.at(name).names.insert(rule.name, true)
          }
        }
      }
    } else if kind == "reset" {
      // Whether the list of elements that this reset applies to is restricted.
      let filtering = rule.eids != ()
      for (name, element-data) in data {
        // Can only revoke what's before us.
        // If this element has no rules, no need to add a reset.
        if (not filtering or name in rule.eids) and element-data.chain != () {
          data.at(name).revoke-chain.push((kind: "reset", name: rule.name, index: element-data.chain.len()))

          if rule.name != none {
            data.at(name).names.insert(rule.name, true)
          }
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
//
// This is where we execute our main machinery to apply rules to the
// document, that is, modifications to the global data of custom
// elements. This is done in different ways depending on the mode:
//
// - In normal mode, we create 'get rule' points by annotating
// context blocks with `#lbl-get`. Any modifications to the global
// data are stored as 'set bibliography(title: metadata with data)'
// scoped to context blocks with that label. Therefore, we can access
// the data by retrieving bibliography.title inside those blocks.
//
// The downside is that the entire document is wrapped in context,
// so 'max show rule depth exceeded' errors can occur.
//
// - In leaky mode, it is similar, but we reset bibliography.title
// to an arbitrary value instead of having two context blocks to
// ensure it remains unchanged.
//
// - In stateful mode, we don't wrap anything around the document,
// removing the 'max show rule depth exceeded' problem. Rather, we
// place a state update at the start and another at the end of the
// scope, respectively updating the global data and then undoing
// the update, ensuring it only applies to that scope.
//
// The downside is that this uses 'state()', which can lead to
// relayouts (slower) and even diverging layout.
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
    // [#context { ... doc .. }[#metadata(doc: doc, rule: rule)#lbl-rule-tag]]
    // We get the second child to extract the original rule information.
    // If 'doc' has the form above, this means the user wrote
    // #show: rule1
    // #show: rule2
    // which we want to unify. So we check children len == 2 and unify if the tag is there.
    //
    // But we also want to accept some parbreaks before, i.e.
    //
    // #show: rule1
    //
    // #show: rule2
    //
    // This generates a doc of the form
    // [#parbreak()[#context { ... doc .. }[#metadata(doc: doc, rule: rule)#lbl-rule-tag]]]
    // So we also check for children len >= 2 (although == 2 is enough in that case) and
    // strip any leading parbreaks / spaces / linebreaks, moving them to the new 'doc' (they
    // now receive the rules, which is technically incorrect, but in practice is only a problem
    // if you have a show rule on parbreak or space or something, which is odd).
    //
    // Note also that
    // #show: rule1
    //
    // // hello world!
    // // hello world!
    // // hello world!
    //
    // #show: rule2
    //
    // produces
    // [#parbreak()#space()#space()#parbreak()[... rule substructure with metadata... ]]
    // which makes the need for stripping multiple kinds of whitespace explicit.
    // We limit at 100 to prevent unbounded search.
    //
    // We also need to consider the case with
    // #show: rule1
    // #set native(field: value)
    // #show: rule2
    //
    // in which case the document structure (from rule1's view) is
    //
    // styled(child: [... rule2 ...], styles: ..)
    //
    // Worse, there could be parbreaks around the set rule:
    //
    // #show: rule1
    //
    // #set native(field: value)
    //
    // #show: rule2
    //
    // leading to
    //
    // sequence(parbreak(), styled(child: sequence(parbreak(), [ ... rule2 ... ]), styles: ..))
    //
    // so we need to perform a document tree walk to lift rule2 and transform this into
    //
    // #show: apply(
    //   rule1
    //   rule2
    // )
    //
    // #set native(field: value)
    // ...
    //
    // Tree walk is performed as follows:
    //
    // this rule
    //   \
    //   sequence
    //      \ space  parbreak ... sequence
    //                              \ space parbreak ... styled (styles = S)
    //                                                       \ sequence
    //                                                             \ space parbreak ... inner rule!
    //                                                                                    \ (rule.doc, rule.rule)
    // We store each tree level in 'wrappers' so we can reconstruct this document structure without 'rule!'.
    // In the case above, that would correspond to
    // wrappers = ((sequence, (space, parbreak, ...)), (sequence, space, parbreak, ...), (styled, S), (sequence, space, parbreak, ...))
    // and 'rule' would become 'potential-doc'.
    //
    // We would then wrap 'rule.doc' in reverse order, adding after the sequence prefix or
    // making it the styled child, producing
    //
    // this rule + inner rule
    //   \
    //   (sequence,     apply(this rule, inner rule))
    //      \ space  parbreak ... sequence
    //                              \ space parbreak ... styled (styles = S)
    //                                                       \ sequence
    //                                                             \ space parbreak ... rule.doc
    //
    // as desired. That is, we move the inner rule up into this rule in order to only consume 1 from
    // the rule limit, which is valid since the rule won't apply to spaces, parbreaks, and styled.
    // Of course, there could be show rules towards a different structure, but we assume that the user
    // understands that show rules on spacing may cause unexpected behavior.
    let potential-doc = [#doc]
    let wrappers = ()
    let max-depth = 100
    // Acceptable content types for set rule lifting.
    // These are content types that are leaves and we usually don't expect them to
    // be replaced in a show rule by an actual custom element.
    // If we find something that isn't here, e.g. a block, we stop searching as we can't lift any further rules.
    // We also exclude anything with a label since that indicates there might be a show rule application incoming.
    let whitespace-funcs = (parbreak, space, linebreak, h, v, state-update-func, counter-update-func)
    // Content types we can peek at.
    let recursing-funcs = (styled, sequence)
    let loop-prefix = none
    let loop-children = ()
    let loop-last = none

    while true {
      // Child is #{
      //    set something(abc: def)
      //    show something: else
      //    [some stuff]
      // }
      if potential-doc.func() == styled {
        max-depth -= 1
        wrappers.push((styled, potential-doc.styles))

        // 'Recursively' check the child
        potential-doc = [#potential-doc.child]
      } else if (
        // Child is #[
        //   (parbreak)
        //   (space)
        //   #[ sequence, rule or more styles ]
        // ]
        potential-doc.func() == sequence
        and { loop-children = potential-doc.children; loop-children.len() >= 2 }  // something like 'if let Sequence(children) = potential-doc { ... }'
        and { loop-last = loop-children.last(); loop-last.func() in recursing-funcs }
        and max-depth - loop-children.len() > 0
        and {
          loop-prefix = loop-children.slice(0, -1);
          loop-prefix.all(t => (t.func() in whitespace-funcs or t == []) and t.at("label", default: none) == none)
        }
      ) {
        max-depth -= loop-children.len()
        wrappers.push((sequence, loop-prefix))

        // 'Recursively' check the last child
        potential-doc = loop-last
      } else {
        break
      }
    }

    // Merge with the closest rule application below us, "moving" it upwards
    // and reducing the rule count by 1
    if (
      potential-doc.func() == sequence
      and potential-doc.children.len() == 2
      and potential-doc.children.last().at("label", default: none) == lbl-rule-tag
    ) {
      let last = potential-doc.children.last()
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

      // Reconstruct the document structure.
      // Must be in reverse (innermost wrapper to outermost).
      for (func, data) in wrappers.rev() {
        if func == styled {
          doc = styled(doc, data)
        } else {
          // (sequence, prefix)
          // Re-add stripped whitespace and stuff
          doc = data.join() + doc
        }
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
          or mode != style-modes.stateful and rule.mode == style-modes.leaky
          or mode != auto
        ) {
          // Prioritize more explicit modes:
          // stateful > leaky > normal
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
        let global-data = if chain == () {
          default-global-data
        } else {
          chain.last()
        }

        assert(
          global-data.stateful,
          message: "element rule: cannot use a stateful rule without enabling the global stateful toggle\n  hint: write '#show: e.stateful.toggle(true)' somewhere above this rule, or at the top of the document to apply to all"
        )

        global-data.elements = apply-rules(global-data.elements, rules)

        chain.push(global-data)
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
        let global-data = if (
          type(bibliography.title) == content
          and bibliography.title.func() == metadata
          and bibliography.title.at("label", default: none) == lbl-get
        ) {
          bibliography.title.value
        } else {
          (..default-global-data, first-bib-title: previous-bib-title)
        }

        if global-data.stateful {
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

        global-data.elements = apply-rules(global-data.elements, rules)

        set bibliography(title: previous-bib-title)
        show lbl-get: set bibliography(title: [#metadata(global-data)#lbl-get])
        doc
      }#lbl-get]
    }

    let body = if mode == auto {
      // Allow user to pick the mode through show rules.
      // Note: picking leaky mode has no effect on show rule depth, so we don't allow choosing
      // it globally. For it to make a difference, it must be explicitly chosen.
      [#metadata((body: stateful))#lbl-stateful-mode]
      [#metadata((body: normal))#lbl-normal-mode]
      [#normal#lbl-auto-mode]
    } else if mode == style-modes.normal {
      normal
    } else if mode == style-modes.leaky {
      [#context {
        let global-data = if (
          type(bibliography.title) == content
          and bibliography.title.func() == metadata
          and bibliography.title.at("label", default: none) == lbl-get
        ) {
          bibliography.title.value
        } else {
          // Bibliography title wasn't overridden, so we can use it
          (..default-global-data, first-bib-title: bibliography.title)
        }

        let first-bib-title = global-data.first-bib-title
        if first-bib-title == () {
          // Nobody has seen the bibliography title (bug?)
          first-bib-title = auto
        }

        if global-data.stateful {
          if mode == auto {
            // User chose something else.
            // Don't even place anything.
            return none
          } else {
            // Use state instead!
            return {
              set bibliography(title: first-bib-title)
              stateful
            }
          }
        }

        global-data.elements = apply-rules(global-data.elements, rules)

        set bibliography(title: first-bib-title)
        show lbl-get: set bibliography(title: [#metadata(global-data)#lbl-get])
        doc
      }#lbl-get]
    } else if mode == style-modes.stateful {
      stateful
    } else {
      panic("element rule: unknown mode: " + repr(mode))
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
  if type(elem) == function {
    elem = data(elem)
  }
  assert(type(elem) == dictionary, message: "element.set_: please specify the element's constructor or data in the first parameter")
  let args = (elem.parse-args)(fields, include-required: false)

  prepare-rule(
    ((prepared-rule-key): true, version: element-version, kind: "set", name: none, mode: auto, element: (eid: elem.eid, default-data: elem.default-data, fields: elem.fields), args: args)
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
  assert(mode == auto or mode == style-modes.normal or mode == style-modes.leaky or mode == style-modes.stateful, message: "element.apply: invalid mode, must be auto or e.style-modes.(normal / leaky / stateful)")

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
      assert(inner-rule.kind in ("set", "revoke", "reset"), message: "element.named: can only name set, revoke and reset rules at this moment, not '" + inner-rule.kind + "'")

      rule.rules.at(i).insert("name", name)

      i += 1
    }
  } else {
    assert(rule.kind in ("set", "revoke", "reset"), message: "element.named: can only name set, revoke and reset rules at this moment, not '" + rule.kind + "'")
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
  assert(mode == auto or mode == style-modes.normal or mode == style-modes.leaky or mode == style-modes.stateful, message: "element.revoke: invalid mode, must be auto or e.style-modes.(normal / leaky / stateful)")

  prepare-rule(((prepared-rule-key): true, version: element-version, kind: "revoke", revoking: name, name: none, mode: mode))
}

// Revoke all rules for certain elements (or even all elements).
//
// USAGE:
//
// #show: set_(element, fields)
// #show: reset(element)
// (Rules no longer apply here)
#let reset(..args, mode: auto) = {
  assert(args.named() == (:), message: "element.reset: unexpected named arguments")
  assert(mode == auto or mode == style-modes.normal or mode == style-modes.leaky or mode == style-modes.stateful, message: "element.reset: invalid mode, must be auto or e.style-modes.(normal / leaky / stateful)")

  let filters = args.pos().map(it => if type(it) == function { data(it) } else { x })
  assert(filters.all(x => type(x) == dictionary and "eid" in x), message: "element.reset: invalid arguments, please provide a function or element data with at least an 'eid'")

  prepare-rule(((prepared-rule-key): true, version: element-version, kind: "reset", eids: filters.map(x => x.eid), name: none, mode: mode))
}

// Stateful variants
#let stateful-set(..args) = {
  apply(set_(..args), mode: style-modes.stateful)
}
#let stateful-apply = apply.with(mode: style-modes.stateful)
#let stateful-revoke = revoke.with(mode: style-modes.stateful)
#let stateful-reset = reset.with(mode: style-modes.stateful)

// Leaky variants
#let leaky-set(..args) = {
  apply(set_(..args), mode: style-modes.leaky)
}
#let leaky-apply = apply.with(mode: style-modes.leaky)
#let leaky-revoke = revoke.with(mode: style-modes.leaky)
#let leaky-reset = reset.with(mode: style-modes.leaky)

// Apply revokes and other modifications to the chain and generate a final set
// of fields.
#let fold-styles(chain, data-chain, revoke-chain, fold-chain) = {
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

  let first-active-index = 0

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
    if revoke.kind == "revoke" and revoke.revoking not in active-revokes and (revoke.name == none or revoke.name not in active-revokes) {
      active-revokes.insert(revoke.revoking, revoke.index)
    } else if revoke.kind == "reset" and (revoke.name == none or revoke.name not in active-revokes) {
      // Applying a reset, so we delete everything before this index and stop revoking since
      // any revokes before this reset won't count anymore.
      first-active-index = revoke.index

      chain = if chain.len() <= first-active-index {
        ()
      } else {
        chain.slice(first-active-index)
      }

      data-chain = if data-chain.len() <= first-active-index {
        ()
      } else {
        data-chain.slice(first-active-index)
      }

      for (field-name, fold-data) in fold-chain {
        let first-fold-index = fold-data.data.position(d => d.index >= first-active-index)
        if first-fold-index == none {
          // All folded values removed.
          // The caller will be responsible for joining the default value with the
          // final arguments (without any chain values inbetween) if that's necessary.
          _ = fold-chain.remove(field-name)
        } else {
          fold-chain.at(field-name).values = fold-data.values.slice(first-fold-index)
          fold-chain.at(field-name).data = fold-data.data.slice(first-fold-index)
        }
      }

      // No need to analyze any further revoke rules since everything was reset.
      break
    }
  }

  if active-revokes != (:) {
    let i = first-active-index
    for data in data-chain {
      if data != none and data.name in active-revokes and i < active-revokes.at(data.name) {
        // Nullify changes at this stage
        chain.at(i) = (:)
      }

      i += 1
    }

    for (field-name, fold-data) in fold-chain {
      fold-chain.at(field-name).data = fold-data.data.filter(d => d.name == none or d.name not in active-revokes or d.index >= active-revokes.at(d.name))
      fold-chain.at(field-name).values = fold-chain.at(field-name).data.map(d => d.value)
    }
  }

  let final-values = chain.sum(default: (:))

  // Apply folds separately (their fields' values are meaningless in the above dict)
  for (field-name, fold-data) in fold-chain {
    final-values.at(field-name) = if fold-data.values == () {
      fold-data.default
    } else if fold-data.folder == auto {
      fold-data.default + fold-data.values.sum()
    } else {
      fold-data.values.fold(fold-data.default, fold-data.folder)
    }
  }

  final-values
}

// Retrieves the final chain data for an element, after applying all set rules so far.
#let get-styles(element, elements: (:)) = {
  if type(element) == function {
    element = data(element)
  }
  let (eid, default-fields) = if type(element) == dictionary and "eid" in element and "default-fields" in element {
    (element.eid, element.default-fields)
  } else {
    assert(false, message: "element.get: expected element (function / data dictionary), received " + str(type(element)))
  }

  let element-data = elements.at(eid, default: default-data)
  let folded-chain = if element-data.revoke-chain == default-data.revoke-chain and element-data.fold-chain == default-data.fold-chain {
    element-data.chain.sum(default: (:))
  } else {
    fold-styles(element-data.chain, element-data.data-chain, element-data.revoke-chain, element-data.fold-chain)
  }

  // No need to do extra folding like in constructor:
  // if a foldable field hasn't been specified, it is either equal to
  // its default, or it is a required field which has no default and
  // thus it is not returned here since it can't be set.
  default-fields + folded-chain
}

// Reads the current values of element fields after applying set rules.
//
// The callback receives a 'get' function which can be used to read the
// values for a given element.
#let prepare-get(receiver) = context {
  let previous-bib-title = bibliography.title
  [#context {
    let global-data = if (
      type(bibliography.title) == content
      and bibliography.title.func() == metadata
      and bibliography.title.at("label", default: none) == lbl-get
    ) {
      bibliography.title.value
    } else {
      (..default-global-data, first-bib-title: previous-bib-title)
    }

    if global-data.stateful {
      let chain = style-state.get()
      global-data = if chain == () {
        default-global-data
      } else {
        chain.last()
      }
    }

    set bibliography(title: previous-bib-title)
    receiver(get-styles.with(elements: global-data.elements))
  }#lbl-get]
}

// Create an element with the given name and constructor.
#let element(
  name,
  display: none,
  fields: none,
  prefix: "",
  typecheck: true,
  allow-unknown-fields: false,
  construct: none,
  synthesize: none,
  contextual: auto,
) = {
  assert(type(display) == function, message: "element: please specify a show rule in 'display:' to determine how your element is displayed.")
  assert(type(fields) == array, message: "element: please specify an array of fields, creating each field with the 'field' function.")
  assert(type(prefix) == str, message: "element: the prefix must be a string.")
  assert(type(typecheck) == bool, message: "element: the 'typecheck' argument must be a boolean (true to enable typechecking, false to disable).")
  assert(type(allow-unknown-fields) == bool, message: "element: the 'allow-unknown-fields' argument must be a boolean.")
  assert(synthesize == none or type(synthesize) == function, message: "element: 'synthesize' must be 'none' or a function element fields => element fields.")
  assert(contextual == auto or type(contextual) == bool, message: "element: 'contextual' must be 'auto' (true if using a contextual feature) or a boolean (true to wrap the output in a 'context { ... }', false to not).")
  assert(construct == none or type(construct) == function, message: "element: 'construct' must be 'none' (use default constructor) or a function receiving the original constructor and returning the new constructor.")

  if contextual == auto {
    // Provide separate context for synthesize.
    contextual = synthesize != none
  }

  let eid = base.unique-id("e", prefix, name)
  let lbl-show = label(lbl-show-head + eid)
  let lbl-where(n) = label("__custom_element_where_" + str(n) + eid)

  let fields = field-internals.parse-fields(fields, allow-unknown-fields: allow-unknown-fields)
  let (all-fields,) = fields

  let parse-args = field-internals.generate-arg-parser(
    fields: fields,
    general-error-prefix: "element '" + name + "': ",
    field-error-prefix: field-name => "field '" + field-name + "' of element '" + name + "': ",
    typecheck: typecheck
  )

  let default-fields = fields.all-fields.values().map(f => if f.required { (:) } else { ((f.name): f.default) }).sum(default: (:))

  let set-rule = set_.with((parse-args: parse-args, eid: eid, default-data: default-data, fields: fields))

  let get-rule(receiver) = prepare-get(g => receiver(g((eid: eid, default-fields: default-fields))))

  // Prepare a 'element.where(..args)' selector which
  // can be used in "show sel: set". This works by applying
  // a show rule to all element instances and, if they
  // match, they receive a unique label to be matched
  // by that selector. The selector is then provided
  // to the callback.
  let where-rule(receiver, ..args) = {
    assert(args.pos().len() == 0, message: "unexpected positional arguments\nhint: here, specify positional fields as named arguments, using their names")
    let args = args.named()

    if not allow-unknown-fields {
      let unknown-fields = args.keys().filter(k => k not in all-fields)
      if unknown-fields != () {
        let s = if unknown-fields.len() == 1 { "" } else { "s" }
        assert(false, message: "unknown field" + s + " " + unknown-fields.map(f => "'" + f + "'").join(", "))
      }
    }

    context {
      let previous-bib-title = bibliography.title
      [#context {
        let global-data = if (
          type(bibliography.title) == content
          and bibliography.title.func() == metadata
          and bibliography.title.at("label", default: none) == lbl-get
        ) {
          bibliography.title.value
        } else {
          (..default-global-data, first-bib-title: previous-bib-title)
        }

        if global-data.stateful {
          let chain = style-state.get()
          global-data = if chain == () {
            default-global-data
          } else {
            chain.last()
          }
        }

        let element-data = global-data.elements.at(eid, default: default-data)

        // Amount of 'where rules' so far, so we can
        // assign a unique number to each query
        let rule-counter = element-data.where-rule-count
        let matching-label = lbl-where(rule-counter)

        // Add unique matching label to all found elements
        show lbl-show: it => {
          let (fields,) = data(it)

          // Check if all positional and named arguments match
          if type(fields) == dictionary and args.pairs().all(((k, v)) => k in fields and fields.at(k) == v) {
            [#[#it#[]]#matching-label]
          } else {
            it
          }
        }

        if eid in global-data {
          global-data.elements.at(eid).where-rule-count += 1
        } else {
          element-data.where-rule-count += 1
          global-data.elements.insert(eid, element-data)
        }

        set bibliography(title: previous-bib-title)

        // Pass usable selector to the callback
        // This selector will only match elements with
        // the correct fields
        let body = receiver(matching-label)

        // Increase where rule counter for further where rules
        if global-data.stateful {
          style-state.update(chain => {
            chain.push(global-data)
            chain
          })

          body

          style-state.update(chain => {
            _ = chain.pop()
            chain
          })
        } else {
          show lbl-get: set bibliography(title: [#metadata(global-data)#lbl-get])
          body
        }
      }#lbl-get]
    }
  }

  let elem-data = (
    (element-key): true,
    version: element-version,
    eid: eid,
    set_: set-rule,
    get: get-rule,
    where: where-rule,
    sel: lbl-show,
    parse-args: parse-args,
    default-data: default-data,
    default-global-data: default-global-data,
    default-fields: default-fields,
    all-fields: all-fields,
    fields: fields,
    typecheck: typecheck,
    allow-unknown-fields: allow-unknown-fields,
    default-constructor: none,
    func: none,
  )

  let modified-constructor(..args, __elemmic_data: none, __elemmic_func: auto) = {
    if __elemmic_func == auto {
      __elemmic_func = modified-constructor
    }

    let default-constructor = modified-constructor.with(__elemmic_func: __elemmic_func)
    if __elemmic_data != none {
      return if __elemmic_data == special-data-values.get-data {
        (data-kind: "element", ..elem-data, func: __elemmic_func, default-constructor: default-constructor)
      } else {
        assert(false, message: "element: invalid data key to constructor: " + repr(__elemmic_data))
      }
    }

    let args = parse-args(args, include-required: true)
    let inner = context {
      let previous-bib-title = bibliography.title
      [#context {
        set bibliography(title: previous-bib-title)

        let (global-data, data-changed) = if (
          type(bibliography.title) == content
          and bibliography.title.func() == metadata
          and bibliography.title.at("label", default: none) == lbl-get
        ) {
          (bibliography.title.value, false)
        } else {
          ((..default-global-data, first-bib-title: previous-bib-title), true)
        }

        if global-data.stateful {
          let chain = style-state.get()
          global-data = if chain == () {
            default-global-data
          } else {
            chain.last()
          }
        }

        let element-data = global-data.elements.at(eid, default: default-data)

        let constructed-fields = if element-data.revoke-chain == default-data.revoke-chain and element-data.fold-chain == default-data.fold-chain {
          // Sum the chain of dictionaries so that the latest value specified for
          // each property wins.
          default-fields + element-data.chain.sum(default: (:)) + args
        } else {
          // We can't just sum, we need to filter and fold first.
          // Memoize this operation through a function.
          let outer-chain = default-fields + fold-styles(element-data.chain, element-data.data-chain, element-data.revoke-chain, element-data.fold-chain)
          let finalized-chain = outer-chain + args

          // Fold with received arguments
          for (field-name, fold-data) in element-data.fold-chain {
            if field-name in args {
              let outer = outer-chain.at(field-name, default: fold-data.default)
              if fold-data.folder == auto {
                finalized-chain.at(field-name) = outer + args.at(field-name)
              } else {
                finalized-chain.at(field-name) = (fold-data.folder)(outer, args.at(field-name))
              }
            }
          }

          finalized-chain
        }

        let shown = {
          let tag = (
            data-kind: "element-instance",
            body: none,
            fields: constructed-fields,
            func: __elemmic_func,
            default-constructor: default-constructor,
            eid: eid,
            fields-known: true,
            valid: true
          )

          if contextual {
            // Use context for synthesize as well
            context {
              let synthesized-fields = if synthesize == none {
                constructed-fields
              } else {
                synthesize(constructed-fields)
              }
              let body = display(synthesized-fields)

              let tag = tag
              tag.fields = synthesized-fields
              tag.body = body

              [#[#body#metadata(tag)]#lbl-show]
            }
          } else {
            let synthesized-fields = if synthesize == none {
              constructed-fields
            } else {
              synthesize(constructed-fields)
            }
            let body = display(synthesized-fields)

            tag.fields = synthesized-fields
            tag.body = body

            [#[#body#metadata(tag)]#lbl-show]
          }
        }

        if data-changed {
          show lbl-get: set bibliography(title: [#metadata(global-data)#lbl-get])
          shown
        } else {
          shown
        }
      }#lbl-get]
    }

    inner + [#metadata((
      data-kind: "element-instance",
      body: inner,
      fields: args,
      func: __elemmic_func,
      default-constructor: default-constructor,
      eid: eid,
      fields-known: false,
      valid: true
    ))#lbl-tag]
  }

  let final-constructor = if construct != none {
    {
      let test-construct = construct(modified-constructor)
      assert(type(test-construct) == function, message: "element: the 'construct' function must receive original constructor and return the new constructor, a new function, not '" + str(type(test-construct)) + "'.")
    }

    let final-constructor(..args, __elemmic_data: none) = {
      if __elemmic_data != none {
        return if __elemmic_data == special-data-values.get-data {
          (data-kind: "element", ..elem-data, func: final-constructor, default-constructor: modified-constructor.with(__elemmic_func: final-constructor))
        } else {
          assert(false, message: "element: invalid data key to constructor: " + repr(__elemmic_data))
        }
      }

      construct(modified-constructor.with(__elemmic_func: final-constructor))(..args)
    }

    final-constructor
  } else {
    modified-constructor
  }

  (
    final-constructor,
    (
      ..elem-data,
      default-constructor: modified-constructor.with(__elemmic_func: final-constructor),
      func: final-constructor,
    )
  )
}
