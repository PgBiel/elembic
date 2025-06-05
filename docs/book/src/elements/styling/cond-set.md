# Conditional set rules

Some set rules, modifying certain fields, should only be applied if _other_ fields have specific values. For example, if a theorem has `kind: "lemma"`, you may want to set its `supplement` to `[Lemma]`, or to `[Lema]` to translate it to some language.

In this case, you can use `e.cond-set(filter, field1: value1, field2: value2, ...)`. `filter` determines which element instances should be changed, and what comes after are the fields to set.
