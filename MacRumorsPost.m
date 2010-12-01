//
//  MacRumorsPost.m
//  Rumors
//
//  Created by Alex Nichol on 7/6/10.
//  Copyright 2010 Jitsik. All rights reserved.
//

#import "MacRumorsPost.h"


@implementation MacRumorsPost

@synthesize title, content, author, datePosted;

+ (NSMutableArray *)postsOnMacRumors {
	NSURLRequest * theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.macrumors.com/"]
											   cachePolicy:NSURLRequestReloadIgnoringCacheData
										   timeoutInterval:10.0];
    NSData * urlData;
    NSURLResponse * response;
    NSError * error;
    urlData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];
	NSMutableArray * posts = [[NSMutableArray alloc] init];
	
	if (urlData) {
		NSString * str = [[NSString alloc] initWithData:urlData 
											   encoding:NSUTF8StringEncoding];
		if (!str) {
			str = [[NSString alloc] initWithData:urlData 
										encoding:NSWindowsCP1252StringEncoding];
		}
		if (!str) {
			[posts release];
			return nil;
		}
	
		if (str) {
			NSRange r = [str rangeOfString:@"<h3>"];
			while (r.location != NSNotFound) {
				MacRumorsPost * post = [[[MacRumorsPost alloc] init] autorelease];
				r.location += 5;
				r.length = 0;
				for (int i = r.location; i < [str length]; i++) {
					if ([str characterAtIndex:i] == '>') {
						r.location = i;
						break;
					}
				}
				for (int i = r.location; i < [str length]; i++) {
					if ([str characterAtIndex:i] != '<')
						r.length += 1;
					else
						break;
				}
				
				r.location += 1;
				r.length -= 1;
				
				post.title = [str substringWithRange:r];
				
				if ([post.title rangeOfString:@"\n"].location != NSNotFound) {
					break;
				}
				
				r = [str rangeOfString:@"<span class=\"datetag\">"];
				r.location += 22;
				r.length = 0;
				for (int i = r.location; i < [str length]; i++) {
					if ([str characterAtIndex:i] == ';' || [str characterAtIndex:i] == '<') {
						break;
					}
					r.length++;
				}
				post.datePosted = [str substringWithRange:r];

				
				
				r = [str rangeOfString:@"Written by "];
				if (r.location == NSNotFound) break;
				r.location += 11;
				r.length = 0;
				for (int i = r.location; i < [str length]; i++) {
					if ([str characterAtIndex:i] == '<') break;
					r.length += 1;
				}
				
				post.author = [str substringWithRange:r];
				
				r = [str rangeOfString:@"<div class=\"storybody\">"];
				NSRange r1 = [str rangeOfString:@"<p class=\"storycomments\">"];
				r.length = r1.location - r.location;
				
				post.content = [str substringWithRange:r];
				
				//NSLog(@"%d", r1.location+r1.length);
				
				//r.location += r.length;
				
				str = [str substringFromIndex:r1.location+r1.length];
				
				r = [str rangeOfString:@"<h3>"];
				[posts addObject:post];
				
				//NSLog(@"Str length %d", [str length]);
			}
		}
	} else {
		//NSLog(@"Invalid connection.");
		[posts release];
		return nil;
	}
	if ([posts count] == 0) {
		[posts release];
		return nil;
	}
	return [posts autorelease];
}
- (void)dealloc {
	self.datePosted = nil;
	self.title = nil;
	self.author = nil;
	self.content = nil;
	[super dealloc];
}
@end
