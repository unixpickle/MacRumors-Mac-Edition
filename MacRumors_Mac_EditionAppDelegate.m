//
//  MacRumors_Mac_EditionAppDelegate.m
//  MacRumors Mac Edition
//
//  Created by iD Student on 7/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MacRumors_Mac_EditionAppDelegate.h"
#import "MacRumorsPost.h"
#import <Carbon/Carbon.h>

@implementation MacRumors_Mac_EditionAppDelegate

@synthesize window;

- (void)cancelShow:(id)sender {
	[wind orderOut:self];
	wind = nil;
}
- (void)focusApplication {
	ProcessSerialNumber num;
	GetCurrentProcess(&num);
	SetFrontProcess(&num);
}

- (void)showMe:(id)sender {
	[self cancelShow:self];
	[window orderFront:self];
	[tv selectRow:0 byExtendingSelection:NO];
	[self tableView:tv shouldSelectRow:0];
	[window makeKeyWindow];
}
- (void)latest:(id)sender {
	[wind orderOut:self];
	wind = nil;
	[window orderFront:self];
	[tv selectRow:0 byExtendingSelection:NO];
	[self tableView:tv shouldSelectRow:0];
	[window makeKeyWindow];
}
- (void)showMain {
	[self performSelector:@selector(focusApplication) withObject:nil afterDelay:0.1];
	[window orderFront:self];
	[tv selectRow:0 byExtendingSelection:NO];
	[self tableView:tv shouldSelectRow:0];
	[window makeKeyWindow];
	[window makeMainWindow];
}
- (void)rumors:(id)sender {
	[self performSelector:@selector(showMain) withObject:nil afterDelay:0.1];
}
- (void)quitApp:(id)sender {
	exit(0);
}

- (NSMenu *)createMenu {
    NSZone * menuZone = [NSMenu menuZone];
    NSMenu * menu = [[NSMenu allocWithZone:menuZone] init];
    NSMenuItem * menuItem;
	
    // Add To Items
    menuItem = [menu addItemWithTitle:@"Show Rumors"
                               action:@selector(rumors:)
                        keyEquivalent:@""];
    menuItem = [menu addItemWithTitle:@"Quit"
                               action:@selector(quitApp:)
                        keyEquivalent:@""];
    [menuItem setTarget:self];
	
    return menu;
}

- (void)closeWindow:(id)sender {
	if (wind) {
		[[NSAnimationContext currentContext] setDuration:0.5];
		[NSAnimationContext beginGrouping];
		[[wind animator] setAlphaValue:0.0];
		[wind performSelector:@selector(orderOut:) withObject:self afterDelay:1.2];
		wind = nil;
		[NSAnimationContext endGrouping];
	}
}

- (void)newNews {
	if ([GrowlApplicationBridge isGrowlRunning]) {
		// just throw up a growl notification
		[GrowlApplicationBridge
		 notifyWithTitle:@"Macrumors!"
		 description:@"A new macrumors article was detected."
		 notificationName:@"New Macrumors Article"
		 iconData:nil
		 priority:0
		 isSticky:NO
		 clickContext:@"Show"];
		return;
	}
	if (wind) {
		// do nothing
		[wind orderOut:self];
	}
	NSRect r = [[NSScreen mainScreen] frame];
	NSPanel * notification = [[NSPanel alloc] initWithContentRect:NSMakeRect(r.size.width - 270, r.size.height - 130, 250, 100) styleMask:(NSHUDWindowMask) backing:NSBackingStoreBuffered defer:YES];
	NSView * v = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 250, 150)];
	NSTextField * tf = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 150, 250)];
	[notification setHidesOnDeactivate:NO];
	[notification setWorksWhenModal:YES];
	[[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
	[tf setStringValue:@"New MacRumors article!"];
	[tf setTextColor:[NSColor whiteColor]];
	[tf setFont:[NSFont boldSystemFontOfSize:18.0]];
	[tf setBordered:NO];
	[tf setSelectable:NO];
	[tf setEditable:NO];
	[tf setDrawsBackground:NO];
	[tf setBackgroundColor:[NSColor clearColor]];
	[tf sizeToFit];
	[tf setFrameOrigin:NSMakePoint(([v frame].size.width / 2) - ([tf frame].size.width / 2), ([v frame].size.height / 2) - (([tf frame].size.height / 2) - 0))];
	[v addSubview:tf];
	NSButton * btn = [[NSButton alloc] initWithFrame:NSMakeRect((([v frame].size.width / 2) - 40) - 50, 10, 80, 30)];
	[btn setTitle:@"Show Me"];
	[btn setBezelStyle:NSTexturedRoundedBezelStyle];
	[btn setTarget:self];
	[btn setAction:@selector(showMe:)];
	
	NSButton * btn1 = [[NSButton alloc] initWithFrame:NSMakeRect((([v frame].size.width / 2) - 40) + 50, 10, 80, 30)];
	[btn1 setTitle:@"Dismiss"];
	[btn1 setBezelStyle:NSTexturedRoundedBezelStyle];
	[btn1 setTarget:self];
	[btn1 setAction:@selector(closeWindow:)];
	
	[v addSubview:btn];
	[v addSubview:btn1];
	[notification setLevel:CGShieldingWindowLevel()];
	[notification setContentView:v];
	[notification setAlphaValue:0];
	[notification orderFront:self];
	[[NSAnimationContext currentContext] setDuration:1];
	[NSAnimationContext beginGrouping];
	[[notification animator] setAlphaValue:1];
	[tf setNeedsDisplay:YES];
	[NSAnimationContext endGrouping];
	wind = notification;
	
}

- (void)updateNews {
	while (true) {
		NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
		NSMutableArray * nposts = [MacRumorsPost postsOnMacRumors];
		
		if (nposts) {
			if ([nposts count] > 0) {
				if (posts) {
					if (![[[nposts objectAtIndex:0] title] isEqual:[[posts objectAtIndex:0] title]]) {
						posts = [nposts retain];
						[tv performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
						[self performSelectorOnMainThread:@selector(newNews) withObject:nil waitUntilDone:YES];
					}
				} else {
					posts = [nposts retain];
					[tv performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
					[self performSelectorOnMainThread:@selector(newNews) withObject:nil waitUntilDone:YES];
				}
			}
		}
		[NSThread sleepForTimeInterval:3.0];
		[pool drain];
	}
}

- (NSImage *)favicon {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	NSImage * img1 = [NSImage imageNamed:@"faviconBEST.png"];
	NSImage * retv = [[NSImage alloc] initWithSize:NSMakeSize(20, 19)];
	[retv lockFocus];
	[img1 drawInRect:NSMakeRect(0, 0, [retv size].width, [retv size].height) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
	[retv unlockFocus];
	[pool drain];
	return [retv autorelease];
}

- (void)awakeFromNib {
	wind = nil;
	[self performSelectorInBackground:@selector(updateNews) withObject:nil];
	[tv setDataSource:self];
	[tv setDelegate:self];

	growlAvailible = NO;
	[GrowlApplicationBridge setGrowlDelegate:self];
	
	NSMenu * menu = [self createMenu];
    NSStatusItem * _statusItem = [[[NSStatusBar systemStatusBar]
                                   statusItemWithLength:NSSquareStatusItemLength] retain];
    [_statusItem setMenu:menu];
    [_statusItem setHighlightMode:YES];
    [_statusItem setToolTip:@"MacRumors"];
    [_statusItem setImage:[self favicon]];
	
	//[window performSelector:@selector(activateIgnoringOtherApps:) withObject:self afterDelay:1.0];
	//[window performSelector:@selector(orderFrontRegardless) withObject:nil afterDelay:1.0];
	//[window performSelector:@selector(orderOut:) withObject:self afterDelay:0];
}

#pragma mark Table View Methods

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView {
	return [posts count];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {
	if ([[aTableColumn identifier] isEqual:@"title"])
		return [[posts objectAtIndex:rowIndex] title];
	else if ([[aTableColumn identifier] isEqual:@"author"])
		return [[posts objectAtIndex:rowIndex] author];
	else if ([[aTableColumn identifier] isEqual:@"date"])
		return [[posts objectAtIndex:rowIndex] datePosted];
	return nil;
}

- (BOOL)tableView:(NSTableView *)aTableView shouldSelectRow:(NSInteger)rowIndex {
	MacRumorsPost * post = [posts objectAtIndex:rowIndex];
	NSString * str = [NSString stringWithFormat:@"<head><style type=\"text/css\">\np.quote\n{\npadding-left:1em;\nfont-style:italic;\n}\n</style></head><body><h1>%@</h1><font face=\"Helvetica\">%@</font></body>", [post title], [post content]];
	[[wv mainFrame] loadHTMLString:str baseURL:[NSURL URLWithString:@"http://macrumors.com/"]];
	return YES;
}

#pragma mark Growl Methods

- (NSString *)applicationNameForGrowl {
	//growlAvailible = YES;
	return @"Macrumors";
}
- (void)growlNotificationWasClicked:(id)clickContext {
	// here we show it
	NSLog(@"%@", clickContext);
	[window orderFront:self];
	[tv selectRow:0 byExtendingSelection:NO];
	[self tableView:tv shouldSelectRow:0];
	[window makeKeyWindow];
}
- (NSData *)applicationIconDataForGrowl {
	// give it some universal icon.
	return [[NSImage imageNamed:@"smallicon.png"] TIFFRepresentation];
}
- (void)growlIsReady {
	// excelent
}

@end
