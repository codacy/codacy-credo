Spawning external commands can lead to command injection vulnerabilities.
Use a safe API where arguments are passed as an explicit list, rather
than unsafe APIs that run a shell to parse the arguments from a single
string.

Safe APIs include:

  * `System.cmd/2,3`
  * `:erlang.open_port/2`, passing `{:spawn_executable, file_name}` as the
    first parameter, and any arguments using the `:args` option

Unsafe APIs include:

  * `:os.cmd/1,2`
  * `:erlang.open_port/2`, passing `{:spawn, command}` as the first
    parameter

