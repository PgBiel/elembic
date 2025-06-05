# Logic operators

Filters can be **combined** with logic operators. They are:

1. `e.filters.and_(filter 1, filter 2, ...)`: matches elements which match **all** filters at once.
2. `e.filters.or_(filter 1, filter 2, ...)`: matches elements which match **at least one** of the given filters.
3. `e.filters.xor(filter 1, filter 2)`: matches elements which match **exactly one** of the two given filters.
4. `e.filters.not_(filter)`: matches elements which **do not match** the given filter.

Consider the example below:

```rs
#import "@preview/elembic:X.X.X" as e
#import "package": container, theorem

#show: e.show_(  // replace elements...
  e.filters.or_( // ...matching at least one of the following filters:
    e.filters.and_( // Either satisfies all of the two conditions below:
      container, // 1. Is a container;
      e.filters.not_(container.with(fill: red)) // 2. Does not have a red fill;
    ),
    theorem.with(supplement: [Lemma]), // Or is a theorem tagged as a Lemma...
  ),

  // ...with the word "Matched (element name)!"
  it => [Matched #e.data(it).name!]
)

// Not replaced: is a container, but has a red fill; and is not a theorem.
#container(fill: red)

// Replaced with "Matched 'container'!"
#container(fill: blue)
```

```admonish note title="Restricting NOT's domain"
A **NOT** filter cannot be used with elembic filtered rules by default as it could match any element, e.g. `e.filters.not_(elem.with(field: 5))` would not only match `elem` with a field different from 5, but also match any element that isn't `elem`, which is not viable for elembic.

To solve this, each NOT filter must be ultimately (directly or indirectly) wrapped within another filter operator that restricts its matching domain (usually AND).

For example, `e.filters.and_(e.filters.or_(elem1, elem2), e.filters.not_(elem1.with(fill: red)))` will match any `elem2` instances, and `elem1` instances with a non-red fill, but won't match `elem3` for example, even though it would satisfy the NOT filter on its own. This filter can now be used in filtered rules!

Something similar occurs with [custom filters](./custom.md).
```
