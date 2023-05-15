/**
    STAppDelegateController
  
    Copyright (c)2022  onflapp
  
    Written by: onflapp
    Date: 2022
 
    This file is part of the StepTalk project.

    STAppDelegateProxy makes sure scripts are getting consistent
    behaviour when called from stexec or within app context.

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

#import "STAppDelegateProxy.h"

#import <AppKit/NSApplication.h>
#import "NSApplication+additions.h"

@implementation STAppDelegateProxy

- initWithApp:(id) app
{
    if ((self = [super init]) != nil)
    {
        application = [app retain];
        delegate = [app delegate];
    }
    return self;
}

- (NSMethodSignature*) methodSignatureForSelector:(SEL)selector
{
    NSMethodSignature* signature = nil;

    signature = [application methodSignatureForSelector:selector];
    if (signature)
    {
        return signature;
    }
    signature = [delegate methodSignatureForSelector:selector];
    if (signature)
    {
        return signature;
    }

    return nil;
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    SEL selector = [invocation selector];
    if ([application respondsToSelector:selector])
    {
        [invocation invokeWithTarget:application];
    }
    else if ([delegate respondsToSelector:selector])
    {
        [invocation invokeWithTarget:delegate];
    }
}

- (BOOL)respondsToSelector:(SEL) selector
{
    if ([application respondsToSelector:selector])
    {
        return YES;
    }
    else if ([delegate respondsToSelector:selector])
    {
        return YES;
    }
    else 
    {
        return NO;
    }
}

- (id)forwardingTargetForSelector:(SEL) selector
{
    if ([application respondsToSelector:selector])
    {
        return application;
    }
    else if ([delegate respondsToSelector:selector])
    {
        return delegate;
    }
    else
    {
        return nil;
    }
}

- (void)dealloc
{
    [application release];
    [super dealloc];
}

@end
