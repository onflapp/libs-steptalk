/**
    SystemShell.m
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

#import "SystemShell.h"

#import <Foundation/Foundation.h>

static SystemShell *sharedSystemShell;

@implementation SystemShell:NSObject
+ (void)initialize
{
}
+ sharedSystemShell
{
    if(!sharedSystemShell)
    {
        sharedSystemShell = [[SystemShell alloc] init];
    }
    
    return sharedSystemShell;
}
- (NSString*) executeCommand:(NSString*)cmd 
{
    return [self executeCommand:cmd withArguments:nil];
}
- (NSString*) executeCommand:(NSString*)cmd withArguments:(NSArray*)args 
{
    NSPipe* pipe = [NSPipe pipe];
    NSFileHandle* fh = [pipe fileHandleForReading];
    NSTask* task = [[NSTask alloc] init];

    [task setLaunchPath:cmd];
    if([args count]) 
    {
        [task setArguments:args];
    }
    [task setStandardOutput:pipe];
    [task launch];

    NSData* data = [fh readDataToEndOfFile];
    NSString* rv = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    [task release];

    return rv;
}

- (NSString*) readString:(NSString*)path
{
    NSFileHandle* fl = nil;
    if ([path isEqualToString:@"/dev/stdin"]) {
        fl = [NSFileHandle fileHandleWithStandardInput];
    }

    NSData* buff = [fl readDataToEndOfFile];
    return [[[NSString alloc] initWithData:buff encoding:NSUTF8StringEncoding] autorelease];
}

@end
