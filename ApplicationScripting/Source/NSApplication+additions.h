/**
    NSApplication additions
  
    Copyright (c) 2000 Stefan Urbanek
  
    Written by: Stefan Urbanek <urbanek@host.sk>
    Date: 2001 Nov 15
 
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


#import <AppKit/NSApplication.h>

@class STEnvironment;
@class STApplicationScriptingController;

@interface NSApplication(STAppScriptingAdditions)
- (STEnvironment *)scriptingEnvironment;
- (STApplicationScriptingController *)scriptingController;

- (void)orderFrontScriptsPanel:(id)sender;
- (void)orderFrontTranscriptWindow:(id)sender;

- (NSMenu *)scriptingMenu;
- (void)setScriptingMenu:(NSMenu *)menu;

- (NSString *)applicationNameForScripting;

/* Application Scripting Proxy, Controller object should be avaiable for any app */
- (id) Controller;
@end
