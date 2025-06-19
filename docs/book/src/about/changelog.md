# Changelog

## v1.0.0 (2025-06-09)

Elembic is now available on the Typst package manager! Use it today with:

```typ
#import "@preview/elembic:1.0.0" as e

#let my-element = e.element.declare(...)
#show: e.set_(my-element, field: 2, ...)
```

In addition, the docs have been updated (and are still receiving more updates) - read them here: https://pgbiel.github.io/elembic

### What's Changed
- Add `doc:` property to elements to describe what they do
- Optimization: When an element `display` function is defined as `display: it => e.get(get => x)` (instantly returns `e.get`), the body is simplified to just `x` (`get => ...` is called internally by the element code), reducing amount of `context {}` nesting.
- Custom types now have `fold: auto` by default, merging their fields between set rules
- `types.wrap` now has an additional safeguard to error when `fold:` needs to be updated
- Moved `ok`, `err`, `is-ok` from `e.types` to `e.result.{ok, err, is-ok}`
- Created `examples/` folder for examples on how to use elembic
- Update docs for v1.0 ([PR GH#48](https://github.com/PgBiel/elembic/pull/48))
   - Now using `mdbook-admonish`
   - Improve "Creating" section
   - New "Examples" section
   - New "Styling" section
   - New "Scripting" section
   - Show how to import from the package manager
   - Several other improvements

**Full Changelog**: [https://github.com/PgBiel/elembic/compare/v1.0.0-rc2...v1.0.0](https://github.com/PgBiel/elembic/compare/v1.0.0-rc2...v1.0.0)

## v1.0.0-rc2 (2025-06-03)

### What's Changed
- Add folding to dicts by default ([PR GH#47](https://github.com/PgBiel/elembic/pull/47))
- There is now a perma-unstable `internal` module which exposes some internal stuff for debugging. Relying on it is not recommended, but might be needed to test for implementation bugs at some point.


**Full Changelog**: [https://github.com/PgBiel/elembic/compare/v1.0.0-rc1...v1.0.0-rc2](https://github.com/PgBiel/elembic/compare/v1.0.0-rc1...v1.0.0-rc2)

## v1.0.0-rc1 (2025-05-31)

**NOTE:** Docs are currently outdated; they will receive a brief update throughout the week (before and after 1.0 is released).

### What's Changed
- Fixed `e.select` accidentally producing clashing labels in trivial cases
  - **NOTE:** since alpha 3, it requires a mandatory `prefix:` argument as clashing labels are inevitable when two `select`s are not nested, but instead siblings. So make sure to add something like `e.select(prefix: "@preview/your-package/level 1" ...)` to ensure each `select` is distinct. There is no risk of clashing when one `select` is inside the other.
- Enabled folding of  `smart(option(T))` when `T` is a foldable type (e.g. array, stroke)
- Enabled folding of union types when not ambiguous ([PR GH#46](https://github.com/PgBiel/elembic/pull/46))
- Added more safeguards to `e.types.wrap`, a utility to create new types wrapping old types, to avoid further cases of creation of invalid types
- Added some forward-compatibility to `e.ref`
- Store custom type arguments with `e.data(custom type).type-args`, and similarly for custom elements with `e.data(custom element).elem-args`
   - Those were the arguments passed to `.declare`, can be used for reflection purposes

**Full Changelog**: [https://github.com/PgBiel/elembic/compare/v0.0.1-alpha3...v1.0.0-rc1](https://github.com/PgBiel/elembic/compare/v0.0.1-alpha3...v1.0.0-rc1)

## v0.0.1-alpha3 (2025-05-23)

We're very close to v1!

### What's Changed

- New rules:
   - **Show:** the new recommended approach for show rules, support custom elembic filters ([PR GH#27](https://github.com/PgBiel/elembic/pull/27))
      - `show: e.show_(wock.with(color: red), it => [hello #it])` will add "hello" before all red wocks
      - These show rules are **nameable and revokable**, allowing you to cancel its application temporarily, for elements in a scope, using `show: e.revoke("its name")`
   - **Filtered:** apply to all **children** of matching elements ([PR GH#17](https://github.com/PgBiel/elembic/pull/17))
      - `show: e.filtered(wock.with(color: red), e.set_(wock, color: purple))` will set all wocks children of red wocks to purple
   - **Conditional set:** change fields of all matching elements
      - `show: e.cond-set(wock.with(kind: "monster"), color: purple)` will set all monster wocks to purple color
- New filters: (usable in those rules - [PR GH#23](https://github.com/PgBiel/elembic/pull/23))
   - AND, OR, NOT, XOR combiners
     - `e.filters.and_(my-rect, e.filters.not_(my-rect.with(fill: blue)))` matches all rectangles without blue fill
     - `e.filters.or_(thm.with(kind: "lemma"), thm.with(kind: "theorem"))` will match theorems or lemmas
     - `e.filters.xor(thm.with(kind: "lemma"), thm.with(stroke: blue))` will match a lemma or a theorem with a blue stroke, but not a lemma with a blue stroke
     - Note that NOT must be in an `and` to avoid unlimited matching
   - Custom filters
     - `e.filters.and_(person, e.filters.custom((it, ..) => it.age > 5))` will match all `person` instances with age greater than 5
     - Same disclaimer as NOT
- Within filter (**ancestry tracking** - [PR GH#38](https://github.com/PgBiel/elembic/pull/38))
   - Check descendant
      - `e.filters.and_(wock, e.within(blocky.with(fill: red)))` matches all wocks in red-filled `blocky` at any depth
   - Check depth
      - `e.filters.and_(wock, e.within(blocky, depth: 1))` matches all wocks which are direct children of blocky **among elembic elements with ancestry tracking enabled** (see caveat below)
   - Check max depth
      - `e.filters.and_(wock, e.within(blocky, max-depth: 2))` matches all wocks which are either direct children of blocky or inside a direct child of blocky (**same disclaimer**)
   - **NOTE: Ancestry tracking is lazy and restricted to elembic elements.** This means that:
      - If you never write a rule with `e.within(elem)`, any other `.within` will completely ignore `elem`. For example, in `blocky(elem(wock))`, if we never wrote a rule with `e.within(elem)`, `wock` will still be considered a direct child (depth 1). So ancestry tracking is only enabled for an element if at least one `.within(elem)` rule is used above it.
      - You can **force elements to track ancestry** without rules using `show: e.settings(track-ancestry: (elem1, elem2))`. (Applies only to elements in the same scope / below).
         - You can even force all elements to do it with `show: e.settings(track-ancestry: "any")`
         - However, **this will degrade your performance** when applied to too many elements so make sure to test it appropriately first
         - It may also change the meaning of within rules depending on depth.

- Added `e.query(filter)` (#34)
  - Query instances of your element with a certain filter, as specified above
  - `within` filters will only work if the element is set to track ancestry (lazy), or just store (avoid some of the performance losses)
     - Force with `#show: e.settings(store-ancestry: (elem,))` or (to track and store) `track-ancestry: (elem,)`.

- Lots of forward- and backward-compatibility fixes (e.g. #37)

- `none` is now valid input for `content` type fields (see #5 for discussion)

- Added support for automatic casts from dictionary to custom types by enabling with the `casts: ((from: dictionary),)` option ([Issue GH#15](https://github.com/PgBiel/elembic/issues/15))

### Other features

- Use `e.eq(elem1, elem2)` or `e.eq(mytype1, mytype2)` to properly compare two custom elements or custom type instances. ([PR GH#29](https://github.com/PgBiel/elembic/pull/29))
   - If this returns `true`, it will remain so even if you update elembic to another version later, or change some data about the type or element.
   - This is important as those changes would cause `==` to turn false between elements created before the change and elements created after.
   - However, note that `e.eq` is potentially slower as it will recursively compare fields.
   - Only a concern for package authors (since there can be concurrent versions of a package simultaneously).

- Use `#show: e.leaky.enable()` to quickly enable leaky mode for rules under it without having to add the `e.leaky` prefix to each one.

- Rules can now have multiple names to revoke them by ([PR GH#25](https://github.com/PgBiel/elembic/pull/25)).
  - For example, `#show: e.named("a1", "b1", e.set_(blocky, fill: red))`
  - **Useful for templates** (e.g. use names to "group together" revokable rules).
  - Then, if downstream users don't like those rules, they can revoke them easily with `#show: e.revoke("a1")` in the scope where the template is used.

- Added `e.stateful.get()`
  - Stateful mode-only feature, allows you to `get(custom element)` (get values set by set rules) without having to wrap your code in a callback `get => ...`
  - E.g. `let fields = e.stateful.get(wock)`

- Added field metadata, `internal: bool`, `folds: bool`
  - Set `e.field(internal: true)` to indicate this field is internal and users shouldn't care about it
  - Set `e.field(folds: false)` to **disable** folding for this field (e.g. set rule on an array field with fold: false will override the previous array instead of just appending to it)
  - Set `e.field(metadata: (a: 5, b: 6))` to attach arbitrary metadata to a field

**Full Changelog**: [https://github.com/PgBiel/elembic/compare/v0.0.1-alpha2...v0.0.1-alpha3](https://github.com/PgBiel/elembic/compare/v0.0.1-alpha2...v0.0.1-alpha3)

## v0.0.1-alpha2 (2025-03-18)

This was the version that was shipped with lilaq 0.1.0.

## v0.0.1-alpha1 (2025-01-13)

Initial alpha testing release
