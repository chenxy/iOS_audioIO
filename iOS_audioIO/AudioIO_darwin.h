//
//  AudioIO_darwin.h
//  iOS_audioIO
//
//  Created by xychen on 2/2/16.
//  Copyright © 2016 xychen. All rights reserved.
//

#ifndef AudioIO_darwin_h
#define AudioIO_darwin_h

#import <AVFoundation/AVFoundation.h>

typedef enum {
    BEEP,
    INCOMMING_CALL,
    CALLING,
    
} SoundEffectType;

@interface AudioIO : NSObject <AVAudioPlayerDelegate>
{

}

-(instancetype) init;
-(void) playEffect:(NSString *)file withType:(SoundEffectType) type;
-(void) playVibrate;
-(void) stopVibrate;
-(void) startPlayingWithRecord:(BOOL) isRecord;

@end


#endif /* AudioIO_darwin_h */
