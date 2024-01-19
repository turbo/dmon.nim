# dmon for Nim

A tiny example of using [dmon](https://github.com/septag/dmon) from Nim. dmon is a tiny C library that monitors changes in a directory. It provides a unified solution to multiple system APIs that exist for each OS. It can also monitor directories recursively.

dmonExtra (linux only) is not included here.

Compile and run `test.nim` to see a log of changes in the current working dir. Be aware that callbacks are triggered from a different thread!