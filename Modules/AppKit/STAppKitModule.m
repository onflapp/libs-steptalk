/**
    STAppKitModule.m
    AppKit bindings
 
    Copyright (c) 2002 Free Software Foundation

    Written by: Stefan Urbanek <urbanek@host.sk>
    Date: 2001 May 16
 
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

#import "STAppKitModule.h"

#import <AppKit/AppKit.h>
#import <Foundation/NSDictionary.h>
#import <Foundation/NSString.h>

@class NSApplication;
extern NSDictionary *STGetAppKitConstants();
extern NSDictionary *STGetAppKitNotifications();
extern NSDictionary *STGetAppKitExceptions();
extern NSDictionary *STGetAppKitEvents();

@implementation STAppKitModule
+ (void)initialize
{
    id p = nil;
    p = @protocol(NSApplicationDelegate);
    p = @protocol(NSWindowDelegate);
    p = @protocol(NSBrowserDelegate);
    p = @protocol(NSTableViewDelegate);
    p = @protocol(NSTextViewDelegate);
    p = @protocol(NSMenuDelegate);
    p = @protocol(NSMatrixDelegate);
    p = @protocol(NSCollectionViewDelegate);
    p = @protocol(NSAlertDelegate);

    [NSApplication sharedApplication];
}

+ (NSDictionary *)namedObjectsForScripting
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict addEntriesFromDictionary:STGetAppKitConstants()];
    [dict addEntriesFromDictionary:STGetAppKitNotifications()];
    [dict addEntriesFromDictionary:STGetAppKitExceptions()];
    [dict addEntriesFromDictionary:STGetAppKitEvents()];
    
    return [NSDictionary dictionaryWithDictionary:dict]; 
}
@end

