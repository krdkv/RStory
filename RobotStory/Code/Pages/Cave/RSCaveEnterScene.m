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
#import "RSWorkshopScene.h"
#import "RSNoteView.h"
#import "RSSettingsManager.h"
#import "RSDreamBubble.h"

@interface RSCaveEnterScene ()

@property (nonatomic, strong) UIImageView * eyesImageView;
@property (nonatomic, strong) UIImageView * pupilsImageView;
@property (nonatomic, assign) NSInteger eyesNumber;

@property (nonatomic, strong) MCSpriteLayer * kingEyes;
@property (nonatomic, strong) MCSpriteLayer * tribeEyes1;
@property (nonatomic, strong) MCSpriteLayer * tribeEyes2;
@property (nonatomic, strong) MCSpriteLayer * tribeEyes3;

@property (nonatomic, strong) MCSpriteLayer * kingMatches;
@property (nonatomic, strong) MCSpriteLayer * tribeMatches;

@property (nonatomic, assign) BOOL canGoToNextPage;

@property (nonatomic, strong) RSNoteView * kingsSpeech;
@property (nonatomic, strong) RSNoteView * tribeSpeech;
@property (nonatomic, assign) NSInteger dialogIndex;

@end

@implementation RSCaveEnterScene

- (void)viewDidLoad {
    
    self.view.backgroundColor = [UIColor blackColor];
    
    if ( [RSSettingsManager objectForKey:kHaveAskedForMicPermission] ) {
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            if ( granted ) {
                [[RSCaveAudioSimulator sharedInstance] enterCave];
            }
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self drawBatsEyes];
        });
        
    } else {
        [RSSettingsManager setObject:@YES forKey:kHaveAskedForMicPermission];
        [self animationForMicrophoneDialog];
    }
    
    [super viewDidLoad];
}

- (void) animationForMicrophoneDialog {
    _eyesNumber = [[RSSettingsManager objectForKey:kRobotHead] intValue];

    [self drawEyeBackground];
    [self drawPupils];
    [self pupilsFirstAnimation];
    
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        if ( granted ) {
            [[RSCaveAudioSimulator sharedInstance] enterCave];
        }
        [self pupilsSecondAnimation];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self cameraUpAnimations];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self drawBatsEyes];
            });
        });
    }];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if ( _dialogIndex > 0 ) {
        _dialogIndex++;
        [self showNewDialog];
    }
}

- (void) showNewDialog {
    
    if ( _dialogIndex == 0 ) {
        return;
    }
    
    if ( _kingsSpeech ) {
        [self showKingMatches:NO];
        [UIView animateWithDuration:0.5 animations:^{ _kingsSpeech.alpha = 0.f;
        } completion:^(BOOL finished) {
            [_kingsSpeech removeFromSuperview];
            _kingsSpeech = nil;
        }];
    }
    if ( _tribeSpeech ) {
        [self showTribeMatches:NO];
        [UIView animateWithDuration:0.5 animations:^{ _tribeSpeech.alpha = 0.f;
        } completion:^(BOOL finished) {
            [_tribeSpeech removeFromSuperview];
            _tribeSpeech = nil;
        }];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString * title;
        
        switch (_dialogIndex) {
            case 1: {
                NSString * name = [RSSettingsManager objectForKey:kRobotName];
                title = [NSString stringWithFormat:@"Finally... %@...\nyou're here", name];
                _kingsSpeech = [[RSNoteView alloc] init];
            } break;
            case 2: {
                title = @"You're here!\nYou're here!\nYou're here!";
                _tribeSpeech = [[RSNoteView alloc] init];
            } break;
            case 3: {
                title = @"You're ready to learn\nthe secret of flight!";
                _kingsSpeech = [[RSNoteView alloc] init];
            }break;
                
                
            default:{
                return;
            }
        }
        
        if ( _kingsSpeech ) {
            [self showKingMatches:YES];
            [_kingsSpeech setTitle:title];
            [_kingsSpeech setDraggable:NO];
            [_kingsSpeech setCenter:CGPointMake(200.f, 470.f)];
            [self.view addSubview:_kingsSpeech];
        }
        
        if ( _tribeSpeech ) {
            [self showTribeMatches:YES];
            [_tribeSpeech setTitle:title];
            [_tribeSpeech setDraggable:NO];
            [_tribeSpeech setCenter:CGPointMake(700.f, 470.f)];
            [self.view addSubview:_tribeSpeech];
        }
    });
}


- (void) drawEyeBackground {
    UIImage * eyesBackgroundImage = [UIImage imageNamed:[NSString stringWithFormat:@"eyes%ld", (long)_eyesNumber]];
    _eyesImageView = [[UIImageView alloc] initWithImage:eyesBackgroundImage];
    CGSize imageSize = CGSizeMake(eyesBackgroundImage.size.width/2, eyesBackgroundImage.size.height/2);
    CGPoint point;
    switch (_eyesNumber) {
        case 0: point = CGPointMake(383.f, 390.f); break;
        case 1: point = CGPointMake(([RSStyle screenWidth] - imageSize.width)/2, 534.f); break;
        case 2: point = CGPointMake(([RSStyle screenWidth] - imageSize.width)/2, 532.f); break;
        case 3: point = CGPointMake(([RSStyle screenWidth] - imageSize.width)/2, 563.f); break;
    }
    _eyesImageView.frame = CGRectMake(point.x, point.y, imageSize.width, imageSize.height);
    [self.view addSubview:_eyesImageView];
}
- (void) drawPupils {
    _pupilsImageView = [[UIImageView alloc] initWithFrame:_eyesImageView.frame];
    _pupilsImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"eyes%ld_1", (long)_eyesNumber]];
    if ( _eyesNumber == 0 ) {
        _pupilsImageView.alpha = 0.f;
    }
    [self.view addSubview:_pupilsImageView];
}
- (void) pupilsFirstAnimation {
    CGPoint pupilsShift;
    switch (_eyesNumber) {
        case 1: pupilsShift = CGPointMake(3.f, -5.f); break;
        case 2: pupilsShift = CGPointMake(10.f, -20.f); break;
        case 3: pupilsShift = CGPointMake(5.f, -8.f); break;
    }
    if ( _eyesNumber != 0 ) {
        [UIView animateWithDuration:1.f animations:^{
            CGRect frame = _pupilsImageView.frame;
            frame.origin.x += pupilsShift.x;
            frame.origin.y += pupilsShift.y;
            _pupilsImageView.frame = frame;
        }];
    } else {
        [UIView animateWithDuration:1.f animations:^{
            _pupilsImageView.alpha = 1.f;
        }];
    }
}
- (void) pupilsSecondAnimation {
    CGPoint pupilsShift;
    switch (_eyesNumber) {
        case 1: pupilsShift = CGPointMake(-3.f, -3.f); break;
        case 2: pupilsShift = CGPointMake(-10.f, -7.f); break;
        case 3: pupilsShift = CGPointMake(-5.f, -4.f); break;
    }
    if ( _eyesNumber != 0 ) {
        [UIView animateWithDuration:1.f animations:^{
            CGRect frame = _pupilsImageView.frame;
            frame.origin.x += pupilsShift.x;
            frame.origin.y += pupilsShift.y;
            _pupilsImageView.frame = frame;
        }];
    } else {
        [UIView animateWithDuration:1.f animations:^{
            _pupilsImageView.alpha = 0.f;
        }];
    }
}
- (void) cameraUpAnimations {
    [UIView animateWithDuration:1.5f animations:^{
        CGRect frame = _pupilsImageView.frame;
        frame.origin.y += 250.f;
        _pupilsImageView.frame = frame;
        
        frame = _eyesImageView.frame;
        frame.origin.y += 250.f;
        _eyesImageView.frame = frame;
    }];
}

- (void) drawBatsEyes {
    NSMutableArray * eyesOrder = [[NSMutableArray alloc] initWithArray:@[@0, @1, @2, @3]];
    for ( int i = 0; i < eyesOrder.count; ++i ) {
        NSInteger j = arc4random_uniform((int)eyesOrder.count);
        [eyesOrder exchangeObjectAtIndex:i withObjectAtIndex:j];
    }
    for ( int i = 0; i < eyesOrder.count; ++i ) {
        int eyeIndex = [eyesOrder[i] intValue];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(i * 0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showEyesAtIndex:eyeIndex];
        });
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1.f animations:^{
            _kingEyes.opacity = _tribeEyes1.opacity = _tribeEyes2.opacity = _tribeEyes3.opacity = 0.f;
            [_kingEyes removeFromSuperlayer];
            [_tribeEyes1 removeFromSuperlayer];
            [_tribeEyes2 removeFromSuperlayer];
            [_tribeEyes3 removeFromSuperlayer];
        } completion:^(BOOL finished) {
            _dialogIndex = 1;
            [self showNewDialog];
            
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self showKingMatches:NO];
//                [self showTribeMatches:YES];
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [self showTribeMatches:NO];
//                    [self displayPageCornerWithCurlName:@"workshop_curl" withDelay:0.8f];
//                    _canGoToNextPage = YES;
//                });
//            });
        }];
    });
}

- (void) showKingMatches:(BOOL)show {
    if ( show ) {
        UIImage * image = [UIImage imageNamed:@"kingMatch.jpg"];
        _kingMatches = [MCSpriteLayer layerWithImage:image.CGImage sampleSize:CGSizeMake(image.size.width/2, image.size.height/3)];
        _kingMatches.frame = CGRectMake(49.f, 37.f, image.size.width/2/2, image.size.height/3/2);
        [self.view.layer addSublayer:_kingMatches];
        CABasicAnimation * anim = [CABasicAnimation animationWithKeyPath:@"sampleIndex"];
        anim.fromValue = @1;
        anim.toValue = @4;
        anim.duration = 0.75f;
        anim.repeatCount = INFINITY;
        [_kingMatches addAnimation:anim forKey:nil];
    } else {
        [_kingMatches removeAllAnimations];
        CABasicAnimation * anim = [CABasicAnimation animationWithKeyPath:@"sampleIndex"];
        anim.fromValue = @4;
        anim.toValue = @8;
        anim.duration = 0.75f;
        anim.repeatCount = 1;
        [_kingMatches addAnimation:anim forKey:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_kingMatches removeAllAnimations];
            [_kingMatches removeFromSuperlayer];
        });
    }
}

- (void) showTribeMatches:(BOOL)show {
    if ( show ) {
        UIImage * image = [UIImage imageNamed:@"tribeMatch.jpg"];
        _tribeMatches = [MCSpriteLayer layerWithImage:image.CGImage sampleSize:CGSizeMake(image.size.width/2, image.size.height/3)];
        _tribeMatches.frame = CGRectMake(331.f, 42.f, image.size.width/2/2, image.size.height/3/2);
        [self.view.layer addSublayer:_tribeMatches];
        CABasicAnimation * anim = [CABasicAnimation animationWithKeyPath:@"sampleIndex"];
        anim.fromValue = @1;
        anim.toValue = @4;
        anim.duration = 0.75f;
        anim.repeatCount = INFINITY;
        [_tribeMatches addAnimation:anim forKey:nil];
    } else {
        [_tribeMatches removeAllAnimations];
        CABasicAnimation * anim = [CABasicAnimation animationWithKeyPath:@"sampleIndex"];
        anim.fromValue = @4;
        anim.toValue = @8;
        anim.duration = 0.75f;
        anim.repeatCount = 1;
        [_tribeMatches addAnimation:anim forKey:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_tribeMatches removeAllAnimations];
            [_tribeMatches removeFromSuperlayer];
        });
    }
}

- (void) showEyesAtIndex:(NSInteger)index {
    
    UIImage * image;
    CABasicAnimation * anim;
    
    switch (index) {
        case 0:
            image = [UIImage imageNamed:@"kingEyes.jpg"];
            _kingEyes = [MCSpriteLayer layerWithImage:image.CGImage sampleSize:CGSizeMake(image.size.width, image.size.height/3)];
            _kingEyes.frame = CGRectMake(65.f, 266.f, image.size.width, image.size.height/3);
            [self.view.layer addSublayer:_kingEyes];
            anim = [CABasicAnimation animationWithKeyPath:@"sampleIndex"];
            anim.fromValue = @1;
            anim.toValue = @4;
            anim.duration = 0.5f;
            anim.repeatCount = 1;
            [_kingEyes addAnimation:anim forKey:nil];
            break;
            
        case 1:
            image = [UIImage imageNamed:@"tribeEyes.jpg"];
            _tribeEyes1 = [MCSpriteLayer layerWithImage:image.CGImage sampleSize:CGSizeMake(image.size.width, image.size.height/3)];
            _tribeEyes1.frame = CGRectMake(465.f, 271, image.size.width, image.size.height/3);
            [self.view.layer addSublayer:_tribeEyes1];
            anim = [CABasicAnimation animationWithKeyPath:@"sampleIndex"];
            anim.fromValue = @1;
            anim.toValue = @4;
            anim.duration = 0.5f;
            anim.repeatCount = 1;
            [_tribeEyes1 addAnimation:anim forKey:nil];
            break;
            
        case 2:
            image = [UIImage imageNamed:@"tribeEyes.jpg"];
            _tribeEyes2 = [MCSpriteLayer layerWithImage:image.CGImage sampleSize:CGSizeMake(image.size.width, image.size.height/3)];
            _tribeEyes2.frame = CGRectMake(660.5f, 275, image.size.width, image.size.height/3);
            [self.view.layer addSublayer:_tribeEyes2];
            anim = [CABasicAnimation animationWithKeyPath:@"sampleIndex"];
            anim.fromValue = @1;
            anim.toValue = @4;
            anim.duration = 0.5f;
            anim.repeatCount = 1;
            [_tribeEyes2 addAnimation:anim forKey:nil];
            break;
            
        case 3:
            image = [UIImage imageNamed:@"tribeEyes.jpg"];
            _tribeEyes3 = [MCSpriteLayer layerWithImage:image.CGImage sampleSize:CGSizeMake(image.size.width, image.size.height/3)];
            _tribeEyes3.frame = CGRectMake(846.f, 281.f, image.size.width, image.size.height/3);
            [self.view.layer addSublayer:_tribeEyes3];
            anim = [CABasicAnimation animationWithKeyPath:@"sampleIndex"];
            anim.fromValue = @1;
            anim.toValue = @4;
            anim.duration = 0.5f;
            anim.repeatCount = 1;
            [_tribeEyes3 addAnimation:anim forKey:nil];
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) shouldJumpToPreviousPage {
    [[RSCaveAudioSimulator sharedInstance] leaveCave];
}

- (void) shouldJumpToNextPage {
    [[RSCaveAudioSimulator sharedInstance] leaveCave];
}

- (RSPage*)previousPage {
    return [RSMapScene new];
}

- (RSPage*)nextPage {
    return /*_canGoToNextPage ? */[RSDreamBubble new] /*: nil*/;
}

@end
