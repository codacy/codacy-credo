When implementing behaviour callbacks, `@impl true` indicates that a function implements a callback, but
a better way is to note the actual behaviour being implemented, for example `@impl MyBehaviour`. This
not only improves readability, but adds extra validation in cases where multiple behaviours are implemented
in a single module.

Instead of:

    @impl true
    def my_funcion() do
      ...

use:

    @impl MyBehaviour
    def my_funcion() do
      ...

