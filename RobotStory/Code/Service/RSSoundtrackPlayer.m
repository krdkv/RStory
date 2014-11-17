//
//  RSSoundtrackPlayer.m
//  RobotStory
//
//  Created by Nick on 17/11/2014.
//  Copyright (c) 2014 Bookclub. All rights reserved.
//

#import "RSSoundtrackPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface RSSoundtrackPlayer()<AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioPlayer * player;
@property (nonatomic, assign) RSTheme currentTheme;

@property (nonatomic, strong) NSArray * currentSongArray;
@property (nonatomic, assign) NSInteger currentSongIndex;

@end

@implementation RSSoundtrackPlayer

+ (RSSoundtrackPlayer*) sharedInstance {
    static RSSoundtrackPlayer * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[RSSoundtrackPlayer alloc] init];
    });
    return instance;
}

- (void) playTheme:(RSTheme)theme {
    
    if ( _currentTheme == theme ) {
        return;
    }
    
    _currentTheme = theme;
    
    if ( _player && _player.playing ) {
        [_player stop];
        _player = nil;
    }
    
    switch (theme) {
        case kMainTheme:
        {
            _currentSongIndex = 0;
            _currentSongArray = @[@"main0"];
        } break;
    }
    
    NSString * filePath = [[NSBundle mainBundle] pathForResource:_currentSongArray[0] ofType:@"caf"];
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:filePath] error:nil];
    [_player setDelegate:self];
    [_player play];
}

#pragma mark Finished playing

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    _currentSongIndex++;
    
    if ( _currentSongIndex == _currentSongArray.count ) {
        _currentSongIndex = 0;
    }
    
    NSString * filePath = [[NSBundle mainBundle] pathForResource:_currentSongArray[_currentSongIndex] ofType:@"caf"];
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:filePath] error:nil];
    [_player setDelegate:self];
    [_player play];
}

@end
