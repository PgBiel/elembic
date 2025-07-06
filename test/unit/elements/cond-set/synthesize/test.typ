/// Test conditional set rules with synthesized fields.

#import "/test/unit/base.typ": empty
#show: empty

#import "/src/lib.typ" as e: field, types

#let wibble = e.element.declare(
  "wibble",
  display: it => {
    (it.run)(it)
  },
  fields: (
    field("number1", int, default: 5),
    field("number2", int, synthesized: true),
    field("number3", int, default: 10),
    field("number4", int, synthesized: true),
    field("run", function, default: panic),
  ),
  synthesize: it => {
    it.number2 = it.number1 + 1
    it.number4 = it.number3 + 1
    it
  },
  prefix: ""
)

#wibble(number1: 20, run: it => assert.eq(it.number2, 21) + assert.eq(it.number4, 11))
#wibble(number1: 20, label: <abc>, run: it => assert.eq(it.number2, 21) + assert.eq(it.number4, 11) + assert.eq(it.label, <abc>))

// This shouldn't change anything
#show: e.cond-set(wibble)

#wibble(number1: 20, run: it => assert.eq(it.number2, 21) + assert.eq(it.number4, 11))
#wibble(number1: 20, label: <abc>, run: it => assert.eq(it.number2, 21) + assert.eq(it.number4, 11) + assert.eq(it.label, <abc>))

// Updating number3 should implicitly update number4
#show: e.cond-set(wibble.with(number1: 20), number3: 50)

#wibble(number1: 20, run: it => assert.eq(it.number2, 21) + assert.eq(it.number4, 51))
#wibble(number1: 20, label: <abc>, run: it => assert.eq(it.number2, 21) + assert.eq(it.number4, 51) + assert.eq(it.label, <abc>))
