//
//  RSPage.m
//  RobotStory
//
//  Created by Nick on 06/08/2014.
//  Copyright (c) 2014 Bookclub. All rights reserved.
//

#import "RSPage.h"
#import "MCSpriteLayer.h"
#import "RSStyle.h"

@interface RSPage()

@property (nonatomic, strong) CALayer * nextPageLayer;
@property (nonatomic, strong) MCSpriteLayer * curlLayer;

@end

@implementation RSPage

- (void) viewDidLoad {
    [super viewDidLoad];
    
    if ( self.backgroundImageName ) {        
        NSString * imagePath = [[NSBundle mainBundle] pathForResource:self.backgroundImageName ofType:self.backgroundImageType];
        self.view.layer.contents = (__bridge id)[UIImage imageWithContentsOfFile:imagePath].CGImage;
        self.view.backgroundColor = [UIColor clearColor];
        self.view.layer.opaque = YES;
    }
}

- (void) hidePageCorner {
    _curlLayer.hidden = YES;
    _nextPageLayer.hidden = YES;
    [_curlLayer removeFromSuperlayer];
    [_nextPageLayer removeFromSuperlayer];
    _nextPageLayer = nil;
    _curlLayer = nil;
}

- (void) displayPageCornerWithCurlName:(NSString*)curlName withDelay:(CGFloat)delay {
    
    if ( _nextPageLayer ) {
        return;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        CGFloat curlWidth = 408 / 4;
        CGFloat curlHeight = 364;
        
        UIImage * curlImage = [UIImage imageNamed:@"curl.png"];
        CGImageRef curlImageRef = curlImage.CGImage;
        _curlLayer = [MCSpriteLayer layerWithImage:curlImageRef sampleSize:CGSizeMake(curlWidth*2, curlHeight)];
        _curlLayer.frame = CGRectMake([RSStyle screenWidth] - curlWidth, [RSStyle screenHeight] - curlHeight/2, curlWidth, curlHeight/2);
        [self.view.layer addSublayer:_curlLayer];
        
        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"sampleIndex"];
        anim.fromValue = @1;
        anim.toValue = @3;
        anim.duration = 0.1f;
        anim.repeatCount = 1;
        if ( delay == 0.f ) {
            anim.fromValue = @2;
            anim.toValue = @2;
            anim.duration = 0.f;
            anim.repeatCount = 0;
        }
        
        
        [_curlLayer addAnimation:anim forKey:nil];
        
        CALayer * mask = [CALayer layer];
        mask.contents = (id)[UIImage imageNamed:@"curlShape"].CGImage;
        mask.frame = CGRectMake(0.f, 0.f, 57.f, 182.f);
        
        _nextPageLayer = [CALayer layer];
        _nextPageLayer.contents = (id)([UIImage imageNamed:curlName].CGImage);
        _nextPageLayer.frame = CGRectMake([RSStyle screenWidth] - 57.f, [RSStyle screenHeight] - 182.f, 57.f, 182.f);
        _nextPageLayer.mask = mask;
        _nextPageLayer.masksToBounds = YES;
        [self.view.layer insertSublayer:_nextPageLayer below:_curlLayer];
    });
}

- (RSPage*) nextPage {
    return nil;
}

- (RSPage*) previousPage {
    return nil;
}

- (void) shouldJumpToNextPage {}

- (void) shouldJumpToPreviousPage {}

@end
