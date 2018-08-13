//
//  MusicController.m
//  Karma and destiny
//
//  Created by Олег on 01.12.2017.
//  Copyright © 2017 Олег. All rights reserved.
//

#import "MusicController.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
static void dispatch_sync_main_wdl(dispatch_block_t block)
{
    if (NSThread.isMainThread) {
        block();
    }
    else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}
static NSString *kSettingsVolume = @"am.music-controller.settings.volume";
static NSString *kSoundsOn = @"am.music-controller.settings.sounds";

@interface MusicController ()
@property AVAudioPlayer *audioPlayer;
@property NSInteger wasPlaying;
@property NSInteger currentIndex;
@end

@implementation MusicController
+(instancetype)shared {
    static MusicController *contr;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (![[NSUserDefaults standardUserDefaults] valueForKey:kSettingsVolume]) {
            [[NSUserDefaults standardUserDefaults] setFloat:0.5 forKey:kSettingsVolume];
        }
        if (![[NSUserDefaults standardUserDefaults] valueForKey:kSoundsOn]) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kSoundsOn];
        }
        contr = [[MusicController alloc] init];
    });
    return contr;
}

-(instancetype)init {
    self = [super init];
    _currentIndex = -1;
    return self;
}

-(void)setTheme:(NSInteger)index {
    self.currentIndex = index;
    [self play];
}

-(void)play
{
    if (_wasPlaying >= 0) {
        _currentIndex = _wasPlaying;
        _wasPlaying = -1;
    }
     
    
    float maxVolume = self.volume;
    if (maxVolume == 0) {
        [self.audioPlayer stop];
        self.audioPlayer = nil;
        return;
    }
    
    float step = 1/7.;
    int sleep = USEC_PER_SEC * 3 * step;
    
    AVAudioPlayer *currentPlayer = self.audioPlayer;
    if (currentPlayer) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            float volume = maxVolume;
            while (volume > 0) {
                volume -= step;
                dispatch_sync(dispatch_get_main_queue(), ^{
                    currentPlayer.volume = volume;
                });
                usleep(sleep);
            }
            dispatch_sync(dispatch_get_main_queue(), ^{
                [currentPlayer stop];
            });
        });
    }
    
    if (self.currentIndex >= 0) {
        NSArray *paths = self.musicThemes;
        NSString *name = paths[self.currentIndex];
        NSString *fileName = [name stringByDeletingPathExtension];
        NSString *extension = [name pathExtension];
        NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:fileName ofType: extension];
        NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
        AVAudioPlayer *newPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
        [newPlayer setVolume:0];
        newPlayer.numberOfLoops = -1; //Infinite
        [newPlayer play];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            float volume = 0;
            while (volume < maxVolume) {
                volume += step;
                dispatch_sync(dispatch_get_main_queue(), ^{
                    newPlayer.volume = volume;
                });
                usleep(sleep);
            }
        });
        self.audioPlayer = newPlayer;
    }
}

-(void)pause {
    NSInteger tmpIndex = _currentIndex;
    _currentIndex = -1;
    _wasPlaying = -1;
    [self play];
    _wasPlaying = tmpIndex;
    
}

-(void)setSoundOn:(bool)soundOn {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kSoundsOn];
}

-(bool)soundOn {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kSoundsOn];
}

-(void)setVolume:(float)volume {
    [[NSUserDefaults standardUserDefaults] setFloat:volume forKey:kSettingsVolume];
    dispatch_sync_main_wdl(^{
        self.audioPlayer.volume = volume;
    });
}

-(float)volume {
    return [[NSUserDefaults standardUserDefaults] floatForKey:kSettingsVolume];
}

@end
