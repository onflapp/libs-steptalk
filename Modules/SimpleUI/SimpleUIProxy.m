/* Copyright (C) 2020 Free Software Foundation, Inc.

   Written by:  onflapp
   Created: September 2020

   This file is part of the gs-desktop Project

   This program is free software; you can redistribute it and/or
   modify it under the terms of the GNU General Public License
   as published by the Free Software Foundation; either
   version 2 of the License, or (at your option) any later version.

   You should have received a copy of the GNU General Public
   License along with this program; see the file COPYING.
   If not, write to the Free Software Foundation,
   51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.

   */

#import	<AppKit/AppKit.h>
#import "SimpleUIProxy.h"

@implementation SimpleUIProxy

- (id) init {
  self = [super init];
  controls = [[NSMutableDictionary alloc] init];

  return self;
}

- (void) dealloc {
  [controls release];
  [delegate release];
  [super dealloc];
}

- (void) setDelegate:(id) del {
  ASSIGN(delegate, del);
}

- (id) delegate {
  return delegate;
}

- (NSDictionary*) controls {
  return controls;
}

- (BOOL)respondsToSelector:(SEL) aSelector {
  NSString* sel = NSStringFromSelector(aSelector);
  if ([sel hasPrefix:@"set"]) {
    return YES;
  }
  else if ([sel hasPrefix:@"do"]) {
    return YES;
  }
  else {
    return NO;
  }
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
  return nil;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
  return [NSMethodSignature signatureWithObjCTypes:"@^v^v^c@"];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
  NSString* sel = NSStringFromSelector([anInvocation selector]);
  id val = nil;
  [anInvocation getArgument:&val atIndex:2];

  if ([sel hasPrefix:@"set"]) {
    NSString* key = [sel substringFromIndex:3];
    key = [key substringToIndex:[key length] - 1];
    key = [key uppercaseString];

    if ([val isKindOfClass:[NSControl class]]) {
      [controls setValue:val forKey:key];
    }
    else if ([val isKindOfClass:[NSWindow class]]) {
      [controls setValue:val forKey:key];
    }
  }
  else if ([sel hasPrefix:@"do"]) {
    if ([delegate respondsToSelector:[anInvocation selector]]) {
      id val = nil;
      [anInvocation getArgument:&val atIndex:2];
      [delegate performSelector:[anInvocation selector] withObject:val];
    }
  }
}

@end
