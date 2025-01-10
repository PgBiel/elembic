#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: field

#let wock = e.element.declare(
  "wock",
  display: it => {},
  fields: (
    field("color", color, default: blue),
    field("inner", content, default: [])
  ),
  prefix: ""
)

#let setter = e.set_(wock, color: red)
#show: setter

\
\

#show: setter

\
\

#show: setter

\
\

#show: setter

\
\

#show: setter

\
\

#show: setter

\
\

#show: setter

\
\

#show: setter

\
\

#show: setter

\
\

#show: setter

\
\

#show: setter // 10

\
\

#show: setter

\
\

#show: setter

\
\

#show: setter

\
\

#show: setter

\
\

#show: setter

\
\

#show: setter

\
\

#show: setter

\
\

#show: setter

\
\

#show: setter

\
\

#show: setter // 20

\
\

#show: setter

\
\

#show: setter

\
\

#show: setter

\
\

#show: setter

\
\

#show: setter

\
\

#show: setter

\
\

#show: setter

\
\

#show: setter

\
\

#show: setter

\
\

#show: setter // 30

\
\

#show: setter

\
\

#show: setter

\
\

#show: setter

\
\

#show: setter

\
\

#show: setter

\
\

#show: setter

\
\

#show: setter

\
\

#show: setter

\
\

#show: setter

\
\

#show: setter // 40

\
\

#show: setter

\
\

#show: setter

\
\

#show: setter

\
\

#show: setter

\
\

#show: setter

\
\

#show: setter

\
\

#show: setter

\
\

#show: setter

\
\

#show: setter

\
\

#show: setter // 50

\
\

#show: setter

\
\

#show: setter

\
\

#show: setter

\
\

#show: setter

\
\

#show: setter

\
\

#show: setter

\
\

#show: setter

\
\

#show: setter

\
\

#show: setter

\
\

#show: setter // 60

\
\

#show: setter

\
\

#show: setter

\
\

#show: setter

\
\

#show: setter

\
\

#show: setter

\
\

#show: setter

\
\

#show: setter

\
\

#show: setter

\
\

#show: setter

\
\

#show: setter // 70

\
\

#show: setter

\
\

#show: setter

\
\

#show: setter

\
\

#show: setter

\
\

#show: setter

\
\

#show: setter

\
\

#show: setter

\
\

#show: e.apply(
  setter,
  e.set_(wock, inner: [Road]),
)

\
\

#show: setter

\
\

#show: setter // 80

\
\

#show: setter

\
\

#show: setter

\
\

#show: setter

\
\

#show: setter

\
\

#show: setter

\
\

#show: setter

\
\

#show: setter

\
\

#show: setter

\
\

#show: setter

\
\

#show: setter // 90

\
\

#show: setter

\
\

#show: setter

\
\

#show: setter

\
\

#show: setter

\
\

#show: setter

\
\

#show: setter

\
\

#show: setter

\
\

#show: setter

\
\

#show: e.set_(wock, color: yellow) // 100

\
\

b

#wock()
#e.get(get => assert.eq(get(wock).color, yellow))
#e.get(get => assert.eq(get(wock).inner, [Road]))
