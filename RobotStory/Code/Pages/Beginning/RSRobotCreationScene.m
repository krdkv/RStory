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
#import "RSNoteView.h"
#import <AVFoundation/AVFoundation.h>

#define kNumberOfRobotParts 4

#define kScrollHeights @[@196.f, @233.f, @198.f]

@interface RSRobotCreationScene ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView * headScrollView;
@property (nonatomic, strong) UIScrollView * bodyScrollView;
@property (nonatomic, strong) UIScrollView * legsScrollView;
@property (nonatomic, strong) NSMutableArray * selectedParts;
@property (nonatomic, assign) NSInteger state;

@property (nonatomic, strong) UIImageView * handHintAnimationImageView;
@property (nonatomic, assign) CGRect handHintInitialFrame;
@property (nonatomic, strong) NSTimer * handHintTimer;

@property (nonatomic, strong) RSNoteView * firstNote;
@property (nonatomic, strong) RSNoteView * secondNote;

@property (nonatomic, strong) UIButton * launchButton;

@property (nonatomic, strong) UITextField * field;

@property (nonatomic, strong) AVAudioPlayer * player;

@property (nonatomic, assign) BOOL robotCreated;

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

- (void)dealloc {
    if ( _handHintTimer ) {
        [_handHintTimer invalidate];
        _handHintTimer = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) viewWillDisappear:(BOOL)animated {
    [_field resignFirstResponder];
    if ( _handHintTimer ) {
        [_handHintTimer invalidate];
        _handHintTimer = nil;
    }
}

- (void) finishedLoading {
    
    if ( ![RSSettingsManager objectForKey:kShouldShowRobotCreationClue] ) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showHandHintAnimation:YES];
        });
    }
    
    _firstNote = [[RSNoteView alloc] init];
    [_firstNote setTitle:@"And here's how \nhe looked like!"];
    [_firstNote setX:20.f y:20.f];
    [_firstNote addLightRotation];
    [self.view addSubview:_firstNote];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)viewDidLoad
{
    self.backgroundImageName = @"gears";
    self.backgroundImageType = @"jpg";
    [super viewDidLoad];
    
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
    
    _launchButton = [[UIButton alloc] initWithFrame:CGRectMake(830.f, 260.f, 732.f/8, 1340.f/8)];
    [_launchButton setImage:[UIImage imageNamed:@"robotLaunchOff"] forState:UIControlStateNormal];
    [_launchButton setImage:[UIImage imageNamed:@"robotLaunchOn"] forState:UIControlStateSelected];
    _launchButton.adjustsImageWhenHighlighted = NO;
    [_launchButton addTarget:self action:@selector(onLaunch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_launchButton];
    
    [RSSettingsManager setObject:nil forKey:kShouldShowRobotCreationClue];
    
    if ( ![RSSettingsManager objectForKey:kShouldShowRobotCreationClue] ) {
        _headScrollView.alpha = _bodyScrollView.alpha = _legsScrollView.alpha = 0.5f;
        _launchButton.hidden = YES;
    }
}

- (void)showHandHintAnimation:(BOOL)show {
    
    if ( show ) {
        UIImage * handHintImage = [UIImage imageNamed:@"handHint"];
        _handHintAnimationImageView = [[UIImageView alloc] initWithImage:handHintImage];
        _handHintInitialFrame = CGRectMake(([RSStyle screenWidth] - handHintImage.size.width/2)/2, ([RSStyle screenHeight] - handHintImage.size.height/2)/2, handHintImage.size.width/2, handHintImage.size.height/2);
        _handHintInitialFrame.origin.x += 150.f;
        _handHintAnimationImageView.frame = _handHintInitialFrame;
        [self.view addSubview:_handHintAnimationImageView];
        
        _handHintTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(handHintTick) userInfo:nil repeats:YES];
    } else {
        [_handHintAnimationImageView removeFromSuperview];
        [_handHintTimer invalidate];
    }
}

static int tickCount = 0;
- (void)handHintTick {
    CGRect newFrame = _handHintInitialFrame;
    tickCount = (tickCount+1)%7;
    newFrame.origin.x = _handHintInitialFrame.origin.x + tickCount * 25.f;
    _handHintAnimationImageView.frame = newFrame;
}

- (void)keyboardWillShow:(NSNotification*)notification {
    
    NSTimeInterval animationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;
    UIViewAnimationCurve curve;
    [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&curve];
    
    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"robotDown" ofType:@"caf"];
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:filePath] error:nil];
    [_player play];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_player stop];
    });
    
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:curve];
        _headScrollView.frame = CGRectMake(_headScrollView.frame.origin.x, _headScrollView.frame.origin.y - kbHeight, _headScrollView.frame.size.width, _headScrollView.frame.size.height);
        _bodyScrollView.frame = CGRectMake(_bodyScrollView.frame.origin.x, _bodyScrollView.frame.origin.y - kbHeight, _bodyScrollView.frame.size.width, _bodyScrollView.frame.size.height);
        _legsScrollView.frame = CGRectMake(_legsScrollView.frame.origin.x, _legsScrollView.frame.origin.y - kbHeight, _legsScrollView.frame.size.width, _legsScrollView.frame.size.height);
    [UIView commitAnimations];
}

- (void) onLaunch:(UIButton*)sender {
    
    if (! _robotCreated ) {
        _robotCreated = YES;
        sender.selected = ! sender.selected;
    } else {
        
        if ( _field.text.length == 0 ) {
            return;
        }
        
        sender.selected = ! sender.selected;
        
        [RSSettingsManager setObject:_field.text forKey:kRobotName];
        
        [self.delegate shouldJumpToNextPage:[RSMapScene new]];
        return;
    }
    
    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"robotDown" ofType:@"caf"];
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:filePath] error:nil];
    _player.volume = 0.5f;
    [_player play];
    
    [UIView animateWithDuration:2.f animations:^{
        CGRect rect = _headScrollView.frame;
        rect.origin.y += 505.f;
        _headScrollView.frame = rect;
        
        rect = _bodyScrollView.frame;
        rect.origin.y += 505.f;
        _bodyScrollView.frame = rect;
        
        rect = _legsScrollView.frame;
        rect.origin.y += 505.f;
        _legsScrollView.frame = rect;
    } completion:^(BOOL finished) {
        
        _secondNote = [[RSNoteView alloc] init];
        
        NSString * nameSpace = @"                    ";
        
        [_secondNote setTitle:[NSString stringWithFormat:@"%@\n%@\n", @"And his name was:", nameSpace]];
        [_secondNote setX:-_secondNote.frame.size.width y:30.f];
        
        CGFloat textFieldWidth = [nameSpace sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:kRegularFontName size:30.f]}].width;
        _field = [[UITextField alloc] initWithFrame:CGRectMake(50.f, 75.f, textFieldWidth-30.f, 70.f)];
        _field.textColor = kRegularTextColor;
        _field.font = [UIFont fontWithName:kRegularFontName size:30.f];
        _field.backgroundColor = [UIColor clearColor];
        _field.autocapitalizationType = UITextAutocapitalizationTypeWords;
        if ( [_field respondsToSelector:@selector(setSpellCheckingType:)] ) {
            [_field setSpellCheckingType:UITextSpellCheckingTypeNo];
        }
        if ( [_field respondsToSelector:@selector(setTintColor:)] ) {
            [_field setTintColor:kRegularTextColor];
        }
        [_secondNote addSubview:_field];
        [self.view addSubview:_secondNote];
        
        _headScrollView.userInteractionEnabled = _bodyScrollView.userInteractionEnabled = _legsScrollView.userInteractionEnabled = NO;
        
        [UIView animateWithDuration:1.f animations:^{
            CGRect frame = _secondNote.frame;
            frame.origin.x = 25.f;
            _secondNote.frame = frame;
        } completion:^(BOOL finished) {
//            [_field sendActionsForControlEvents:UIControlEventTouchDown];
            [_field becomeFirstResponder];
        }];
    }];
}

- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ( ![RSSettingsManager objectForKey:kShouldShowRobotCreationClue] ) {
        [RSSettingsManager setObject:@1 forKey:kShouldShowRobotCreationClue];
        _headScrollView.alpha = _bodyScrollView.alpha = _legsScrollView.alpha = 1.f;
        _launchButton.hidden = NO;
        [self showHandHintAnimation:NO];
    }
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

- (RSPage*)nextPage {
    return [RSMapScene new];
}

- (RSPage*)previousPage {
    return [RSHouseScene new];
}

@end
