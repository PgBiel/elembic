# Introduction

**Welcome to Elemmic!** Elemmic is a package that lets you **create your own elements and types in Typst** with **support for type-checking and casting** on the fly.

Elemmic's elements support show and set rules. **No `state` or `counter` are used in its implementation,** making it comparatively fast.
However, **there are some important limitations** (read below).

## Before you start (READ THIS!)

As Elemmic is implemented in pure Typst, you can expect that **its performance will naturally be worse than a native solution,**
even though it doesn't use `state` and, therefore, should be faster than `state`-based solutions.

However, note that **there are some important things you should do** to avoid unnecessary performance or compilation problems. This includes **always grouping consecutive set rules together whenever possible**, replacing them with a single `apply` call, as **this circumvents Elemmic's limit of simultaneously active rules.**

You can read more on the [Limitations chapter](./about/limitations.md).
