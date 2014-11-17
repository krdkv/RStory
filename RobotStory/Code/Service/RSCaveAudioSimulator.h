//
//  RSCaveAudioSimulator.h
//  RobotStory
//
//  Created by Nick on 08/10/2014.
//  Copyright (c) 2014 Bookclub. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface RSCaveAudioSimulator : NSObject

+ (RSCaveAudioSimulator*)sharedInstance;

- (void) enterCave;

- (void) leaveCave;

@end
