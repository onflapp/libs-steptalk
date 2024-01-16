/**
    STActor
    StepTalk actor
  
    Copyright (c) 2002 Free Software Foundation
  
    Written by: Stefan Urbanek <urbanek@host.sk>
    Date: 2005 June 30
    License: LGPL
     
    This file is part of the StepTalk project.
*/

#import <Foundation/NSObject.h>

#import "STMethod.h"

@class NSMutableDictionary;
@class NSDictionary;
@class NSArray;
@class STEnvironment;

@interface STActor:NSObject<NSCoding>
{
    NSMutableDictionary *ivars;
    NSMutableDictionary *methodDictionary;
    
    STEnvironment       *environment;
}
+ actorInEnvironment:(STEnvironment *)env;
+ actor;
- initWithEnvironment:(STEnvironment *)env;
- (void)setEnvironment:(STEnvironment *)env;
- (STEnvironment *)environment;

- (NSArray *)instanceVariableNames;
- (void)setInstanceVariables:(NSDictionary *)dictionary;
- (NSDictionary *)instanceVariables;
- (void)addInstanceVariable:(NSString *)aName;
- (void)removeInstanceVariable:(NSString *)aName;

- (id <STMethod>)addMethodWithSource:(NSString *)source;
- (void)addMethod:(id <STMethod>)aMethod;
- (id <STMethod>)methodWithName:(NSString *)aName;
- (void)removeMethod:(id <STMethod>)aMethod;
- (void)removeMethodWithName:(NSString *)aName;
- (NSArray *)methodNames;
- (NSDictionary *)methodDictionary;
@end
