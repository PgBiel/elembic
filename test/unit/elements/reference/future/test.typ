#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: field
#import "/src/data.typ": lbl-ref-figure-label-head, lbl-tag

#show: e.prepare()

#let wock = e.element.declare(
  "wock",
  display: it => {},
  fields: (
    field("color", color, default: red),
    field("inner", content, default: [Hello!])
  ),
  reference: (
    custom: _ => [a],
  ),
  prefix: ""
)

#wock(color: blue, label: <my-wock>)

#let test-state = state("ref-test", ())
#let future(target: 12345, supplement: 67890, ref-instance: 88888, __future-version: 0) = {
  assert(__future-version > 0)
  test-state.update(a => a + ((target: target, supplement: supplement, ref-instance: ref-instance.at("supplement", default: 0)),))
}

#context {
  assert.eq(query(selector(<my-wock>).before(here())).len(), 1)
  let meta = e.data(query(selector(<my-wock>).before(here())).first())
  [
    #[abc#metadata((:..meta, __future-ref: (call: future, max-version: 9999)))#lbl-tag]<future-wock>
    #[abc#metadata((:..meta, __future-ref: (call: future, max-version: 0)))#lbl-tag]<bad-wock>
  ]
}

@future-wock
@future-wock[def]
@future-wock[~p. 34]

// No effect (current version > max version)
@bad-wock
@bad-wock[abc]
@bad-wock[~p. 34]

#context assert.eq(test-state.get(), (
  (target: <future-wock>, supplement: auto, ref-instance: auto),
  (target: <future-wock>, supplement: [def], ref-instance: [def]),
  (target: <future-wock>, supplement: [~p. 34], ref-instance: [~p. 34]),
))
