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

NSMenuItem *__findMenuItem(NSString *name, NSMenu *menu) {
    if (!name) return nil;

    NSRange r = [name rangeOfString:@"/"];
    NSString *n = name;
    NSString *p = nil;
    if (r.location != NSNotFound) 
    {
        n = [name substringToIndex:r.location];
        p = [name substringFromIndex:r.location+1];
    }
    
    NSInteger i = [menu indexOfItemWithTitle:n];
    if ([p length] == 0) 
    {
        if (i >= 0) return [menu itemAtIndex:i];
        return nil;
    }
    else if (i >= 0) 
    {
        NSMenuItem *mi = [menu itemAtIndex:i];
        if ([mi submenu]) return __findMenuItem(p, [mi submenu]);
        else return nil;
    }

    return nil;
}

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

- (void)open:(NSString*) file
{
    id del = [NSApp delegate];
    [del application: NSApp openFile: file];
}

- (void)open 
{
    [NSApp sendAction:@selector(openDocument:) to:nil from:self];
}

- (void)addScript:(NSString *) script afterMenu:(NSString *) name
{
    NSMenuItem *mi = __findMenuItem(name, [NSApp mainMenu]);
    NSMenu *menu = [mi menu];

    if (!menu) menu = [NSApp scriptingMenu];

    id si = [menu addItemWithTitle:script
                            action:@selector(__execScriptInMenu:)
                     keyEquivalent:@""];

    [si setTarget:self];
    [si setRepresentedObject:script];
}

- (void)executeMenuAction:(NSString *) name
{
    NSMenuItem *mi = __findMenuItem(name, [NSApp mainMenu]);
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
