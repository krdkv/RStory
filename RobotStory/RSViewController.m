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

@interface RSViewController ()<RSPageDelegate, UIPageViewControllerDelegate>

@property (nonatomic, strong) UIPageViewController * pageViewController;
@property (nonatomic, strong) RSPage * currentPage;

@end

@implementation RSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    for (UIGestureRecognizer *recognizer in self.pageViewController.gestureRecognizers) {
        if ( [recognizer isMemberOfClass:[UIPanGestureRecognizer class]] ) {
            recognizer.enabled = NO;
        }        
    }
    
    _currentPage = [[RSHouseScene alloc] init];
    _currentPage.delegate = self;
    
    NSArray *viewControllers = @[_currentPage];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    [_currentPage shouldJumpToPreviousPage];
    RSPage * newPage = [_currentPage previousPage];
    if ( newPage ) {
        _currentPage = newPage;
        _currentPage.delegate = self;
    }
    return newPage;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    [_currentPage finishedLoading];
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers {
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    [_currentPage shouldJumpToNextPage];
    RSPage * newPage = [_currentPage nextPage];
    if ( newPage ) {
        _currentPage = newPage;
        _currentPage.delegate = self;
    }
    return newPage;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark RSPageDelegate

- (void) shouldJumpToNextPage:(RSPage *)page {
    _currentPage = page;
    _currentPage.delegate = self;
    [self.pageViewController setViewControllers:@[page] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}

@end
