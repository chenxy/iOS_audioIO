//
//  ViewController.m
//  iOS_audioIO
//
//  Created by xychen on 2/2/16.
//  Copyright © 2016 xychen. All rights reserved.
//

#import "ViewController.h"
#import "AudioIO_darwin.h"

@interface ViewController () {
    
    
}

@property(nonatomic, retain) AudioIO *audioIO;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _audioIO = [[AudioIO alloc] init];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction) beep:(id)sender {
    NSString *file = [[NSBundle mainBundle] pathForResource:@"onmessage" ofType:@"aif"];
    [_audioIO playEffect:file withType:BEEP];
}
-(IBAction) inComingCall:(id)sender {
    NSString *file = [[NSBundle mainBundle] pathForResource:@"ringtone" ofType:@"mp3"];
    [_audioIO playEffect:file withType:INCOMMING_CALL];
}
-(IBAction) calling:(id)sender {
    NSString *file = [[NSBundle mainBundle] pathForResource:@"ringback" ofType:@"mp3"];
    [_audioIO playEffect:file withType:CALLING];
}

-(IBAction) acceptCall:(id)sender {
    
}

-(IBAction) callEnd:(id)sender {
    
}

@end
