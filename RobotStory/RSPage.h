//
//  RSPage.h
//  RobotStory
//
//  Created by Nick on 06/08/2014.
//  Copyright (c) 2014 Bookclub. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RSPage;

@protocol RSPageNavigationDelegate <NSObject>

- (RSPage*) nextPage;
- (RSPage*) previousPage;

@end

@interface RSPage : UIViewController<RSPageNavigationDelegate>

@property (nonatomic, weak) NSString * backgroundImageName;
@property (nonatomic, weak) NSString * backgroundImageType;

- (void) displayPageCornerWithCurlName:(NSString*)curlName withDelay:(CGFloat)delay;

@end
