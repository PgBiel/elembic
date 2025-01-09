// Custom types!
#import "base.typ" as base: custom-type-key, custom-type-data-key, type-key, special-data-values
#import "types.typ"
#import "../fields.typ" as field-internals

#let custom-type-version = 1

#let declare(
  name,
  fields: none,
  prefix: none,
  default: none,
  typecheck: true,
  allow-unknown-fields: false,
  construct: none,
  casts: none,
) = {
  assert(type(fields) == array, message: "types.declare: please specify an array of fields, creating each field with the 'field' function.")
  assert(prefix != none, message: "types.declare: please specify a 'prefix: ...' for your type, to distinguish it from types with the same name. If you are writing a package or template to be used by others, please do not use an empty prefix.")
  assert(type(prefix) == str, message: "types.declare: the prefix must be a string, not '" + str(type(prefix)) + "'")
  assert(type(typecheck) == bool, message: "types.declare: the 'typecheck' argument must be a boolean (true to enable typechecking in the constructor, false to disable).")
  assert(type(allow-unknown-fields) == bool, message: "types.declare: the 'allow-unknown-fields' argument must be a boolean.")
  assert(construct == none or type(construct) == function, message: "types.declare: 'construct' must be 'none' (use default constructor) or a function receiving the original constructor and returning the new constructor.")
  assert(default == none or type(default) == function, message: "types.declare: 'default' must be none or a function receiving the constructor and returning the default.")
  assert(
    casts == none
    or type(casts) == array and casts.all(
      d => (
        type(d) == dictionary
        and "from" in d
        and "with" in d
        and d.keys().all(k => k in ("from", "with", "check"))
        and type(d.with) == function
        and ("check" not in d or type(d.check) == function)
      )
    ),
    message: "types.declare: 'casts' must be either 'none' or an array of dictionaries in the form (from: type, check (optional): casted value => bool, with: constructor => casted value => your type)."
  )

  let tid = base.unique-id("t", prefix, name)
  let fields = field-internals.parse-fields(fields, allow-unknown-fields: allow-unknown-fields)
  let (all-fields, foldable-fields) = fields

  let parse-args = field-internals.generate-arg-parser(
    fields: fields,
    general-error-prefix: "type '" + name + "': ",
    field-error-prefix: field-name => "field '" + field-name + "' of type '" + name + "': ",
    typecheck: typecheck
  )

  let default-fields = fields.all-fields.values().map(f => if f.required { (:) } else { ((f.name): f.default) }).sum(default: (:))

  let typeid = (tid: tid, name: name)

  // TODO: casts
  // We will specify default in a bit, once we declare the constructor
  let typeinfo = (
    ..base.base-typeinfo,
    (type-key): "custom",
    name: name,
    input: (typeid,),
    output: (typeid,),
    data: (id: typeid)
  )

  let type-data = (
    (custom-type-data-key): true,
    version: custom-type-version,
    tid: tid,
    id: typeid,
    // We will add this here once the constructor is declared
    typeinfo: none,
    parse-args: parse-args,
    default-fields: default-fields,
    all-fields: all-fields,
    fields: fields,
    typecheck: typecheck,
    allow-unknown-fields: allow-unknown-fields,
    default-constructor: none,
    func: none,
  )

  let process-casts = if casts == none {
    none
  } else {
    // Trick: We assign cast to each cast-from type and create a union,
    // and use its generated check/cast functions as our own
    default-constructor => {
      let typeinfos = casts.map(cast => {
        let (res, from) = types.validate(cast.from)
        if not res {
          assert(false, message: "types.declare: invalid cast-from type: " + from)
        }

        let with = (cast.with)(default-constructor)
        if type(with) != function {
          assert(
            false,
            message: "types.declare: cast 'with' must receive the default constructor and return a function 'casted value => your type'. Received " + base.typename(with)
          )
        }

        let cast-check = cast.at("check", default: none)
        let from-cast = from.cast

        types.wrap(
          from,
          check: from-check => if from-check == none {
            if cast-check == none {
              none
            } else if from.cast == none {
              cast-check
            } else {
              value => cast-check(from-cast(value))
            }
          } else if cast-check == none {
            from-check
          } else if from.cast == none {
            value => from-check(value) and cast-check(value)
          } else {
            value => from-check(value) and cast-check(from-cast(value))
          },

          output: (typeid,),

          cast: from-cast => if from-cast == none {
            with
          } else {
            value => with(from-cast(value))
          },

          default: (),
          fold: none,
        )
      })

      // Accept our own typeinfo first and foremost
      let union = base.union((typeinfo,) + typeinfos)

      assert(
        union.output == (typeid,) and union.default == () and union.fold == none,
        message: "types.declare: internal error: cast generated invalid union: " + repr(union)
      )

      (
        input: union.input,
        output: union.output,
        check: union.check,
        cast: union.cast,
        error: if union.error == none {
          _ => "failed to cast to custom type '" + name + "'"
        } else {
          x => (union.error)(x).replace("all typechecks for union failed", "all casts to custom type '" + name + "' failed")
        }
      )
    }
  }

  let default-constructor(..args, __elembic_data: none, __elembic_func: auto) = {
    if __elembic_func == auto {
      __elembic_func = default-constructor
    }

    let default-constructor = default-constructor.with(__elembic_func: __elembic_func)
    if __elembic_data != none {
      return if __elembic_data == special-data-values.get-data {
        let typeinfo = typeinfo + if process-casts != none { process-casts(default-constructor) } else { (:) }
        if default != none {
          typeinfo.default = (default(default-constructor),)
        }

        (data-kind: "custom-type-data", ..type-data, typeinfo: typeinfo, func: __elembic_func, default-constructor: default-constructor)
      } else {
        assert(false, message: "types: invalid data key to constructor: " + repr(__elembic_data))
      }
    }

    let args = parse-args(args, include-required: true)

    let final-fields = default-fields + args

    if foldable-fields != (:) {
      // Fold received arguments with defaults
      for (field-name, fold-data) in foldable-fields {
        if field-name in args {
          let outer = default-fields.at(field-name, default: fold-data.default)
          if fold-data.folder == auto {
            final-fields.at(field-name) = outer + args.at(field-name)
          } else {
            final-fields.at(field-name) = (fold-data.folder)(outer, args.at(field-name))
          }
        }
      }
    }

    final-fields.insert(
      custom-type-key,
      (
        data-kind: "type-instance",
        fields: final-fields,
        func: __elembic_func,
        default-constructor: default-constructor,
        tid: tid,
        id: (tid: tid, name: name),
        fields-known: true,
        valid: true
      )
    )

    final-fields
  }

  default = if default == none {
    ()
  } else {
    let default = default(default-constructor)
    assert(
      type(default) == dictionary and custom-type-key in default and default.at(custom-type-key).id == typeid,
      message: "types.declare: the 'default' function must return an instance of the new type using the provided constructor, not " + repr(default)
    )


    (default,)
  }

  if process-casts != none {
    typeinfo += process-casts(default-constructor)
  }
  typeinfo.default = default
  type-data.typeinfo = typeinfo

  let final-constructor = if construct != none {
    {
      let test-construct = construct(default-constructor)
      assert(type(test-construct) == function, message: "types.declare: the 'construct' function must receive the default constructor and return the new constructor, a new function, not '" + str(type(test-construct)) + "'.")
    }

    let final-constructor(..args, __elembic_data: none) = {
      if __elembic_data != none {
        return if __elembic_data == special-data-values.get-data {
          (data-kind: "custom-type-data", ..type-data, func: final-constructor, default-constructor: default-constructor.with(__elembic_func: final-constructor))
        } else {
          assert(false, message: "types: invalid data key to constructor: " + repr(__elembic_data))
        }
      }

      construct(default-constructor.with(__elembic_func: final-constructor))(..args)
    }

    final-constructor
  } else {
    default-constructor
  }

  type-data.default-constructor = default-constructor.with(__elembic_func: final-constructor)
  type-data.func = final-constructor

  final-constructor
}
