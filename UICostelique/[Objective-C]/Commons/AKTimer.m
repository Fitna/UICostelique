//
//  AKTimer.m
//  Karma and destiny
//
//  Created by Олег on 16.11.2017.
//  Copyright © 2017 Олег. All rights reserved.
//

#import "AKTimer.h"
#import "UICosteliqueFunctions.h"

@interface AKTimer ()
@property NSDate *start;
@property NSMutableDictionary <NSString *, NSNumber *> *values;
//@property NSMutableDictionary <NSString *, NSNumber *> *iterations;
@property NSMutableArray <NSString *> *keys;
@property long printIterations;
@property (readonly) NSString *name;
@end

@implementation AKTimer {
    dispatch_queue_t _que;
}
static NSDate *startDate;
+(void)start {
    startDate = [NSDate date];
}

+(void)log {
    float time = [startDate timeIntervalSinceNow];
    NSLog(@"TIMER: %f", -time);
    [self start];
}

+(void)logWithString:(NSString *)string {
    float time = [startDate timeIntervalSinceNow];
    NSLog(@"%@: %f", string, -time);
    [self start];
}


+(instancetype)timerNamed:(NSString *)str {
#ifdef DEBUG
    return staticVariableWithID(str, ^id{
        return [[AKTimer alloc] initWithName:str];
    });
#else
    return nil;
#endif
}

+(instancetype)timerStarted {
    AKTimer *timer = [[AKTimer alloc] init];
    [timer reset];
    return timer;
}

- (instancetype)initWithName:(NSString *)name {
    self = [self init];
    if (self) {
        _name = name;
    }
    return self;
}

-(instancetype)init {
    self = [super init];
    if (self) {
        _values = [[NSMutableDictionary alloc] init];
        _keys = [[NSMutableArray alloc] init];
        //        _iterations = [[NSMutableDictionary alloc] init];
        _printIterations = 0;
        _clearOnPrint = YES;
        
        _que = dispatch_queue_create("AKTimer", DISPATCH_QUEUE_CONCURRENT);
        dispatch_set_target_queue(_que, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0));
    }
    return self;
}

-(void)log:(NSString *)str {
    NSDate *logDate = [NSDate date];
    __block float f;
    dispatch_sync(_que, ^{
        f = [_values valueForKey:str].floatValue;
    });
    
    f += [logDate timeIntervalSinceDate:self.start];
    
    dispatch_barrier_sync(_que, ^{
        [_values setValue:@(f) forKey:str];
        if (![_keys containsObject:str]) {
            [_keys addObject:str];
        }
    });
    [self reset];
}

-(void)print {
    [self printAfterIterations:1];
}

-(void)printAfterIterations:(NSInteger)iterations {
    __block long iter;
    dispatch_barrier_sync(_que, ^{
        iter = ++_printIterations;
    });
    if (iter % iterations) {
        return;
    }
    
    static dispatch_queue_t printQueue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        printQueue = dispatch_queue_create("lock", DISPATCH_QUEUE_SERIAL);
    });
    
    dispatch_sync(_que, ^{
        dispatch_sync(printQueue, ^{
            NSLog(@" ");
            NSLog(@" <TIMER name = \"%@\">", _name);
            float sum = 0;
            float iterations = iter;//[[_iterations valueForKey:key] floatValue];;
            for (NSString *key in _keys) {
                float value = [(NSNumber *)[_values valueForKey:key] floatValue];
                sum += value;
                NSLog(@"    %f - %@ ",value/iterations,key);
            }
            if (_keys.count > 1){
                NSLog(@"   --------------");
                NSLog(@"   All: %f (%d iterations)", (sum / (float)iter), (int)iter);
            }
            NSLog(@" </TIMER>");
        });
    });
    
    if (self.clearOnPrint) {
        dispatch_barrier_sync(_que, ^{
            _keys = [[NSMutableArray alloc] init];
            _values = [[NSMutableDictionary alloc] init];
            _printIterations = 0;
        });
    }
}

-(void)reset {
    self.start = [NSDate date];
}

@end
