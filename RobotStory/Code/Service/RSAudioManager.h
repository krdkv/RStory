//
//  RSAudioManager.h
//  RobotStory
//
//  Created by Nick on 03/10/2014.
//  Copyright (c) 2014 Bookclub. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSAudioManager : NSObject

+ (RSAudioManager*) sharedInstance;

- (void) playAudio:(NSString*)fileName
        inTheGroup:(NSString*)group
      withDuration:(CGFloat)duration
        afterDelay:(CGFloat)delay;

- (void) setVolumeForGroup:(NSString*)group;

- (void) removeGroup:(NSString*)group;

- (void) startSoundtrack;
- (void) stopSoundtrack;
- (void) setVolumeForSoundtrack;

- (void) enterCave;
- (void) leaveCave;

@end
