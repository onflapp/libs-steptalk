/**
    STEngine.h
    Scripting engine
 
    Copyright (c) 2002 Free Software Foundation
 
    Written by: Stefan Urbanek <urbanek@host.sk>
    Date: 2000
   
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

#import <Foundation/NSObject.h>
#import <StepTalk/STMethod.h>

@class STEnvironment;
@class STLanguageEngine;
@class STMethod;

/** STEngine is abstract class for language engines used to intepret scripts.*/
@interface STEngine:NSObject
{
    STEnvironment *defaultEnvironment;
}

/** Instance creation */
+ (STEngine *) engineForLanguageWithName:(NSString *)name;
+ (STEngine *) engineForFileType:(NSString *)fileType;

/** Scripting Environment */
- (STEnvironment *)defaultEnvironment;
- (void) setDefaultEnvironment:(STEnvironment *)anEnvironment;

- (id)  executeCode:(NSString *)code;

- (id)  executeCode:(NSString *)code 
      inEnvironment:(STEnvironment *)env;

- (BOOL)understandsCode:(NSString *)code;

/* Methods */
- (STMethod *)methodFromSource:(NSString *)sourceString
                   forReceiver:(id)receiver
                 inEnvironment:(STEnvironment *)env;
- (id)  executeMethod:(id <STMethod>)aMethod
          forReceiver:(id)anObject
        withArguments:(NSArray *)args
        inEnvironment:(STEnvironment *)env;
@end