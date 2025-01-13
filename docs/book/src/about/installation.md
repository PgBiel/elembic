# Installation

Currently, Elembic must be installed **as a local package** (or by **copying it to your project** in the web app).

To install Elembic as a local package in your system, see [https://github.com/typst/packages?tab=readme-ov-file#local-packages](https://github.com/typst/packages?tab=readme-ov-file#local-packages) for instructions.

In particular, it involves downloading Elembic's files from either [GitHub (pgbiel/elembic)](https://github.com/PgBiel/elembic) or [Codeberg (pgbiel/elembic)](https://codeberg.org/PgBiel/elembic) and then copying it to `$LOCAL_PACKAGES_DIR/elembic/0.0.1`.

If you're using a Linux platform, there is the following one-liner command to install the latest development version (note: does not remove a prior installation):

```sh
pkgbase="${XDG_DATA_HOME:-$HOME/.local/share}/typst/packages/local/elembic" && mkdir -p "$pkgbase/0.0.1" && curl -L https://github.com/PgBiel/elembic/archive/main.tar.gz | tar xz --strip-components=1 --directory="$pkgbase/0.0.1"
```
