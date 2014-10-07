//
//  RSHouseScene.m
//  RobotStory
//
//  Created by Nick on 30/08/2014.
//  Copyright (c) 2014 Bookclub. All rights reserved.
//

#import "RSHouseScene.h"
#import "RSRobotCreationScene.h"
#import "MCSpriteLayer.h"
#import "RSStyle.h"
#import "RSNoteView.h"
#import "RSAudioManager.h"

@interface RSHouseScene ()

@end

@implementation RSHouseScene

- (void)viewDidLoad
{
    self.backgroundImageName = @"house";
    self.backgroundImageType = @"jpg";
    [self displayPageCornerWithCurlName:@"gears_curl" withDelay:0.3f];
    
    RSNoteView * noteView = [[RSNoteView alloc] initWithFrame:CGRectMake(100.f, 200.f, 300.f, 200.f)];
    [noteView setTitle:@"Robot"];
    [noteView setBackgroundColor:[UIColor redColor]];
//    [self.view addSubview:noteView];
    
    [super viewDidLoad];
}

- (RSPage*) nextPage {
    return [RSRobotCreationScene new];
}

@end
