Environment loadModule:'SimpleUI'.
Transcript showLine:UI.
x := UI interfaceWithFile:'/home/oflorian/x.app/Resources/Launcher.gorm'.
x addMethodWithSource:'
  doSomething:sender
    Transcript showLine:sender.
'.

NSApplication sharedApplication run.
