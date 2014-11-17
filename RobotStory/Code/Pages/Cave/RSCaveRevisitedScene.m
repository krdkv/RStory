//
//  RSCaveRevisitedScene.m
//  RobotStory
//
//  Created by Nick on 04/11/2014.
//  Copyright (c) 2014 Bookclub. All rights reserved.
//

#import "RSCaveRevisitedScene.h"
#import "RSFlightScene.h"
#import "RSWorkshopScene.h"

@interface RSCaveRevisitedScene ()

@end

@implementation RSCaveRevisitedScene

- (void)viewDidLoad {
    
    self.backgroundImageName = @"backToCave";
    self.backgroundImageType = @"jpg";
    
    [self displayPageCornerWithCurlName:@"sky_curl" withDelay:0.3f];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (RSPage*) nextPage {
    return [RSFlightScene new];
}

- (RSPage*) previousPage {
    return [RSWorkshopScene new];
}

@end
