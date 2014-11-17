//
//  RSCaveAudioSimulator.m
//  RobotStory
//
//  Created by Nick on 08/10/2014.
//  Copyright (c) 2014 Bookclub. All rights reserved.
//

#import "RSCaveAudioSimulator.h"

#define kPrefferedSampleRate 44100.f

#define Check(expr) do { OSStatus err = (expr); if (err) { NSLog(@"error %d from %s", (int)err, #expr); abort(); } } while (0)

#define NSCheck(expr) do { NSError *err = nil; if (!(expr)) { NSLog(@"error from %s: %@", #expr, err);  abort(); } } while (0)

@interface RSCaveAudioSimulator() {
    AUGraph _graph;
    AudioUnit _inputOutputUnit, _effectUnit;
}

@end

@implementation RSCaveAudioSimulator

+ (RSCaveAudioSimulator*)sharedInstance {
    static RSCaveAudioSimulator * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[RSCaveAudioSimulator alloc] init];
    });
    return instance;
}

- (void) enterCave {
#if TARGET_IPHONE_SIMULATOR
    return;
#endif
    
    [self initAudioSession];
    [self setupGraph];
}

- (void) leaveCave {
#if TARGET_IPHONE_SIMULATOR
    return;
#endif
    
    
    Check(AUGraphStop(_graph));
    
    AUGraphClose(_graph);
    DisposeAUGraph(_graph);
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSCheck([session setActive: NO error:&err]);
    
    NSCheck([session setCategory:AVAudioSessionCategorySoloAmbient error: &err]);
}

- (void) initAudioSession {
    AVAudioSession *mySession = [AVAudioSession sharedInstance];
    
    NSError *audioSessionError = nil;
    
    [mySession setCategory:AVAudioSessionCategoryPlayAndRecord error: &audioSessionError];
    NSAssert(audioSessionError == nil, @"Can't set category to audio session");
    
    [mySession setPreferredSampleRate:kPrefferedSampleRate error:&audioSessionError];
    NSAssert(audioSessionError == nil, @"Can't set sample rate");
    
    [mySession setActive:YES error:&audioSessionError];
    NSAssert(audioSessionError == nil, @"Can't set session as active");
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

- (void) setupGraph {
    
    OSStatus result = noErr;
    AUNode inputOutputNode, effectNode;
    
    AudioComponentDescription cd = {};
    cd.componentManufacturer     = kAudioUnitManufacturer_Apple;
    cd.componentFlags            = 0;
    cd.componentFlagsMask        = 0;
    
    // Creating graph
    
    result = NewAUGraph (&_graph);
    NSCAssert (result == noErr, @"Unable to create an AUGraph object. Error code: %d '%.4s'", (int) result, (const char *)&result);
    
    // Input node
    
    cd.componentType = kAudioUnitType_Output;
    cd.componentSubType = kAudioUnitSubType_RemoteIO;
    
    result = AUGraphAddNode(_graph, &cd, &inputOutputNode);
    NSCAssert (result == noErr, @"Unable to add the Input unit to the audio processing graph. Error code: %d '%.4s'", (int) result, (const char *)&result);
    
    // Effect node
    
    cd.componentType = kAudioUnitType_Effect;
    cd.componentSubType = kAudioUnitSubType_Delay;
    
    result = AUGraphAddNode(_graph, &cd, &effectNode);
    NSCAssert (result == noErr, @"Unable to add the Effect unit to the audio processing graph. Error code: %d '%.4s'", (int) result, (const char *)&result);
    
    // Open graph
    
    result = AUGraphOpen (_graph);
    NSCAssert (result == noErr, @"Unable to open the audio processing graph. Error code: %d '%.4s'", (int) result, (const char *)&result);
    
    Check(AUGraphNodeInfo(_graph, inputOutputNode, 0, &_inputOutputUnit));
    //Grab the output mixerUnit from the graph
    Check(AUGraphNodeInfo(_graph, effectNode, 0, &_effectUnit));
    
    // Connections
    
    // Stereo stream format
    
    AudioStreamBasicDescription stereoStreamFormat;
    stereoStreamFormat.mChannelsPerFrame = 2; // stereo
    stereoStreamFormat.mSampleRate       = [[AVAudioSession sharedInstance] sampleRate];
    stereoStreamFormat.mFormatID 		 = kAudioFormatLinearPCM;
    stereoStreamFormat.mFormatFlags 	 = kAudioFormatFlagsNativeFloatPacked | kAudioFormatFlagIsNonInterleaved;
    stereoStreamFormat.mBytesPerFrame 	 = stereoStreamFormat.mBytesPerPacket = sizeof(Float32);
    stereoStreamFormat.mBitsPerChannel 	 = 32;
    stereoStreamFormat.mFramesPerPacket  = 1;
    
    // Getting units
    
    UInt32 flag = 1;
    Check(AudioUnitSetProperty(_inputOutputUnit,
                               kAudioOutputUnitProperty_EnableIO,
                               kAudioUnitScope_Input,
                               1, // Remote IO bus 1 is used to get audio input
                               &flag,
                               sizeof(flag)));
    
    // Enable IO for playback
    Check(AudioUnitSetProperty(_inputOutputUnit,
                               kAudioOutputUnitProperty_EnableIO,
                               kAudioUnitScope_Output,
                               0,// Remote IO bus 0 is used for the output side,
                               &flag,
                               sizeof(flag)));
    
    // Set stereo format
    Check(AudioUnitSetProperty(_effectUnit,
                               kAudioUnitProperty_StreamFormat,
                               kAudioUnitScope_Output,
                               0,
                               &stereoStreamFormat,
                               sizeof(stereoStreamFormat)));
    
    //Set stereo format
    Check(AudioUnitSetProperty(_inputOutputUnit,
                               kAudioUnitProperty_StreamFormat,
                               kAudioUnitScope_Output,
                               1,
                               &stereoStreamFormat,
                               sizeof(stereoStreamFormat)));
    
    UInt32 maxFrames = 4096;
    Check(AudioUnitSetProperty(_inputOutputUnit,
                               kAudioUnitProperty_MaximumFramesPerSlice,
                               kAudioUnitScope_Global,
                               0,
                               &maxFrames,
                               sizeof(maxFrames)));
    
    // Connect the nodes of the audio processing graph
    //delayNode to output. Remote IO bus 0 is used for the output side,
    Check(AUGraphConnectNodeInput (_graph, effectNode, 0, inputOutputNode, 0));
    //delayNode to output. Remote IO bus 1 is used to get audio input
    Check(AUGraphConnectNodeInput (_graph, inputOutputNode, 1, effectNode, 0));
    
    // Initialize graph
    
    result = AUGraphInitialize (_graph);
    NSAssert (result == noErr, @"Unable to initialze AUGraph object. Error code: %d '%.4s'", (int) result, (const char *)&result);
    
    // Start the graph
    result = AUGraphStart (_graph);
    NSAssert (result == noErr, @"Unable to start audio processing graph. Error code: %d '%.4s'", (int) result, (const char *)&result);
}

@end
