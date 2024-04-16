#import <AppKit/AppKit.h>

@interface NSMenu (ScriptProxy)
- (NSMenuItem *)__findMenuItemForName:(NSString *)name;
@end

@interface NSWindow (ScriptProxy)
- (void)__saveMenuFrame;
- (NSString*)__restoreMenuFrame:(id) currentLoc;
@end
