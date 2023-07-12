[|
  main
    Environment loadModule:'AppKit'.
    Environment includeProtocol:'NSApplicationDelegate'.

    app := NSApplication sharedApplication.
    app setDelegate:self.
    app run.
  !

  awakeFromNib
    textField setStringValue:'hello there'.
  !

  application:app openFile:file
    Transcript showLine:('openFile:', file).
  !

  applicationDidFinishLaunching:not
    o := NSMutableDictionary dictionary.
    o setValue:self forKey:'NSOwner'.
    a := NSBundle loadNibFile:'./app.gorm' externalNameTable:o withZone:nil.
  !

  windowWillClose:not
    Transcript showLine:'window closed, terminate'.
    app terminate:nil.
  !

  setTextField:sender
    Transcript showLine:'setting text field from Gorm'.
    textField := sender.
  !

  doSomeAction:sender
    Transcript showLine:'executed some action'.
]
