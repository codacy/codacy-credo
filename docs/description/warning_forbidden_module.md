Some modules that are included by a package may be hazardous
if used by your application. Use this check to allow these modules in
your dependencies but forbid them to be used in your application.

Examples:

The `:ecto_sql` package includes the `Ecto.Adapters.SQL` module,
but direct usage of the `Ecto.Adapters.SQL.query/4` function, and related functions, may
cause issues when using Ecto's dynamic repositories.
