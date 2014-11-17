//
//  RSNoteView.h
//  RobotStory
//
//  Created by Nick on 03/10/2014.
//  Copyright (c) 2014 Bookclub. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+draggable.h"

@interface RSNoteView : UIView

- (void) setTitle:(NSString*)title;

- (void) setX:(CGFloat)x y:(CGFloat)y;

@end
