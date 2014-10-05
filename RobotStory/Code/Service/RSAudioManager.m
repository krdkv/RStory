//
//  RSAudioManager.m
//  RobotStory
//
//  Created by Nick on 03/10/2014.
//  Copyright (c) 2014 Bookclub. All rights reserved.
//

#import "RSAudioManager.h"
#import <AVFoundation/AVFoundation.h>

@interface RSAudioManager()<AVAudioPlayerDelegate>

@property (nonatomic, strong) NSMutableDictionary * players;

@end

@implementation RSAudioManager

+ (RSAudioManager*) sharedInstance {
    static RSAudioManager * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[RSAudioManager alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _players = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (AVAudioPlayer*) playerForFileName:(NSString*)fileName {
    NSError * error = nil;
    NSString * filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"caf"];
    NSAssert(filePath.length > 0, @"File should exist: %@", filePath);
    AVAudioPlayer * player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:filePath] error:&error];
    player.delegate = self;
    NSAssert(!error, @"AVAudioPlayer should be correctly initialized");
    return player;
}

- (void) playAudio:(NSString*)fileName
        inTheGroup:(NSString*)group
      withDuration:(CGFloat)duration
        afterDelay:(CGFloat)delay {
    
    AVAudioPlayer * player = nil;
    
    if ( group.length == 0 ) {
        group = @"tmp";
    }
    
    player = _players[group];
    if ( player ) {
        [player stop];
    } else {
        player = [self playerForFileName:fileName];
        _players[group] = player;
    }
    
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [player play];
        
        if ( duration > 0 ) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [player stop];
            });
        }
    });
}

- (void) removeGroup:(NSString*)group {    
    AVAudioPlayer * player = _players[group];
    if ( player ) {
        [player stop];
    }
    [_players removeObjectForKey:group];
}

- (void) setVolumeForGroup:(NSString*)group {
    
}

- (void) startSoundtrack {
    
}

- (void) stopSoundtrack {
    
}

- (void) setVolumeForSoundtrack {
    
}

- (void) enterCave {
    
}

- (void) leaveCave {
    
}

#pragma mark AVAudioPlayer

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    
}

@end
