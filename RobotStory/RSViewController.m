//
//  RSViewController.m
//  RobotStory
//
//  Created by Nick on 05/08/2014.
//  Copyright (c) 2014 Bookclub. All rights reserved.
//

#import "RSViewController.h"
#import "RSPage.h"
#import "RSHouseScene.h"
#import "RSRobotCreationScene.h"

@interface RSViewController ()

@property (nonatomic, strong) UIPageViewController * pageViewController;
@property (nonatomic, strong) RSPage * currentPage;

@end

@implementation RSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    for (UIGestureRecognizer *recognizer in self.pageViewController.gestureRecognizers) {
        if ( [recognizer isMemberOfClass:[UIPanGestureRecognizer class]] ) {
            recognizer.enabled = NO;
        }        
    }
    
    _currentPage = [[RSHouseScene alloc] init];
    
    NSArray *viewControllers = @[_currentPage];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    RSPage * newPage = [_currentPage previousPage];
    if ( newPage ) {
        _currentPage = newPage;
    }
    return newPage;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    RSPage * newPage = [_currentPage nextPage];
    if ( newPage ) {
        _currentPage = newPage;
    }
    return newPage;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
