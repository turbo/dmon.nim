if defined(macos):
  {. passl: "-framework CoreFoundation -framework CoreServices" .}

{. compile: "dmon.c" .}

type
  WatchFlag* = enum
    recursive = 0x1
    followSymlinks = 0x2 # linux only
    # not implemented
    # outOfScopeLinks = 0x4
    # ignoreDirs = 0x8
  
  Action* = enum
    create = 1
    delete
    modify
    move

  WatchCallback* = (proc(
    watchId: uint32, 
    action: Action, 
    rootDir: cstring, 
    filePath: cstring, 
    oldFilePath: cstring, 
    userdata: pointer
  ))

{.push callConv: cdecl, importc: "$1".}
proc dmon_init()
proc dmon_deinit()
proc dmon_watch(
  rootDir: cstring,
  callback: WatchCallback,
  flags: uint32,
  userdata: pointer
): uint32
proc dmon_unwatch(watchId: uint32)
{.pop.}

proc initDmon*() = dmon_init()
proc freeDmon*() = dmon_deinit()

template withDmon*(body) =
  block:
    initDmon()
    defer: freeDmon()
    body

proc watch*(
  rootDir: string, 
  callback: WatchCallback, 
  flags: set[WatchFlag]
): uint32 =
  dmon_watch(rootDir.cstring, callback, cast[uint32](flags), nil)

proc unwatch*(watchId: uint32) = dmon_unwatch(watchId)