//
//  RSDreamBubble.m
//  RobotStory
//
//  Created by Nick on 23/04/2015.
//  Copyright (c) 2015 Bookclub. All rights reserved.
//

#import "RSDreamBubble.h"

@interface RSDreamBubble ()

@end

@implementation RSDreamBubble

- (void)viewDidLoad {
    [super viewDidLoad];

    UIImageView * dreamImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [dreamImageView setImage:[UIImage imageNamed:@"dreamBubble.gif"]];
    [self.view addSubview:dreamImageView];
    
    UIImageView * frameImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [frameImageView setImage:[UIImage imageNamed:@"bubbleFrame"]];
    [self.view addSubview:frameImageView];
}



@end
