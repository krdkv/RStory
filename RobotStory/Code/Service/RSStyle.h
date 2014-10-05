//
//  RSStyle.h
//  RobotStory
//
//  Created by Nick on 16/09/2014.
//  Copyright (c) 2014 Bookclub. All rights reserved.
//

#import <Foundation/Foundation.h>

#define OS_VERSION_EQUALS_OR_AFTER(version) [[[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."][0] intValue] >= version
#define OS_VERSION_BEFORE(version) [[[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."][0] intValue] < version

#define kScreenWidth     [UIScreen mainScreen].bounds.size.height
#define kScreenHeight    [UIScreen mainScreen].bounds.size.width

@interface RSStyle : NSObject

@end