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

#let count = counter("abc")
#let st = state("def", ())

#let setter = e.set_(wock, color: red)
#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("y",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter // 10

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter // 20

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter // 30

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter // 40

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter // 50

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter // 60

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter // 70

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: e.apply(
  setter,
  e.set_(wock, inner: [Road]),
)

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter // 80

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter // 90

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#show: setter
#set outline(title: [Roadster])
#set bibliography(title: [Mount])
#show: e.set_(wock, color: yellow) // 100

// Let's update this
#count.step()
#v(0.5em)
#st.update(x => x + ("x",))

#context {
  assert.eq(count.get().first(), 99)
  assert.eq(st.get(), ("x", "y") + ("x",) * 97)
}

#wock()
