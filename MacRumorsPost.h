//
//  MacRumorsPost.h
//  Rumors
//
//  Created by iD Student on 7/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MacRumorsPost : NSObject {
	NSString * title;
	NSString * content;
	NSString * author;
	NSString * datePosted;
	
}
+ (NSMutableArray *)postsOnMacRumors;
@property (nonatomic, retain) NSString * datePosted;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * author;
@end
