//
//  MainWindow.m
//  MacRumors Mac Edition
//
//  Created by Alex Nichol on 7/8/10.
//  Copyright 2010 Jitsik. All rights reserved.
//

#import "MainWindow.h"


@implementation MainWindow

- (void)keyDown:(NSEvent *)evt {
	if ([evt keyCode] == 13 || [evt keyCode] == 12) {
		[self orderOut:self];
	}
}

- (BOOL)canBecomeMainWindow {
	return YES;
}

- (BOOL)canBecomeKeyWindow {
	return YES;
}

@end
