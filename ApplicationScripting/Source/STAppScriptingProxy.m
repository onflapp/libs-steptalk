/**
    STAppScriptingController
  
    Copyright (c)2022  onflapp
  
    Written by: onflapp
    Date: 2022
 
    This file is part of the StepTalk project.
 
    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 2 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.
  
    You should have received a copy of the GNU Lesser General Public
    License along with this library; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

   */

#import "STAppScriptingProxy.h"

#import <AppKit/NSApplication.h>
#import "NSApplication+additions.h"
#import "NSMenu+ScriptProxy.h"

STAppScriptingProxy *sharedAppScriptingProxy = nil;

@implementation STAppScriptingProxy
+ sharedAppScriptingProxy
{
    if(!sharedAppScriptingProxy)
    {
        sharedAppScriptingProxy = [[STAppScriptingProxy alloc] init];
    }
    
    return sharedAppScriptingProxy;
}

- init
{
    if ((self = [super init]) != nil)
    {
    }
    return self;
}

- (void)dealloc
{
    [currentFileScript release];
    [super dealloc];
}

- (STFileScript *) currentFileScript
{
    return currentFileScript;
}

- (void) setCurrentFileScript:(STFileScript *)fileScript
{
    ASSIGN(currentFileScript, fileScript);
}

- (void)__execScriptInMenu:(id) sender
{
    [self executeScript:[sender representedObject]];
}

- (void)activate
{
    [NSApp activateIgnoringOtherApps:YES];
}

- (void)terminate
{
    [NSApp terminate:self];
}

- (void)hide
{
    [NSApp hide:self];
}

- (void)open:(NSString *) file
{
    id del = [NSApp delegate];
    [del application: NSApp openFile: file];
}

- (void)open 
{
    [NSApp sendAction:@selector(openDocument:) to:nil from:self];
}

- (void)delay:(NSTimeInterval) tm
{
    NSDate* limit = [NSDate dateWithTimeIntervalSinceNow:tm];
    [[NSRunLoop currentRunLoop] runUntilDate: limit];
}

- (NSMenuItem*)menuItem:(NSString *) name
{
    return [[NSApp mainMenu]__findMenuItemForName: name];
}

- (void)removeMenuItem:(NSString *) name
{
    if (![[NSApp mainMenu] _isVisible])
    {
        NSLog(@"cannot modifify menu, not visible");
        return;
    }

    NSMenuItem *mi = [[NSApp mainMenu]__findMenuItemForName: name];
    if (mi)
    {
        NSMenu *menu = [mi menu];
        [[menu window] __saveMenuFrame];
        [menu removeItem:mi];
        [menu sizeToFit];
    }
}

- (void)addScript:(NSString *) script afterMenuItem:(NSString *) name
{
    if (![[NSApp mainMenu] _isVisible])
    {
        NSLog(@"cannot modifify menu, not visible");
        return;
    }

    NSMenuItem *mi = [[NSApp mainMenu]__findMenuItemForName: name];
    NSMenu *menu = [mi menu];

    if (!menu) menu = [NSApp scriptingMenu];

    [[menu window] __saveMenuFrame];

    id si = [menu addItemWithTitle:script
                            action:@selector(__execScriptInMenu:)
                     keyEquivalent:@""];

    [si setTarget:self];
    [si setRepresentedObject:script];

    [menu sizeToFit];
}

- (void)executeMenuItem:(NSString *) name
{
    NSMenuItem *mi = [[NSApp mainMenu]__findMenuItemForName: name];
    if (mi)
    {
        [NSApp sendAction:[mi action] to:[mi target] from:mi];
    }
}

- (void)executeScript:(NSString *) name
{

}

- (NSArray *)windows
{
    return [NSApp windows];
}

- (NSProcessInfo*) processInfo
{
    return [NSProcessInfo processInfo];
}

@end
