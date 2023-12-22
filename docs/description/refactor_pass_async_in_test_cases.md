Test modules marked `async: true` are run concurrently, speeding up the
test suite and improving productivity. This should always be done when
possible.

Leaving off the `async:` option silently defaults to `false`, which may make
a test suite slower for no real reason.

Test modules which cannot be run concurrently should be explicitly marked
`async: false`, ideally with a comment explaining why.
