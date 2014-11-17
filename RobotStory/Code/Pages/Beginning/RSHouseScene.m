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
#import <AVFoundation/AVFoundation.h>
#import "RSSoundtrackPlayer.h"

@interface RSHouseScene ()

@property (nonatomic, strong) UIImageView * houseView;
@property (nonatomic, strong) AVAudioPlayer * birdsPlayer;

@end

@implementation RSHouseScene

- (void)viewDidLoad
{
    self.backgroundImageName = @"house";
    self.backgroundImageType = @"jpg";
    [self displayPageCornerWithCurlName:@"gears_curl" withDelay:0.3f];
    
    _houseView = [[UIImageView alloc] initWithFrame:CGRectMake(225.f, 15.f, 582.f, 663.f)];
    _houseView.image = [UIImage imageNamed:@"house.png"];
    [self.view addSubview:_houseView];
    
    RSNoteView * noteView = [[RSNoteView alloc] init];
    [noteView setTitle:@"In a house on the hill \nthere lived a robot."];
    [noteView setX:20.f y:20.f];
    [self.view addSubview:noteView];
    
    __block UIImageView * houseSky1 = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 20.f, 1516.f, 279.f)];
    houseSky1.image = [UIImage imageNamed:@"houseSky1"];
    [self.view insertSubview:houseSky1 belowSubview:_houseView];
    
    __block UIImageView * houseSky2 = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 20.f, 1516.f, 279.f)];
    houseSky2.image = [UIImage imageNamed:@"houseSky2"];
    houseSky2.alpha = 0.9f;
    [self.view insertSubview:houseSky2 aboveSubview:_houseView];
    
    [UIView animateWithDuration:7.5f delay:0.f options:UIViewAnimationTransitionNone | UIViewAnimationOptionCurveLinear animations:^{
        CGRect frame = houseSky1.frame;
        frame.origin.x -= houseSky1.frame.size.width;
        
        houseSky1.frame = frame;
        houseSky2.frame = frame;
    } completion:^(BOOL finished) {
        [houseSky1 removeFromSuperview];
        houseSky1 = nil;
        
        [houseSky2 removeFromSuperview];
        houseSky2 = nil;
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self addClouds];
    });
    
    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"birds" ofType:@"caf"];
    _birdsPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:filePath] error:nil];
    [_birdsPlayer setNumberOfLoops:-1];
    _birdsPlayer.volume = 0.5f;
    [_birdsPlayer play];
    
    [[RSSoundtrackPlayer sharedInstance] playTheme:kMainTheme];
    
    [super viewDidLoad];
}

- (void) viewWillDisappear:(BOOL)animated {
    [_birdsPlayer stop];
}

- (void) addClouds {
    
    __block UIImageView * houseSky1 = [[UIImageView alloc] initWithFrame:CGRectMake(1516.f, 20.f, 1516.f, 279.f)];
    houseSky1.image = [UIImage imageNamed:@"houseSky1"];
    [self.view insertSubview:houseSky1 belowSubview:_houseView];
    
    __block UIImageView * houseSky2 = [[UIImageView alloc] initWithFrame:CGRectMake(1516.f, 20.f, 1516.f, 279.f)];
    houseSky2.image = [UIImage imageNamed:@"houseSky2"];
    houseSky2.alpha = 0.9f;
    [self.view insertSubview:houseSky2 aboveSubview:_houseView];
    
    [UIView animateWithDuration:15.f delay:0.f options:UIViewAnimationTransitionNone | UIViewAnimationOptionCurveLinear animations:^{
        CGRect frame = houseSky1.frame;
        frame.origin.x -= 2 *  houseSky1.frame.size.width;
        
        houseSky1.frame = frame;
        houseSky2.frame = frame;
    } completion:^(BOOL finished) {
        [houseSky1 removeFromSuperview];
        houseSky1 = nil;
        
        [houseSky2 removeFromSuperview];
        houseSky2 = nil;
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6.9f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self addClouds];
    });
}

- (RSPage*) nextPage {
    return [RSRobotCreationScene new];
}

@end
