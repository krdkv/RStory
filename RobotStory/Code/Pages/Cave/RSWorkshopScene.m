//
//  RSWorkshopScene.m
//  RobotStory
//
//  Created by Nick on 13/10/2014.
//  Copyright (c) 2014 Bookclub. All rights reserved.
//

#import "RSWorkshopScene.h"
#import "RSCaveEnterScene.h"
#import "MCSpriteLayer.h"
#import "RSStyle.h"
#import "RSCaveRevisitedScene.h"

@interface RSWorkshopScene ()

@property (nonatomic, strong) MCSpriteLayer * clouds;

@end

@implementation RSWorkshopScene

- (void)viewDidLoad {
    
    UIImage * image = [UIImage imageNamed:@"workshop_clouds.jpg"];
    _clouds = [[MCSpriteLayer alloc] initWithImage:image.CGImage sampleSize:CGSizeMake(image.size.width/4, image.size.height/5)];
    _clouds.frame = CGRectMake(656.f, 44.f, image.size.width/4/2, image.size.height/5/2);
    
    CABasicAnimation * anim = [CABasicAnimation animationWithKeyPath:@"sampleIndex"];
    anim.fromValue = @1;
    anim.toValue = @19;
    anim.duration = 2.f;
    anim.repeatCount = INFINITY;
    [_clouds addAnimation:anim forKey:nil];    
    
    [self.view.layer addSublayer:_clouds];
    
    NSString * imagePath = [[NSBundle mainBundle] pathForResource:@"workshop" ofType:@"png"];
    CALayer * backgroundLayer = [[CALayer alloc] init];
    backgroundLayer.frame = CGRectMake(0.f, 0.f, [RSStyle screenWidth], [RSStyle screenHeight]);
    backgroundLayer.contents = (__bridge id)[UIImage imageWithContentsOfFile:imagePath].CGImage;
    [self.view.layer addSublayer:backgroundLayer];
    
    [self displayPageCornerWithCurlName:@"caveRevisited_curl" withDelay:0.3f];
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (RSPage*) previousPage {
    return [RSCaveEnterScene new];
}

- (RSPage*) nextPage {
    return [RSCaveRevisitedScene new];
}

@end
