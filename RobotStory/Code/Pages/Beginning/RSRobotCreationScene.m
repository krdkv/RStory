//
//  RSRobotCreationScene.m
//  RobotStory
//
//  Created by Nick on 30/08/2014.
//  Copyright (c) 2014 Bookclub. All rights reserved.
//

#import "RSRobotCreationScene.h"
#import "RSHouseScene.h"
#import "RSStyle.h"
#import "RSMapScene.h"
#import "RSSettingsManager.h"

#define kNumberOfRobotParts 4

#define kScrollHeights @[@196.f, @233.f, @198.f]

@interface RSRobotCreationScene ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView * headScrollView;
@property (nonatomic, strong) UIScrollView * bodyScrollView;
@property (nonatomic, strong) UIScrollView * legsScrollView;
@property (nonatomic, strong) NSMutableArray * selectedParts;
@property (nonatomic, assign) NSInteger state;

@end

@implementation RSRobotCreationScene

enum {
    kRobotCreation = 0,
    kRobotNaming
};

- (UIScrollView*) scrollViewWithFrame:(CGRect)frame scrollViewIndex:(NSInteger)index{
    UIScrollView * scrollView;
    scrollView = [[UIScrollView alloc] initWithFrame:frame];
    scrollView.backgroundColor = [UIColor clearColor];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    [scrollView setBounces:NO];
    [scrollView setPagingEnabled:YES];
    
//    switch (index) {
//        case 0: [scrollView setContentMode:UIViewContentModeBottom]; break;
//        case 1: [scrollView setContentMode:UIViewContentModeCenter]; break;
//        case 2: [scrollView setContentMode:UIViewContentModeTop]; break;
//    }
    
    [scrollView setContentSize:CGSizeMake((kNumberOfRobotParts+2) * scrollView.frame.size.width, scrollView.frame.size.height)];
    scrollView.delegate = self;
    
    for ( int i = -1; i <= kNumberOfRobotParts+1; ++i ) {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake((i+1) * scrollView.frame.size.width, 0.f, scrollView.frame.size.width,
                                                                                scrollView.frame.size.height)];
        int j = i;
        if ( j == -1 ) {
            j = kNumberOfRobotParts-1;
        } else if ( j == kNumberOfRobotParts ) {
            j = 0;
        }
        NSString * imageName = [NSString stringWithFormat:@"%@%d", @[@"head", @"body", @"legs"][index], j];
        [imageView setImage:[UIImage imageNamed:imageName]];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [imageView setBackgroundColor:[UIColor clearColor]];
        [scrollView addSubview:imageView];
    }
    
    [scrollView scrollRectToVisible:CGRectMake(scrollView.frame.size.width, 0, scrollView.frame.size.width, scrollView.frame.size.height) animated:NO];
    
    return scrollView;
}

- (void)viewDidLoad
{
    [self displayPageCornerWithCurlName:@"map_curl" withDelay:0.3f];
    
    _state = kRobotCreation;
    
    _selectedParts = [[NSMutableArray alloc] initWithArray:@[@0, @0, @0]];
    
    CGFloat scrollViewTotalHeight = [kScrollHeights[0] floatValue] + [kScrollHeights[1] floatValue] + [kScrollHeights[2] floatValue];
    
    CGFloat x = 0.f;
    CGFloat y = ([RSStyle screenHeight] - scrollViewTotalHeight) / 2;
    CGRect scrollViewFrame;
    
    scrollViewFrame = CGRectMake(x, y, [RSStyle screenWidth], [kScrollHeights[0] floatValue]);
    _headScrollView = [self scrollViewWithFrame:scrollViewFrame scrollViewIndex:0];
    [self.view addSubview:_headScrollView];

    scrollViewFrame = CGRectMake(x, y + [kScrollHeights[0] floatValue] - 0.5f, [RSStyle screenWidth], [kScrollHeights[1] floatValue]);
    _bodyScrollView = [self scrollViewWithFrame:scrollViewFrame scrollViewIndex:1];
    [self.view addSubview:_bodyScrollView];

    scrollViewFrame = CGRectMake(x, y + [kScrollHeights[0] floatValue] + [kScrollHeights[1] floatValue] - 0.5f, [RSStyle screenWidth], [kScrollHeights[2] floatValue]);
    _legsScrollView = [self scrollViewWithFrame:scrollViewFrame scrollViewIndex:2];
    [self.view addSubview:_legsScrollView];
    
    if ( [RSSettingsManager objectForKey:kRobotHead] ) {
        [_headScrollView setContentOffset:CGPointMake(([[RSSettingsManager objectForKey:kRobotHead] intValue]+1)*_headScrollView.frame.size.width, 0.f) animated:YES];
    }
    if ( [RSSettingsManager objectForKey:kRobotBody] ) {
        [_bodyScrollView setContentOffset:CGPointMake(([[RSSettingsManager objectForKey:kRobotBody] intValue]+1)*_bodyScrollView.frame.size.width, 0.f) animated:YES];
    }
    if ( [RSSettingsManager objectForKey:kRobotLegs] ) {
        [_legsScrollView setContentOffset:CGPointMake(([[RSSettingsManager objectForKey:kRobotLegs] intValue]+1)*_legsScrollView.frame.size.width, 0.f) animated:YES];
    }
    
    self.backgroundImageName = @"gears";
    self.backgroundImageType = @"jpg";
    
    [super viewDidLoad];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    int index = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    // Saving your choice
    NSInteger partToSave = (index-1)%kNumberOfRobotParts;
    partToSave = partToSave == -1 ? kNumberOfRobotParts-1 : partToSave;
    RSSettingsKey key = kRobotHead;
    if ( [scrollView isEqual:_bodyScrollView] ) {
        key = kRobotBody;
    } else if ( [scrollView isEqual:_legsScrollView] ) {
        key = kRobotLegs;
    }
    [RSSettingsManager setObject:@(partToSave) forKey:key];
    
    int outIndex = -1;
    
    switch (index) {
        case 0: outIndex = kNumberOfRobotParts; break;
        case kNumberOfRobotParts+1: outIndex = 1; break;
    }
    if ( outIndex != -1 ) {
        [scrollView scrollRectToVisible:CGRectMake(outIndex * scrollView.frame.size.width, 0, scrollView.frame.size.width, scrollView.frame.size.height) animated:NO];
    }
}

- (void) shouldJumpToNextPage {

}

- (RSPage*)nextPage {
    
//    if ( _state == kRobotCreation ) {
//        _state = kRobotNaming;
//        return nil;
//    }
    
    return [RSMapScene new];
}

- (RSPage*)previousPage {
    return [RSHouseScene new];
}

@end
