Calls to dbg/0 and dbg/2 should mostly be used during debugging sessions.

This check warns about those calls, because they probably have been committed
in error.
