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

- (void) displayPageCornerWithCurlName:(NSString*)curlName withDelay:(CGFloat)delay {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        CGFloat curlWidth = 408 / 4;
        CGFloat curlHeight = 364;
        
        UIImage * curlImage = [UIImage imageNamed:@"curl"];
        CGImageRef curlImageRef = curlImage.CGImage;
        MCSpriteLayer * curlLayer = [MCSpriteLayer layerWithImage:curlImageRef sampleSize:CGSizeMake(curlWidth*2, curlHeight)];
        curlLayer.frame = CGRectMake(kScreenWidth - curlWidth, kScreenHeight - curlHeight/2, curlWidth, curlHeight/2);
        [self.view.layer addSublayer:curlLayer];
        
        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"sampleIndex"];
        anim.fromValue = @1;
        anim.toValue = @3;
        anim.duration = 0.1f;
        if ( delay == 0.f ) {
            anim.fromValue = @2;
            anim.duration = 0.f;
        }
        anim.repeatCount = 1;
        
        [curlLayer addAnimation:anim forKey:nil];
        
        CALayer * mask = [CALayer layer];
        mask.contents = (id)[UIImage imageNamed:@"curlShape"].CGImage;
        mask.frame = CGRectMake(0.f, 0.f, 57.f, 182.f);
        
        CALayer * nextPageLayer = [CALayer layer];
        nextPageLayer.contents = (id)([UIImage imageNamed:curlName].CGImage);
        nextPageLayer.frame = CGRectMake(kScreenWidth - 57.f, kScreenHeight - 182.f, 57.f, 182.f);
        nextPageLayer.mask = mask;
        nextPageLayer.masksToBounds = YES;
        [self.view.layer insertSublayer:nextPageLayer below:curlLayer];
    });
}

- (RSPage*) nextPage {
    return nil;
}

- (RSPage*) previousPage {
    return nil;
}

@end
