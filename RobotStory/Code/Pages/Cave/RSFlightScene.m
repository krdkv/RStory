//
//  RSFlightScene.m
//  RobotStory
//
//  Created by Nick on 04/11/2014.
//  Copyright (c) 2014 Bookclub. All rights reserved.
//

#import "RSFlightScene.h"
#import "RSCaveRevisitedScene.h"

@interface RSFlightScene ()

@end

@implementation RSFlightScene

- (void)viewDidLoad {
    
//    self.backgroundImageName = @"sky";
//    self.backgroundImageType = @"jpg";
    
    [super viewDidLoad];
    
    UIImage * image = [UIImage imageNamed:@"clouds.gif"];
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.image = image;
    [self.view addSubview:imageView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (RSPage*) previousPage {
    return [RSCaveRevisitedScene new];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
