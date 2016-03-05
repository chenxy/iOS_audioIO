//
//  AudioIO_ios.m
//  iOS_audioIO
//
//  Created by xychen on 2/2/16.
//  Copyright © 2016 xychen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AudioIO_darwin.h"

@interface AudioIO()

@property(nonatomic, retain) NSMutableArray *audioPlayersHolder;

@end

@implementation AudioIO


-(instancetype) init {
    
    _audioPlayersHolder = [[NSMutableArray alloc] init];
    
    return self;
}

#pragma mark - AVAudioPlayerDelegate implementation

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [_audioPlayersHolder removeObject:player];
    NSLog(@"_audioPlayersHolder remove size = %ld", [_audioPlayersHolder count]);
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO error:nil];
}


- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error {
    NSLog(@"2");
}


-(void) playEffect:(NSString *)file withType:(SoundEffectType) type {
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
//    [audioSession setActive:YES error:nil];
    
    [audioSession setCategory:AVAudioSessionCategorySoloAmbient error:nil];
//    [audioSession setMode:AVAudioSessionModeVoiceChat error:nil];
    
    
    NSLog(@"%@", audioSession.category);
    NSLog(@"%@", audioSession.mode);
    
    if(type == BEEP) {
        SystemSoundID sound;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:file],&sound);
        AudioServicesPlaySystemSoundWithCompletion(sound, ^(){
            AudioServicesDisposeSystemSoundID(sound);
        
        });
        
        
    } else if(type == INCOMMING_CALL) {
//        SystemSoundID sound;
//        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:file],&sound);
//        AudioServicesPlayAlertSoundWithCompletion(sound, ^(){
//            AudioServicesDisposeSystemSoundID(sound);
//            
//        });

        NSURL *url = [[NSURL alloc] initFileURLWithPath:file];
        NSError *err;
        AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&err];

        [player setNumberOfLoops:0];
        [player setDelegate:self];
        [player play];
        [_audioPlayersHolder addObject:player];
        NSLog(@"_audioPlayersHolder add size = %ld", [_audioPlayersHolder count]);
        
    } else if(type == CALLING) {
        
        NSURL *url = [[NSURL alloc] initFileURLWithPath:file];
        NSError *err;
        AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&err];
        
        [player setNumberOfLoops:0];
        [player setDelegate:self];
        [player play];
        [_audioPlayersHolder addObject:player];
        NSLog(@"_audioPlayersHolder add size = %ld", [_audioPlayersHolder count]);
        
    } else {
        
    }
    
}

void systemAudioCallback(SystemSoundID ssID, void* clientData) {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

-(void) playVibrate {
    AudioServicesAddSystemSoundCompletion(kSystemSoundID_Vibrate, NULL, NULL, systemAudioCallback, NULL);
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

-(void) stopVibrate {
    AudioServicesRemoveSystemSoundCompletion(kSystemSoundID_Vibrate);
}

-(void) startPlayingWithRecord:(BOOL) isRecord {
    
}

@end
