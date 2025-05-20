#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: field

#let wock = e.element.declare(
  "wock",
  display: it => { it.inner },
  fields: (
    field("color", color, default: red),
    field("inner", content, default: [Hello!])
  ),
  prefix: ""
)

#let dock = e.element.declare(
  "dock",
  display: it => { it.inner },
  fields: (
    field("color", color, default: red),
    field("inner", content, default: [Hello!])
  ),
  prefix: ""
)

#[
  #show: e.filtered(e.filters.and_(wock, e.within(dock.with(color: yellow), max-depth: 1)), e.set_(wock, color: purple))

  #let expect-wock(..fields) = e.get(get => assert(fields.named().pairs().all(((k, v)) => k in get(wock) and get(wock).at(k) == v)))

  #dock(color: yellow, inner: wock(inner: expect-wock(color: purple)))
  #dock(color: yellow, inner: dock(inner: wock(inner: expect-wock(color: red))))
  #dock(color: yellow, inner: dock(inner: dock(inner: wock(inner: expect-wock(color: red)))))
]

#[
  #show: e.filtered(e.filters.and_(wock, e.within(dock.with(color: yellow), max-depth: 2)), e.set_(wock, color: purple))

  #let expect-wock(..fields) = e.get(get => assert(fields.named().pairs().all(((k, v)) => k in get(wock) and get(wock).at(k) == v)))

  #dock(color: yellow, inner: wock(inner: expect-wock(color: purple)))
  #dock(color: yellow, inner: dock(inner: wock(inner: expect-wock(color: purple))))
  #dock(color: yellow, inner: dock(inner: dock(inner: wock(inner: expect-wock(color: red)))))
]

#[
  #show: e.filtered(e.filters.and_(wock, e.within(dock.with(color: yellow), depth: 2)), e.set_(wock, color: purple))

  #let expect-wock(..fields) = e.get(get => assert(fields.named().pairs().all(((k, v)) => k in get(wock) and get(wock).at(k) == v)))

  #dock(color: yellow, inner: wock(inner: expect-wock(color: red)))
  #dock(color: yellow, inner: dock(inner: wock(inner: expect-wock(color: purple))))
  #dock(color: yellow, inner: dock(inner: dock(inner: wock(inner: expect-wock(color: red)))))
]

#[
  #show: e.filtered(e.filters.and_(wock, e.within(dock.with(color: yellow), depth: 1)), e.set_(wock, color: purple))

  #let expect-wock(..fields) = e.get(get => assert(fields.named().pairs().all(((k, v)) => k in get(wock) and get(wock).at(k) == v)))

  #dock(color: yellow, inner: wock(inner: expect-wock(color: purple)))
  #dock(color: yellow, inner: dock(inner: wock(inner: expect-wock(color: red))))
  #dock(color: yellow, inner: dock(inner: dock(inner: wock(inner: expect-wock(color: red)))))
]
