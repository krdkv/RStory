//
//  RSCaveEnterScene.m
//  RobotStory
//
//  Created by Nick on 05/10/2014.
//  Copyright (c) 2014 Bookclub. All rights reserved.
//

#import "RSCaveEnterScene.h"
#import "RSMapScene.h"
#import <AVFoundation/AVFoundation.h>
#import "RSSettingsManager.h"
#import "RSStyle.h"

@interface RSCaveEnterScene ()

@property (nonatomic, strong) UIImageView * eyesImageView;
@property (nonatomic, strong) UIImageView * pupilsImageView;
@property (nonatomic, assign) NSInteger eyesNumber;

@end

@implementation RSCaveEnterScene

- (void)viewDidLoad {
    
    _eyesNumber = [[RSSettingsManager objectForKey:kRobotHead] intValue];
    
    UIImage * eyesBackgroundImage = [UIImage imageNamed:[NSString stringWithFormat:@"eyes%ld", (long)_eyesNumber]];
    
    _eyesImageView = [[UIImageView alloc] initWithImage:eyesBackgroundImage];
    
    CGSize imageSize = CGSizeMake(eyesBackgroundImage.size.width/2, eyesBackgroundImage.size.height/2);
    CGPoint point, pupilsShift;
    
    switch (_eyesNumber) {
        case 0:
            point = CGPointMake(383.f, 390.f);
            break;
            
        case 1:
            point = CGPointMake(([RSStyle screenWidth] - imageSize.width)/2, 534.f);
            pupilsShift = CGPointMake(3.f, -5.f);
            break;
            
        case 2:
            point = CGPointMake(([RSStyle screenWidth] - imageSize.width)/2, 532.f);
            pupilsShift = CGPointMake(10.f, -20.f);
            break;
            
        case 3:
            point = CGPointMake(([RSStyle screenWidth] - imageSize.width)/2, 563.f);
            pupilsShift = CGPointMake(5.f, -8.f);
            break;
    }
    
    _eyesImageView.frame = CGRectMake(point.x, point.y, imageSize.width, imageSize.height);
    [self.view addSubview:_eyesImageView];
    
    _pupilsImageView = [[UIImageView alloc] initWithFrame:_eyesImageView.frame];
    _pupilsImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"eyes%ld_1", _eyesNumber]];
    
    if ( _eyesNumber == 0 ) {
        _pupilsImageView.alpha = 0.f;
    }
    
    [self.view addSubview:_pupilsImageView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ( _eyesNumber != 0 ) {
            [UIView animateWithDuration:1.f animations:^{
                CGRect frame = _pupilsImageView.frame;
                frame.origin.x += pupilsShift.x;
                frame.origin.y += pupilsShift.y;
                _pupilsImageView.frame = frame;
            }];
        } else {
            [UIView animateWithDuration:0.2f animations:^{
                _pupilsImageView.alpha = 1.f;
            }];
        }
    });
    
    self.view.backgroundColor = [UIColor blackColor];
    
    
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        if ( _eyesNumber == 0 ) {
            _pupilsImageView.hidden = YES;
        }
    }];
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (RSPage*)previousPage {
    return [RSMapScene new];
}

@end
