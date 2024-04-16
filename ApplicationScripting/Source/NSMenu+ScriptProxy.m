/**
    NSMenu
  
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

#import "NSMenu+ScriptProxy.h"

NSMutableDictionary *menu_scriptproxy_frames = nil;

@implementation NSMenu (ScriptProxy)
- (NSMenuItem *)__findMenuItemForName:(NSString *)name 
{
    if (!name) return nil;

    NSRange r = [name rangeOfString:@"/"];
    NSString *n = name;
    NSString *p = nil;
    if (r.location != NSNotFound) 
    {
        n = [name substringToIndex:r.location];
        p = [name substringFromIndex:r.location+1];
    }
    
    NSInteger i = [self indexOfItemWithTitle:n];
    if ([p length] == 0) 
    {
        if (i >= 0) return [self itemAtIndex:i];
        return nil;
    }
    else if (i >= 0) 
    {
        NSMenuItem *mi = [self itemAtIndex:i];
        if ([mi submenu]) return [[mi submenu] __findMenuItemForName:p];
        else return nil;
    }

    return nil;
}
@end

@implementation NSWindow (ScriptProxy)
+ (void) load
{
    menu_scriptproxy_frames = [[NSMutableDictionary alloc] init];

    Class class = [self class];

    SEL originalSelector = @selector(stringWithSavedFrame);
    SEL swizzledSelector = @selector(swizzled_stringWithSavedFrame);

    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);

    IMP originalImp = method_getImplementation(originalMethod);
    IMP swizzledImp = method_getImplementation(swizzledMethod);

    class_replaceMethod(class,
                swizzledSelector,
                originalImp,
                method_getTypeEncoding(originalMethod));
    class_replaceMethod(class,
                originalSelector,
                swizzledImp,
                method_getTypeEncoding(swizzledMethod));
}

- (NSString*) swizzled_stringWithSavedFrame
{
    NSString* n = [[self class] className];
    if ([n isEqualToString:@"NSMenuPanel"])
    {
        NSString *f = [self swizzled_stringWithSavedFrame];
        return [self __restoreMenuFrame:f];
    }
    else {
        return [self swizzled_stringWithSavedFrame];
    }
}

- (void)__saveMenuFrame
{
    NSString *f = [self swizzled_stringWithSavedFrame];
    NSString *v = [menu_scriptproxy_frames valueForKey:[self description]];

    if (f != nil && v == nil)
    {
        [menu_scriptproxy_frames setValue:f forKey:[self description]];
    }
}

/*
 * we need to restore the old auto save frames
 * to take into consideration removed/added menu items
 * if we don't do that, menu might end up placed out of 
 * the screen after app's restart
 */

- (NSString*)__restoreMenuFrame:(id) currentLoc
{
    NSString *savedLoc = [menu_scriptproxy_frames valueForKey:[self description]];
    if (!savedLoc)
        return currentLoc;

    NSArray *s = [savedLoc componentsSeparatedByString:@" "];
    NSArray *c = [currentLoc componentsSeparatedByString:@" "];

    if ([s count] == 10 && [s count] == [c count])
    {
       NSMutableArray *n = [c mutableCopy];
       //NSInteger sy = [[s objectAtIndex: 2] integerValue];
       NSInteger sh = [[s objectAtIndex: 3] integerValue];
       NSInteger cy = [[c objectAtIndex: 1] integerValue];
       NSInteger ch = [[c objectAtIndex: 3] integerValue];

       NSInteger d = sh - ch;
       if (d > 0)
       {
         [n replaceObjectAtIndex: 1 withObject: [NSString stringWithFormat:@"%ld", (cy - d)]];
         [n replaceObjectAtIndex: 3 withObject: [NSString stringWithFormat:@"%ld", (sh)]];

         NSString *rv = [n componentsJoinedByString: @" "]; 
         NSLog(@"%ld [%@] => [%@]", d, currentLoc, rv);

         [n release];
         return rv;
       }
    }
    return currentLoc;
}

@end

