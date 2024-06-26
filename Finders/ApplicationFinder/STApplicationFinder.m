/**
    STApplicationFinder
 
    Copyright (c) 2002 Free Software Foundation

    Written by: Stefan Urbanek <urbanek@host.sk>
    Date: 2002 Jun 8
 
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

#import "STApplicationFinder.h"

#import <AppKit/NSWorkspace.h>

#import <Foundation/NSArray.h>
#import <Foundation/NSConnection.h>
#import <Foundation/NSDebug.h>
#import <Foundation/NSDictionary.h>
#import <Foundation/NSEnumerator.h>
#import <Foundation/NSFileManager.h>
#import <Foundation/NSPathUtilities.h>
#import <Foundation/NSSet.h>
#import <Foundation/NSString.h>

@implementation STApplicationFinder
- (NSArray *)applicationsInDirectory:(NSString *)path
{
    NSDirectoryEnumerator *enumerator;
    NSMutableArray        *array = [NSMutableArray array];
    NSString              *file;
    
    enumerator = [[NSFileManager defaultManager] enumeratorAtPath:path];
    
    while ( (file = [enumerator nextObject]) ) 
    {
        if ([[file pathExtension] isEqualToString:@"app"])
        {
            file = [file lastPathComponent];
            file = [file stringByDeletingPathExtension];
            [array addObject:file];
        }
    }
       
    return [NSArray arrayWithArray:array];
}

- (NSArray *)knownObjectNames
{
    NSEnumerator *enumerator;
    NSArray      *paths;
    NSString     *path;
    NSMutableSet        *set = [NSMutableSet set];
    
    paths = NSSearchPathForDirectoriesInDomains(NSAllApplicationsDirectory, 
                                                NSAllDomainsMask, YES);
       
    enumerator = [paths objectEnumerator];
    
    while( (path = [enumerator nextObject]) )
    {
        [set addObjectsFromArray:[self applicationsInDirectory:path]];
    }
    
    return [set allObjects];
}

- (id)connectApplicationWithName:(NSString *)name
{
    id app;

    NSDebugLLog(@"STFinder", @"Connecting application '%@'", name);
    app = [NSConnection rootProxyForConnectionWithRegisteredName:name 
    /* ... */                                               host:nil];

    return app;
}

- (id)objectWithName:(NSString *)name
{
    NSString *appName;
    
    if( ![[self knownObjectNames] containsObject:name] )
    {
        return nil;
    }

    id app = [self connectApplicationWithName:name];
    if (app) 
    {
        NSDebugLLog(@"STFinder", @"Found running '%@'", name);
        return app;
    }
    
    appName = [name stringByAppendingPathExtension:@"app"];

    NSDebugLLog(@"STFinder", @"Launching '%@'", name);
    
    if([[NSWorkspace sharedWorkspace] launchApplication:appName])
    {
        NSDebugLLog(@"STFinder", @"Connecting '%@'", name);
        NSInteger i;
        for (i = 0; i < 20; i++) {
            id app = [self connectApplicationWithName:name];
            if (app) return app;

            NSDebugLLog(@"STFinder", @"try again in 0.2s");
            NSDate* limit = [NSDate dateWithTimeIntervalSinceNow:0.2];
            [[NSRunLoop currentRunLoop] runUntilDate: limit];
        }
    }
    
    return nil;
}
@end

