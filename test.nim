import std / [
  os,
  strformat
]

import dmon

proc exit() {.noconv.} = quit(0)
setControlCHook(exit)

proc cb(
  watchId: uint32, 
  action: Action, 
  rootDir: cstring, 
  filePath: cstring, 
  oldFilePath: cstring, 
  userdata: pointer
) =
  var msg = &"{action}: [{rootDir}]{filePath}"
  if action == move:
    msg &= &" (from {oldFilePath})"
  echo msg

proc main() =
  withDmon:
    let path = getCurrentDir()

    let wId = watch(path, cb, {recursive})
    echo &"Watching (ID: {wId}) {path} recursively ..."

    while true:
      sleep(10)

main()