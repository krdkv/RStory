//
//  RSPage.h
//  RobotStory
//
//  Created by Nick on 06/08/2014.
//  Copyright (c) 2014 Bookclub. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RSPage;

@protocol RSPageDelegate

- (void) shouldJumpToNextPage:(RSPage*)page;

@end

@interface RSPage : UIViewController<NSObject>

@property (nonatomic, weak) NSString * backgroundImageName;
@property (nonatomic, weak) NSString * backgroundImageType;

@property (nonatomic, weak) id<RSPageDelegate> delegate;

- (void) displayPageCornerWithCurlName:(NSString*)curlName withDelay:(CGFloat)delay;
- (void) hidePageCorner;

- (RSPage*) nextPage;
- (RSPage*) previousPage;

- (void) shouldJumpToNextPage;
- (void) shouldJumpToPreviousPage;

@end
