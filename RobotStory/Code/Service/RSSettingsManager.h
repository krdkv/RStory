//
//  RSSettingsManager.h
//  RobotStory
//
//  Created by Nick on 05/10/2014.
//  Copyright (c) 2014 Bookclub. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, RSSettingsKey) {
    kRobotHead = 0,
    kRobotBody,
    kRobotLegs,
    kRobotName,
    kHaveAskedForMicPermission,
    kNumberOfKeys
};

@interface RSSettingsManager : NSObject

+ (void) setObject:(id)object forKey:(RSSettingsKey)key;

+ (id) objectForKey:(RSSettingsKey)key;

@end
