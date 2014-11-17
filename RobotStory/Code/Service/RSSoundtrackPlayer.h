//
//  RSSoundtrackPlayer.h
//  RobotStory
//
//  Created by Nick on 17/11/2014.
//  Copyright (c) 2014 Bookclub. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSSoundtrackPlayer : NSObject

typedef NS_ENUM(NSInteger, RSTheme) {
    kMainTheme = 1
};

+ (RSSoundtrackPlayer*) sharedInstance;

- (void) playTheme:(RSTheme)theme;

@end
