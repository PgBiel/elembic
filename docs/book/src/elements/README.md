# Elements

Elements, in their essence, are **reusable components of the document** which can be used to ensure certain parts of it share the same appearance - for example, headings, figures, as well as blocks, which are available by default.

In addition, however, elements have other properties. They can be **configured by users** through **styles,** that is, **show and set rules**, which can be used to, respectively, replace an element's whole appearance with some other, or change the values of some of that element's fields, if they are unspecified when the element is created.

Elembic allows you to **create your own elements,** as well as **style them** through **show rules, set rules**, including some extras not natively available such as **revoke and reset rules** (which can be used to temporarily "undo" the effect of an earlier set rule for a limited scope). In addition, Elembic can guarantee type-safety and more helpful errors by **typechecking inputs to elements' fields.**

However, please **make sure to read** about Elembic's [limitations](../about/limitations.md), just so you are aware of them. (The most important one is about the usage of set rules, and there are several ways to avoid it.)

This chapter will explain everything you need to know about:

1. **Creating custom elements** (useful for package and template authors);
2. **Using and styling custom elements** (useful for document writers and template authors);
3. **Other advanced usages of custom elements** (useful for everyone who's interested on making the most out of this library).

Throughout the chapter, we will create and manipulate a sample element named "part".
