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
#import "RSCaveAudioSimulator.h"
#import "MCSpriteLayer.h"

@interface RSCaveEnterScene ()

@property (nonatomic, strong) UIImageView * eyesImageView;
@property (nonatomic, strong) UIImageView * pupilsImageView;
@property (nonatomic, assign) NSInteger eyesNumber;
@property (nonatomic, strong) RSCaveAudioSimulator * caveSimulator;

@property (nonatomic, strong) MCSpriteLayer * kingEyes;
@property (nonatomic, strong) MCSpriteLayer * tribeEyes1;
@property (nonatomic, strong) MCSpriteLayer * tribeEyes2;
@property (nonatomic, strong) MCSpriteLayer * tribeEyes3;

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
            } completion:^(BOOL success){
                
                [UIView animateWithDuration:2.f animations:^{
                    CGRect frame = _pupilsImageView.frame;
                    frame.origin.y += 250.f;
                    _pupilsImageView.frame = frame;
                    
                    frame = _eyesImageView.frame;
                    frame.origin.y += 250.f;
                    _eyesImageView.frame = frame;
                } completion:^(BOOL finished) {
                    [self drawEyes];
                }];
                
            }];
        } else {
            [UIView animateWithDuration:0.2f animations:^{
                _pupilsImageView.alpha = 1.f;
            }];
        }
    });
    
    self.view.backgroundColor = [UIColor blackColor];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            _caveSimulator = [[RSCaveAudioSimulator alloc] init];
            [_caveSimulator enterCave];
        }];
    });

    
    [super viewDidLoad];
}

- (void) drawEyes {
    
    UIImage * image = [UIImage imageNamed:@"kingEyes"];
    _kingEyes = [MCSpriteLayer layerWithImage:image.CGImage sampleSize:CGSizeMake(image.size.width, image.size.height/3)];
    _kingEyes.frame = CGRectMake(65.f, 266.f, image.size.width, image.size.height/3);
    [self.view.layer addSublayer:_kingEyes];
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"sampleIndex"];
    anim.fromValue = @1;
    anim.toValue = @4;
    anim.duration = 0.7f;
    anim.repeatCount = 1;
    [_kingEyes addAnimation:anim forKey:nil];
    
    image = [UIImage imageNamed:@"tribeEyes"];
    _tribeEyes1 = [MCSpriteLayer layerWithImage:image.CGImage sampleSize:CGSizeMake(image.size.width, image.size.height/3)];
    _tribeEyes1.frame = CGRectMake(465.f, 271, image.size.width, image.size.height/3);
    [self.view.layer addSublayer:_tribeEyes1];
    anim = [CABasicAnimation animationWithKeyPath:@"sampleIndex"];
    anim.fromValue = @1;
    anim.toValue = @4;
    anim.duration = 0.7f;
    anim.repeatCount = 1;
    [_tribeEyes1 addAnimation:anim forKey:nil];
    
    _tribeEyes2 = [MCSpriteLayer layerWithImage:image.CGImage sampleSize:CGSizeMake(image.size.width, image.size.height/3)];
    _tribeEyes2.frame = CGRectMake(660.5f, 275, image.size.width, image.size.height/3);
    [self.view.layer addSublayer:_tribeEyes2];
    anim = [CABasicAnimation animationWithKeyPath:@"sampleIndex"];
    anim.fromValue = @1;
    anim.toValue = @4;
    anim.duration = 0.7f;
    anim.repeatCount = 1;
    [_tribeEyes2 addAnimation:anim forKey:nil];
    
    _tribeEyes3 = [MCSpriteLayer layerWithImage:image.CGImage sampleSize:CGSizeMake(image.size.width, image.size.height/3)];
    _tribeEyes3.frame = CGRectMake(846.f, 281.f, image.size.width, image.size.height/3);
    [self.view.layer addSublayer:_tribeEyes3];
    anim = [CABasicAnimation animationWithKeyPath:@"sampleIndex"];
    anim.fromValue = @1;
    anim.toValue = @4;
    anim.duration = 0.7f;
    anim.repeatCount = 1;
    [_tribeEyes3 addAnimation:anim forKey:nil];
}

- (void) viewWillDisappear:(BOOL)animated {
    if ( _caveSimulator ) {
        [_caveSimulator leaveCave];
        _caveSimulator = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (RSPage*)previousPage {
    return [RSMapScene new];
}

@end
