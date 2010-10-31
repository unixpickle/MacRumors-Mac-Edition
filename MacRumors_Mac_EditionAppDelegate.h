//
//  MacRumors_Mac_EditionAppDelegate.h
//  MacRumors Mac Edition
//
//  Created by iD Student on 7/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
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
}

@property (assign) IBOutlet NSWindow * window;

@end
