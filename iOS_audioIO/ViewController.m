//
//  ViewController.m
//  iOS_audioIO
//
//  Created by xychen on 2/2/16.
//  Copyright © 2016 xychen. All rights reserved.
//

#import "ViewController.h"
#import "AudioIO_darwin.h"

@interface ViewController () <AVAudioPlayerDelegate> {
  
}

@property(nonatomic, retain) AudioIO *audioIO;

@property(nonatomic, retain) NSMutableArray *playersHolder;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _audioIO = [[AudioIO alloc] init];

    _playersHolder = [[NSMutableArray alloc] init];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction) beep:(id)sender {

    NSString *file = [[NSBundle mainBundle] pathForResource:@"ringtone" ofType:@"mp3"];
    [_audioIO playEffect:file withType:BEEP];
}
-(IBAction) inComingCall:(id)sender {
    NSString *file = [[NSBundle mainBundle] pathForResource:@"ringtone" ofType:@"caf"];
    [_audioIO playEffect:file withType:INCOMMING_CALL];
}
-(IBAction) calling:(id)sender {
    NSString *file = [[NSBundle mainBundle] pathForResource:@"ringtone" ofType:@"caf"];
    [_audioIO playEffect:file withType:CALLING];
}

-(IBAction) vibrate:(id)sender {
    static BOOL isVibrate = false;
    if(!isVibrate) {
        [_audioIO playVibrate];
        isVibrate = true;
    } else {
        [_audioIO stopVibrate];
        isVibrate = false;
    }
    
}

-(IBAction) acceptCall:(id)sender {
    
}

-(IBAction) callEnd:(id)sender {
    
}

- (void) audioSessionInterrupt:(NSNotification *)notification {
    //NSLog(@"%@", notification.userInfo);
    UInt8 theInterruptionType = [[notification.userInfo valueForKey:AVAudioSessionInterruptionTypeKey] intValue];
    if(theInterruptionType == AVAudioSessionInterruptionTypeBegan) {
        NSLog(@"==== AVAudioSessionInterruptionTypeBegan");
        for(AVAudioPlayer *player in _playersHolder) {
            if([player isPlaying]) {
                [player pause];
                NSLog(@" |-- player pause");
            } else {
                NSLog(@" |-- player has already stopped");
                
            }
        }
    } else if(theInterruptionType == AVAudioSessionInterruptionTypeEnded) {
        NSLog(@"==== AVAudioSessionInterruptionTypeEnded");
        UInt8 resume = [[notification.userInfo valueForKey:AVAudioSessionInterruptionOptionKey] intValue];
        if(resume == 1) {
            
            NSLog(@" |-- AVAudioSessionInterruptionOptionShouldResume");
            for(AVAudioPlayer *player in _playersHolder) {
                [player pause];
                NSLog(@" |-- player play");
                
            }
        } else {
            NSLog(@" |-- AVAudioSessionInterruptionOptionShould [NOT] Resume");
        }
        
    }
}

- (void) mediaServicesReset:(NSNotification *)notification {
    NSLog(@"mediaServicesReset");
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [_playersHolder removeObject:player];
    NSLog(@"play finished");
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error {
    NSLog(@"play has error");
}

-(void) checkError:(NSError *) err {
    if(err) {
        NSLog(@"%@", err);
    }
}

-(IBAction) playMusic:(id)sender {
    NSError *err = nil;
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:&err];
    [self checkError:err];
    [session setActive:YES error:&err];
    [self checkError:err];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioSessionInterrupt:) name:AVAudioSessionInterruptionNotification object:session];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaServicesReset:)
                                                 name:AVAudioSessionMediaServicesWereResetNotification
                                               object:session];
    
    NSString *file = [[NSBundle mainBundle] pathForResource:@"HotelCalifornia" ofType:@"mp3"];
    NSURL *url = [[NSURL alloc] initFileURLWithPath:file];
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&err];
    [self checkError:err];
    
    [player setNumberOfLoops:0];
    [player setDelegate:self];
    [player play];
    [_playersHolder addObject:player];
    
}

-(IBAction)stopMusic:(id)sender {
    NSError *err;
    for(AVAudioPlayer *player in _playersHolder) {
        if([player isPlaying]) {
            [player stop];
        }
        [_playersHolder removeObject:player];
    }
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryAmbient error:&err];
    [self checkError:err];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionInterruptionNotification object:session];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionMediaServicesWereResetNotification object:session];
}


@end
