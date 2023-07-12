[|
  main
    Environment loadModule:'AppKit'.

    app := NSApplication sharedApplication.
    app setDelegate:self.
    app run.

    ^self
  !

  application:app openFile:file
    ^self
  !

  applicationDidFinishLaunching:not
    frame := (10 @ 10) extent: (200 @@ 200).
    win := NSWindow alloc init.
    win setFrame:frame display:YES.

    app runModalForWindow: win.
    app terminate:nil.

    ^self
]
