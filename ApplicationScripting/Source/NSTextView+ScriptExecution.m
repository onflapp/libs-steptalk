/**
    NSTextView+ScriptExecution
    
    Application Scripting support - execution of selected text
  
    Copyright (c)2003 Stefan Urbanek
  
    Written by: Stefan Urbanek <urbanek@host.sk>
    Date: 2003 Mar 23
 
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
   
#import "NSTextView+ScriptExecution.h"

#import "NSApplication+additions.h"
#import "STApplicationScriptingController.h"

@implementation NSTextView(STScriptExecution)
- (void)executeSelectionScript:(id)sender
{
    STEnvironment      *env;
    NSString           *selectedString;
    NSRange             range = [self selectedRange];

    NSLog(@"Do!");

    env = [NSApp scriptingEnvironment];
    selectedString = [[self attributedSubstringFromRange:range] string];

    [[NSApp scriptingController] executeScriptString:selectedString
                                       inEnvironment:env];
}
- (void)executeAndShowSelectionScript:(id)sender
{
    STEnvironment      *env;
    NSString           *selectedString;
    NSRange             range = [self selectedRange];
    id                  retval = nil;
    BOOL                appendResult = YES;
    BOOL                hasFocus = ([[self window] firstResponder] == self);
    
    NSLog(@"Do and Show!");

    env = [NSApp scriptingEnvironment];
    selectedString = [[self attributedSubstringFromRange:range] string];

    retval = [[NSApp scriptingController] executeScriptString:selectedString
                                                inEnvironment:env];
                                                
    NSLog(@"Returned %@",retval);
    if([self isEditable])
    {
        NSString *retstr = [retval description];
        if ([retstr length] > 0)
        {
            NSRange r = [self selectedRange];
            r.location = r.location + [selectedString length];
            r.length = [retstr length];

            if (appendResult)
            {
                r.length += 1;
                retstr = [NSString stringWithFormat:@"%@\n%@", selectedString, retstr];
            }

            [self insertText:retstr];

            if (hasFocus)
                [self setSelectedRange:r];
        }
    }
    else
    {
        NSLog(@"Text is not editable!");
    }
}
@end
