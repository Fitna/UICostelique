//
//  AKTimer.h
//  Karma and destiny
//
//  Created by Олег on 16.11.2017.
//  Copyright © 2017 Олег. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AKTimer : NSObject
@property BOOL clearOnPrint;

+(void)start;
+(void)log;
+(void)logWithString:(NSString *)string;

+(instancetype)timerNamed:(NSString *)str;
+(instancetype)timerStarted;

-(void)reset;
-(void)log:(NSString *)str;
-(void)print;
-(void)printAfterIterations:(NSInteger)iterations;
@end

