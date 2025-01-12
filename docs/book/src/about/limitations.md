# Limitations

Please **keep in mind the following limitations** when using Elembic.

## Rule limit

Elembic, **in its default and most efficient mode,** has a limit of **up to 30 _non-consecutive_ rules within the same scope, by default**. This is due to a limitation in the Typst compiler regarding maximum function call depth, as we use show rules with `context { }` for set rules to work without using `state` (see also [typst#4171](https://github.com/typst/typst/issues/4171) for more information).

Usually, this isn't a problem unless you hit the infamous **"max show rule depth exceeded"** error. If you ever receive it, you may have to switch to **stateful mode**, which has **no set rule limit,** however **it is slower** as it uses `state`.

However, there are some easy things to keep in mind that will let you **avoid this error very easily,** which include:

1. Grouping rules together with `apply`
2. Scoping temporary rules and not misusing `revoke`
3. (As a last resort) Switching to either of the other styling modes (`leaky` or `stateful`)

### Grouping rules together with `apply`

First of all, note that, for the purposes of this limit, **rule** may be a set rule, but also an **`apply` rule**, which has the power of **applying multiple consecutive rules at the cost of one.**
That is, an `apply` rule, by itself, can hold much more than 30 rules (maybe 100, 500, you name it!) at once without a problem as it only counts for one towards the limit.

Therefore, it is recommended to **always group set rules together into a single apply rule** whenever possible.

Note that **elembic is smart enough to do this automatically** whenever it is **absolutely safe to do so** - that is, **when they are consecutive** (there are **no elements or text between them**, only whitespace or show/set rules).

That is, **doing either of those is OK:**

```rs
#import "@preview/elembic:X.X.X" as e

// OK: Explicitly paying for the cost of only a single rule
#show: e.apply(
  e.set_(elem, fieldA: 1)
  e.set_(elem, fieldB: 2)
  e.set_(elem, fieldC: 3)
)

// OR

// OK: elembic automatically merges consecutive rules
// (with nothing or only whitespace / set and show rules inbetween)
#show: e.set_(elem, fieldA: 1)
#show: e.set_(elem, fieldB: 1)

#show: e.set_(elem, fieldC: 1)
```

but **please avoid adding text and other elements between them** - elembic does not merge them as it may be unsafe (text may be converted into custom elements by show rules, and other elements may contain custom elements within them, for example):

```rs
#import "@preview/elembic:X.X.X" as e

// AVOID THIS! Paying for 3 rules instead of 1
// (Cannot safely move down the text between the rules
// automatically)
#show: e.set_(elem, fieldA: 1)

Some text (please move me below the rules)

#show: e.set_(elem, fieldB: 2)

Some text (please move me below the rules)

#show: e.set_(elem, fieldC: 3)
```

As a general rule of thumb, **prefer using explicit `apply` rules whenever possible.** It's not only safer (it's easy to accidentally disable the automatic merging by adding text like above), it's also easier to write and much cleaner!

### Scoping temporary rules and not misusing `revoke`

Are you only using a set rule for a certain part of your document? Please, **scope it instead of using it and revoking it**. The latter will permanently cost two rules from the limit, while the former will only cost one and only during the scope.

That is, **do this:**

```rs
// Default color
#superbox()

#[
  #show: e.set_(superbox, color: red)

  // All superboxes are temporarily red now
  #superbox()
  #superbox()
  #superbox()
]

// Back to default color!
// (The set rule is no longer in effect.)
#superbox()
```

But **do not do this:**

```rs
// Default color
#superbox()

#show: e.named("red", e.set_(superbox, color: red))

// All superboxes are red from here onwards
#superbox()
#superbox()
#superbox()

// AVOID THIS!
// While the rule was revoked and the color is back
// to the default, BOTH rules are still unnecessarily
// active and counting towards the limit.
#show: e.revoke("red")

// Back to default color!
// However, that is because both rules are in effect.
#superbox()
```

A **good usage** of `revoke` is to **only temporarily (for a certain scope) undo a previous set rule:**

```rs
// Default color
#superbox()

#show: e.named("red", e.set_(superbox, color: red))

// All superboxes are red from here onwards
#superbox()
#superbox()
#superbox()

#[
  // OK: This is scoped and only temporary
  #show: e.revoke("red")

  // Back to default color!
  // (Only temporary)
  // Both rules are in effect here
  // (the second nullifies the first).
  #superbox()
]

// This is red again now (the "red" rule is back).
// The revoke rule is no longer in effect.
// Only the set rule.
#superbox()
```

### Switching to other styling modes

If those measures are still not enough to fix the error, then you will have to **switch to another styling mode.**

There are three styling modes available for set rules (as well as apply rules, revoke rules and so on):

1. **Normal mode (default):** The safest mode, uses `show: set` rules on existing elements to store set rule data, and then immediately restores the current value of those rules, so it is **fast** (as it only uses show / set, so **it causes no document relayouts**) and **hygienic** (the inner workings of Elembic have no effect on your document in that case).
    - In this mode, you are limited to **around 30** simultaneous rules in the same scope as each set rule has **two nested function calls** (contributing twice towards the limit of 64, minus 3 due to elements themselves).
    - It is worth the reminder that this number refers to **ungrouped, non-consecutive set rules**. If you group set rules together, **they are unlimited in number**.
    - This is the default mode when using `e.set_(...)`, `e.revoke(...)` and others.
2. **Leaky mode:** It is as fast as normal mode, but **has double the limit of rules** (**around 60**). However, **it is not hygienic** as it **resets existing `#set bibliography(title: ...)` rules** to their **first known values**. (That is, any `bibliography.title` set rules after the first set rule are lost, and the initial value is reset with each leaky rule.) If this is acceptable to you, then **feel free to use leaky rules** to easily increase the limit.
    - This mode can be used by packages' internal elements, for example, since that set rule is probably unimportant then.
    - To switch to this mode, **replace all set rules with their `e.leaky` counterparts**. For example, you'd replace `e.set_(element, field: value)` with `e.leaky.set_(element, field: value)`. (You can create an alias such as `import e: leaky as lk` and then `lk.set_(...)` for ease of use.)
3. **Stateful mode:** Rules in this mode **do not have any usage limits.** You can nest them as much as you want, even if you don't group them. However, the downside is that **this mode uses `state`,** which can cause **document relayouts and be slower**.
    - Note that you can restrict this mode change to a single scope and use other modes elsewhere in the document.
    - Other rule modes are **compatible with stateful mode**. You can still use non-stateful set rules when stateful mode is enabled; while they will still have a limit, they will read and update set rule data using `state` as well, so they stay in sync. In addition, **the limit of normal-mode rules is doubled** just by enabling stateful mode in the containing scope, since they will automatically switch to a more lightweight code path. Therefore, **package authors can use normal-mode rules without problems**.

The easiest solution is to just **switch to stateful mode,** which uses `state` to keep track of set rules.
It is slower and may trigger document relayouts in some cases, but has no usage limits (other than
nesting many elements inside each other, which is a limitation shared by native elements as well and is
unavoidable).

To do this, **there are two steps** (unlike the single step for leaky mode):

1. **Enabling stateful mode:** Writing `#show: e.stateful.enable()` (note the parentheses) for either **a certain scope** (to only enable
it for a certain portion of your document) or **at the very top of the document** (to enable it for all of
the document);
    - This is used to inform rules in normal mode that they should read and write to the `state`. It also increases their limits by doing so.
    - Without this step, stateful-only set rules (below) don't do anything.

2. **Replacing existing set rules with their stateful-only counterparts.** That is, replace all occurrences
of `e.set_`, `e.apply`, `e.revoke` etc. with `e.stateful.set_`, `e.stateful.apply` and `e.stateful.revoke`,
respectively, in the scopes where stateful mode was enabled. (The previous rules remain working even under stateful mode, but still have usage limits, albeit a bit larger.)
    - While a Ctrl+F fixes it, it's a bit of a mouthful, so you may want to consider aliasing `e.stateful`
    to a variable such as `#import e: stateful as st`, then you can write `st.set_`, `st.apply` etc. instead.
    - Stateful-only rules have no usage limits, but **they only work in scopes where stateful mode is enabled.**
    Otherwise, they have no effect, since the `state` changes will be ignored.

The two steps above should be enough to fix the error for good, provided you understand the potential performance consequences. Of course, it just might not be at all significant for your document.

## Performance

Elembic's performance is, in general, satisfactory, and is logged on CI, but **may get worse if you use more features:**

- **Typechecking** of fields can add some overhead on each element instantiation. You can improve this by overriding Elembic's default argument parser, or even disabling typechecking altogether with the `typecheck: false` option on elements.
- **Special rules** such as revoke rules may add some overhead. However, it shouldn't be noticeable unless you're using a ton of them.

The only way to know whether Elembic is a good suit for you is to give it a try on your own document. Head to `Getting started` to begin!
