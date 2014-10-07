//
//  RSSettingsManager.m
//  RobotStory
//
//  Created by Nick on 05/10/2014.
//  Copyright (c) 2014 Bookclub. All rights reserved.
//

#import "RSSettingsManager.h"

@implementation RSSettingsManager

+ (void) setObject:(id)object forKey:(RSSettingsKey)key {
    
    NSAssert(key < kNumberOfKeys, @"Should be a correct key");
    
    NSString * literalKey = [NSString stringWithFormat:@"RS_%d", (int)key];
    
    [[NSUserDefaults standardUserDefaults] setObject:object forKey:literalKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id) objectForKey:(RSSettingsKey)key {

    NSAssert(key < kNumberOfKeys, @"Should be a correct key");

    NSString * literalKey = [NSString stringWithFormat:@"RS_%d", (int)key];
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:literalKey];
}

@end
