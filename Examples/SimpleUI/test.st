Environment loadModule:'SimpleUI'.
Transcript showLine:UI.

" return STActor "

x := UI actorWithInterfaceFile:'test.gorm'.

x addMethodWithSource:'
  doSomething:sender
    Transcript showLine:TEXTFIELD.
    Transcript showLine:sender.
'.

Transcript showLine:x instanceVariableNames.
NSApplication sharedApplication run.
