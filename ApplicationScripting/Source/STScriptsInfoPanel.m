/**
    STScriptsPanel
  
    Copyright (c)2024 OnFlApp
  
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

#import "STScriptsInfoPanel.h"

#import <StepTalk/STFileScript.h>
#import <StepTalk/STScriptsManager.h>

#import <AppKit/NSApplication.h>
#import <AppKit/NSBrowserCell.h>
#import <AppKit/NSPopUpButton.h>
#import <AppKit/NSWorkspace.h>

#import "NSObject+NibLoading.h"

STScriptsInfoPanel *sharedScriptsInfoPanel = nil;

@implementation STScriptsInfoPanel
+ sharedScriptsInfoPanel
{
    if(!sharedScriptsInfoPanel)
    {
        sharedScriptsInfoPanel = [[STScriptsInfoPanel alloc] init];
    }
    
    return sharedScriptsInfoPanel;
}

- init
{
    if ((self = [super initWithContentRect:NSZeroRect
				 styleMask:NSTitledWindowMask 
                                          | NSClosableWindowMask 
                                          | NSResizableWindowMask
				   backing:NSBackingStoreRetained
				     defer:NO]) != nil)
    {
        NSView       *view;
        NSRect        frame;

        if (![self loadMyNibNamed:@"ScriptsInfoPanel"])
        {
            [self release];
            return nil;
        }

        frame = [[(NSPanel *)_panel contentView] frame];
        frame = [NSWindow frameRectForContentRect: frame
                                        styleMask: [self styleMask]];
	[self setFrame: frame display: NO];
        [self setTitle:[_panel title]];
        [self setFrame:[_panel frame] display:YES];
        [self setHidesOnDeactivate:YES];

        view = RETAIN([_panel contentView]);
        [_panel setContentView:nil];
        [self setContentView:view];

        RELEASE(view);
        RELEASE(_panel);

        [self setFrameUsingName:@"STScriptsInfoPanel"];
        [self setFrameAutosaveName:@"STScriptsInfoPanel"];
    }
    return self;
}
- (void)dealloc
{
    RELEASE(scriptInfoPath);
    RELEASE(delegate);
    [super dealloc];
}

- (void) save:(id)sender
{
  NSString* name = [nameField stringValue];
  NSString* desc = [[descriptionField textStorage] string];
  NSString* key = [keyField stringValue];

  if (scriptInfoPath && [name length]) 
  {
      NSMutableDictionary *vals = [NSMutableDictionary dictionary];
      [vals setValue:name forKey:@"Name"];
      if ([desc length])
        [vals setValue:desc forKey:@"Description"];
      if ([key length])
        [vals setValue:key forKey:@"MenuKey"];

      NSDictionary *dict = [NSDictionary dictionaryWithObject:vals forKey:@"Default"];
      [dict writeToFile:scriptInfoPath atomically:NO];

      [delegate update:self];
      [self orderOut:self];
  }
}

- (void)setDelegate:(id)anObject
{
    ASSIGN(delegate, anObject);
}
- (id)delegate
{
    return delegate;
}

- (void) orderFrontAndEditScriptInfo:(NSString*) path
{
    NSString *infoPath = [path stringByAppendingPathExtension:@"stinfo"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:infoPath];
    if (dict)
    {
        [nameField setStringValue:[dict valueForKeyPath:@"Default.Name"]];
        [keyField setStringValue:[dict valueForKeyPath:@"Default.MenuKey"]];
        [[[descriptionField textStorage] mutableString] setString:[dict valueForKeyPath:@"Default.Description"]];
    }
    else {
        [nameField setStringValue:[[path lastPathComponent] stringByDeletingPathExtension]];
        [keyField setStringValue:@""];
        [[[descriptionField textStorage] mutableString] setString:@""];
    }

    ASSIGN(scriptInfoPath, infoPath);
    [self makeKeyAndOrderFront:self];
}
@end
