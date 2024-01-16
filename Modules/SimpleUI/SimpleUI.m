/**
    UserInterface.m
    StepTalk System Shell
 
    Copyright (c) 2023 Free Software Foundation
 
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

#import "SimpleUI.h"

#import <Foundation/Foundation.h>
#import "SimpleUIProxy.h"
#import "../../Frameworks/StepTalk/STActor.h"

static SimpleUI *sharedSimpleUI;

@implementation SimpleUI:NSObject
+ (void)initialize
{
}
+ sharedSimpleUI
{
    if(!sharedSimpleUI)
    {
        sharedSimpleUI = [[SimpleUI alloc] init];
    }
    
    return sharedSimpleUI;
}

- (id) init {
    self = [super init];
    interfaceObjects = [[NSMutableDictionary alloc] init];
    interfaceSearchPath = [[NSMutableArray alloc] init];
    return self;
}

- (void) dealloc {
    RELEASE(interfaceObjects);
    [super dealloc];
}

- (NSString*) findInterfaceFile:(NSString*) file {
    NSFileManager* fm = [NSFileManager defaultManager];
    return file;
}

- (id) interfaceWithFile:(NSString*) file {
    id io = [[interfaceObjects valueForKey:file] delegate];
    if (io) return io;

    SimpleUIProxy* proxy = [[SimpleUIProxy alloc] init];
    NSMutableDictionary* o = [NSMutableDictionary dictionary];
    [o setValue:proxy forKey:@"NSOwner"];
    BOOL rv = [NSBundle loadNibFile:file externalNameTable:o withZone:[proxy zone]];

    if (rv) {
        STActor* actor = [STActor actor];
        [proxy setDelegate:actor];
        for (NSString* key in [[proxy controls] allKeys]) {
            id val = [[proxy controls] valueForKey:key];
            [actor addInstanceVariable:key];
            [actor setValue:val forKey:key];
        }

        [interfaceObjects setValue:proxy forKey:file];
        [proxy release];
        return actor;
    }
    else {
        NSLog(@"unable to load interface file %@", file);
        return nil;
    }
}
 
@end
