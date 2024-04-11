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
        savedMenuFrames = [[NSMutableDictionary alloc] init];

        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver: self
               selector: @selector(__restoreMenuFrames:)
                   name: NSApplicationDidResignActiveNotification 
                 object: NSApp];

    }
    return self;
}

- (void)dealloc
{
    [savedMenuFrames release];
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

- (void)__saveMenuFrame:(NSMenu *) menu
{
    NSString *key   = [menu _locationKey];
    NSString *frame = [[menu window] stringWithSavedFrame];

    if (key == nil)
        return;

    if ([savedMenuFrames valueForKey: key] == nil)
    {
        [savedMenuFrames setValue: frame forKey: key];
    }
}

/*
 * we need to restore the old auto save frames
 * to take into consideration removed/added menu items
 * if we don't do that, menu might end up placed out of 
 * the screen after app's restart
 */

- (void)__restoreMenuFrames:(id) notification
{
    NSUserDefaults	    *defaults;
    NSMutableDictionary	*menuLocations;
    NSString		        *savedLoc;
    NSString		        *currentLoc;
    NSInteger            changes = 0;

    defaults = [NSUserDefaults standardUserDefaults];
    menuLocations = [defaults objectForKey: @"NSMenuLocations"];
    if ([menuLocations isKindOfClass: [NSDictionary class]])
        menuLocations = AUTORELEASE([menuLocations mutableCopy]);
    else
        return;

    for (NSString *key in [menuLocations allKeys])
    {
        currentLoc = [menuLocations valueForKey: key];
        savedLoc = [savedMenuFrames valueForKey: key];

        if (savedLoc && [currentLoc isEqualToString: savedLoc] == NO)
        {
            NSArray *s = [savedLoc componentsSeparatedByString:@" "];
            NSArray *c = [currentLoc componentsSeparatedByString:@" "];

            if ([s count] == 10 && [s count] == [c count])
            {
                NSMutableArray *n = [c mutableCopy];
                //NSInteger sy = [[s objectAtIndex: 2] integerValue];
                NSInteger sh = [[s objectAtIndex: 3] integerValue];
                NSInteger cy = [[c objectAtIndex: 2] integerValue];
                NSInteger ch = [[c objectAtIndex: 3] integerValue];

                NSInteger d = sh - ch;
                if (d > 0)
                {
                    [n replaceObjectAtIndex: 2 withObject: [NSString stringWithFormat:@"%ld", (cy - d)]];
                    [n replaceObjectAtIndex: 3 withObject: [NSString stringWithFormat:@"%ld", (sh)]];

                    [menuLocations setValue: [n componentsJoinedByString:@" "] forKey: key];
                    [n release];
                    changes++;
                }
            }
        }
    }

    if (changes)
    {
        [defaults setObject:menuLocations forKey: @"NSMenuLocations"];
    }
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
    return __findMenuItem(name, [NSApp mainMenu]);
}

- (void)removeMenuItem:(NSString *) name
{
    NSMenuItem *mi = __findMenuItem(name, [NSApp mainMenu]);
    if (mi)
    {
        NSMenu *menu = [mi menu];
        [self __saveMenuFrame:menu];
        [menu removeItem:mi];
    }
}

- (void)addScript:(NSString *) script afterMenuItem:(NSString *) name
{
    NSMenuItem *mi = __findMenuItem(name, [NSApp mainMenu]);
    NSMenu *menu = [mi menu];

    if (!menu) menu = [NSApp scriptingMenu];

    [self __saveMenuFrame:menu];

    id si = [menu addItemWithTitle:script
                            action:@selector(__execScriptInMenu:)
                     keyEquivalent:@""];

    [si setTarget:self];
    [si setRepresentedObject:script];
}

- (void)executeMenuItem:(NSString *) name
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
