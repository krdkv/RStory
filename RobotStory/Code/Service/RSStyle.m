//
//  RSStyle.m
//  RobotStory
//
//  Created by Nick on 16/09/2014.
//  Copyright (c) 2014 Bookclub. All rights reserved.
//

#import "RSStyle.h"

@implementation RSStyle

+ (CGRect)screenBoundsFixedToPortraitOrientation {
    UIScreen *screen = [UIScreen mainScreen];
    
    if ([screen respondsToSelector:@selector(fixedCoordinateSpace)]) {
        return [screen.coordinateSpace convertRect:screen.bounds toCoordinateSpace:screen.fixedCoordinateSpace];
    }
    return screen.bounds;
}

+ (CGFloat)screenWidth {
    return [RSStyle screenBoundsFixedToPortraitOrientation].size.height;
}

+ (CGFloat)screenHeight {
    return [RSStyle screenBoundsFixedToPortraitOrientation].size.width;
}

@end
