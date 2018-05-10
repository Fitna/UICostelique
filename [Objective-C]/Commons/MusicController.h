//
//  MusicController.h
//  Karma and destiny
//
//  Created by Олег on 01.12.2017.
//  Copyright © 2017 Олег. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface MusicController : NSObject
@property NSArray <NSString *> *musicThemes;
@property float volume;
@property bool soundOn;

+(instancetype)shared;

-(void)setTheme:(NSInteger)index;

-(void)pause;
-(void)play;

@end
