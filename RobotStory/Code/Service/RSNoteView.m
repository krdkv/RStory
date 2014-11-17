//
//  RSNoteView.m
//  RobotStory
//
//  Created by Nick on 03/10/2014.
//  Copyright (c) 2014 Bookclub. All rights reserved.
//

#import "RSNoteView.h"
#import "RSStyle.h"

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

#define kHorizontalPadding 40.f
#define kVerticalPadding 30.f

@implementation RSNoteView

- (void) setTitle:(NSString*)title {
    
    UIFont * font = [UIFont fontWithName:kRegularFontName size:50.f];
    
    CGSize estimatedSize = [title sizeWithAttributes:@{NSFontAttributeName:font}];
    
    self.frame = CGRectMake(0.f, 0.f, estimatedSize.width + 2 * kHorizontalPadding, estimatedSize.height + 2 * kVerticalPadding);
    
    UILabel * label = [[UILabel alloc] initWithFrame:self.bounds];
    [label setFont:font];
    label.textColor = kRegularTextColor;
    label.text = title;
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    
    [self enableDragging];
    [self addBackground];
    [self addLightRotation];
}

- (void) addBackground {
    UIImage * paperImage = [[UIImage imageNamed:@"paperB"] resizableImageWithCapInsets:UIEdgeInsetsMake(136.f, 38.f, 250.f, 243.f)];
    self.layer.contents = (__bridge id)(paperImage.CGImage);
}

- (void) addLightRotation {
    double rads = DEGREES_TO_RADIANS(-1);
    CGAffineTransform transform = CGAffineTransformRotate(CGAffineTransformIdentity, rads);
    self.transform = transform;
}

- (void) setX:(CGFloat)x y:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.x = x;
    frame.origin.y = y;
    self.frame = frame;
}

@end
