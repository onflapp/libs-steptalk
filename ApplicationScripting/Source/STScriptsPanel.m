/**
    STScriptsPanel
  
    Copyright (c)2002 Stefan Urbanek
  
    Written by: Stefan Urbanek <urbanek@host.sk>
    Date: 2002 Mar 15
 
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

#import "STScriptsPanel.h"

#import <StepTalk/STFileScript.h>
#import <StepTalk/STScriptsManager.h>

#import <AppKit/NSApplication.h>
#import <AppKit/NSBrowser.h>
#import <AppKit/NSBrowserCell.h>
#import <AppKit/NSMatrix.h>
#import <AppKit/NSPopUpButton.h>
#import <AppKit/NSWorkspace.h>
#import <AppKit/NSGraphics.h>

#import "NSObject+NibLoading.h"
#import "STApplicationScriptingController.h"
#import "STScriptsInfoPanel.h"

STScriptsPanel *sharedScriptsPanel = nil;

@implementation STScriptsPanel
+ sharedScriptsPanel
{
    if(!sharedScriptsPanel)
    {
        sharedScriptsPanel = [[STScriptsPanel alloc] init];
    }
    
    return sharedScriptsPanel;
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

        if (![self loadMyNibNamed:@"ScriptsPanel"])
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

        [self setFrameUsingName:@"STScriptsPanel"];
        [self setFrameAutosaveName:@"STScriptsPanel"];

        [scriptList setTarget:self];
        [scriptList setAction:@selector(selectScript:)];
        [scriptList setDoubleAction:@selector(run:)];
        [scriptList setMaxVisibleColumns:1];

        scriptsManager = RETAIN([STScriptsManager defaultManager]);

        [self update:nil];
    }
    return self;
}
- (void)dealloc
{
    RELEASE(scripts);
    RELEASE(scriptsManager);
    RELEASE(delegate);
    [super dealloc];
}
- (void)setDelegate:(id)anObject
{
    ASSIGN(delegate, anObject);
}
- (id)delegate
{
    return delegate;
}
- (void)setScriptsManager:(STScriptsManager *)aManager
{
    ASSIGN(scriptsManager,aManager);
}
- (STScriptsManager *)scriptsManager
{
    return scriptsManager;
}
- (void) run: (id)sender
{
    STFileScript *script = [self selectedScript];

    if(script)
    {
        [delegate executeScript:script];
    }
}

- (void) selectScript: (id)sender
{
    STFileScript *script = [self selectedScript];
    NSString *description = [script scriptDescription];

    if (!description)
	description = @"";
    [descriptionText setString:description];
    [runButton setEnabled:script ? YES : NO];
}

- (void)command:(id)sender
{
    switch([sender indexOfSelectedItem])
    {
    case 1: [self update:nil]; break;
    case 2: [self browse:nil]; break;
    case 3: [self edit:nil]; break;
    case 4: [self editInfo:nil]; break;
    case 5: [self showHelp:nil]; break;
    }
}
- (void)browse:(id)sender
{
    NSWorkspace  *ws = [NSWorkspace sharedWorkspace];
    STFileScript *script = [self selectedScript];
    NSString     *path = [[script fileName] stringByDeletingLastPathComponent];

    if(script)
    {
        [ws selectFile:[script fileName] inFileViewerRootedAtPath:path];
    }
    else
    {
        NSString       *path = [[scriptsManager scriptSearchPaths] firstObject];
        NSFileManager  *manager = [NSFileManager defaultManager];
        BOOL            isDir;

        if(! [manager fileExistsAtPath:path isDirectory:&isDir]) {
          [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:NULL];
        }
        [ws selectFile:path inFileViewerRootedAtPath:@"/"];
    }
}

- (NSArray *) scripts;
{
    return scripts;
}

- (void)update:(id)sender
{
    RELEASE(scripts);
    scripts = [scriptsManager allScripts];
    scripts = [scripts sortedArrayUsingSelector:
                                @selector(compareByLocalizedName:)];
    RETAIN(scripts);
    
    [scriptList reloadColumn:0];
    [self selectScript:nil];
    [delegate updateScriptItems];
}

- (STFileScript *)selectedScript
{
    if([scriptList selectedCell])
    {
        return [scripts objectAtIndex:[scriptList selectedRowInColumn:0]];
    }
    else
    {
        return 0;
    }
}

- (NSInteger) browser: (NSBrowser *) sender
 numberOfRowsInColumn: (NSInteger) column
{
    return [scripts count];
}
- (void) browser: (NSBrowser *) sender
 willDisplayCell: (NSBrowserCell *) cell
           atRow: (NSInteger) row
          column: (NSInteger) column
{
    NSString *name;
    if(sender != scriptList)
    {
        NSLog(@"Invalid browser, not scriptList");
        return;
    }
    
    [cell setLeaf:YES];
    name = [[scripts objectAtIndex:row] localizedName];
    [cell setStringValue:name];
}

- (void)edit:(id)sender
{
    NSString *scriptPath = [[self selectedScript] fileName]; 
    if (scriptPath)
    {
        [[NSWorkspace sharedWorkspace] openFile:scriptPath];
    }
}

- (void)editInfo:(id)sender
{
    NSString *scriptPath = [[self selectedScript] fileName]; 
    if (scriptPath)
    {
        STScriptsInfoPanel *infoPanel = [STScriptsInfoPanel sharedScriptsInfoPanel];
        [infoPanel setDelegate:self];
        [infoPanel orderFrontAndEditScriptInfo:scriptPath];
    }
}

- (void)showHelp:(id)sender
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *file = [bundle pathForResource: @"ApplicationScripting" 
                                      ofType: @"xlp"]; 
    
    if (!file)
    {
        bundle = [NSBundle bundleForClass:[self class]];
        file = [bundle pathForResource: @"ApplicationScripting" 
                            ofType: @"xlp"];
    }

    if (file) 
    {
        [[NSWorkspace sharedWorkspace] openFile: file];
        return;
    }
    else
    {
        NSBeep();
    }
}
@end
