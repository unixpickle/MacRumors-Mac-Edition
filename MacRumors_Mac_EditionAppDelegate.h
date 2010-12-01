//
//  MacRumors_Mac_EditionAppDelegate.h
//  MacRumors Mac Edition
//
//  Created by Alex Nichol on 7/6/10.
//  Copyright 2010 Jitsik. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import <Growl/Growl.h>


@interface MacRumors_Mac_EditionAppDelegate : NSObject <GrowlApplicationBridgeDelegate> {
    NSWindow * window;
	IBOutlet NSTableView * tv;
	IBOutlet WebView * wv;
	NSMutableArray * posts;
	NSPanel * wind;
	BOOL growlAvailible;
	NSString * latestTitle;
}

@property (nonatomic, retain) NSString * latestTitle;
@property (assign) IBOutlet NSWindow * window;

// undeclared previously
- (void)cancelShow:(id)sender;
- (void)focusApplication;
- (void)showMe:(id)sender;
- (void)latest:(id)sender;
- (void)closeWindow:(id)sender;
- (void)showMain;

- (NSMenu *)createMenu;
- (NSImage *)favicon;
- (void)rumors:(id)sender;
- (void)showWebsite:(id)sender;
- (void)quitApp:(id)sender;

- (void)newNews;
- (void)updateNews;

// Growl Methods
- (NSString *)applicationNameForGrowl;
- (void)growlNotificationWasClicked:(id)clickContext;
- (NSData *)applicationIconDataForGrowl;
- (void)growlIsReady;

@end
