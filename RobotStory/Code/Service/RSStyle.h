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

#define kRegularFontName @"Dyslexie"//@"Kohicle25"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define UIColorFromRGBAndAlpha(rgbValue, alphaValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphaValue]

#define kRegularTextColor UIColorFromRGB(0x050409)

@interface RSStyle : NSObject

+ (CGRect)screenBoundsFixedToPortraitOrientation;

+ (CGFloat)screenWidth;

+ (CGFloat)screenHeight;

@end
