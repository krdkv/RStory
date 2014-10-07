//
//  RSMapScene.m
//  RobotStory
//
//  Created by Nick on 05/10/2014.
//  Copyright (c) 2014 Bookclub. All rights reserved.
//

#import "RSMapScene.h"
#import "RSRobotCreationScene.h"
#import "RSCaveEnterScene.h"

@interface RSMapScene ()

@end

@implementation RSMapScene

- (void)viewDidLoad {
    
    self.backgroundImageName = @"map";
    self.backgroundImageType = @"jpg";
    
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(50.f, 50.f, 341.f, 275.f)];
    [button addTarget:self action:@selector(onCave) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) onCave {
    NSAssert(self.delegate, @"Delegate should be set");
    [self.delegate shouldJumpToNextPage:[RSCaveEnterScene new]];
}

- (RSPage*) previousPage {
    return [RSRobotCreationScene new];
}

@end
