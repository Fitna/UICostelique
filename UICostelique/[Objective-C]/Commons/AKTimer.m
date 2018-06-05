//
//  AKTimer.m
//  Karma and destiny
//
//  Created by Олег on 16.11.2017.
//  Copyright © 2017 Олег. All rights reserved.
//

#import "AKTimer.h"
#import "UICosteliqueFunctions.h"

static char *const AKTimer_format = "  TIMER: ";

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
static CFTimeInterval startDate;
+(void)start {
    startDate = CFAbsoluteTimeGetCurrent();
}

+(void)log {
    [self log: nil];
}

+(void)log:(NSString *)string, ... {
    CFTimeInterval time = CFAbsoluteTimeGetCurrent() - startDate;
    printf("%s%f", AKTimer_format, time);
    if (string) {
        va_list args;
        va_start(args, string);
        printf(", %s ", [[NSString alloc] initWithFormat:string arguments:args].UTF8String);
        va_end(args);
    }
    printf(" \n");
    [self start];
}


+(instancetype)timerNamed:(NSString *)str {
#ifdef DEBUG
    static NSMutableDictionary *allTimers;
    static dispatch_queue_t queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        allTimers = [[NSMutableDictionary alloc] init];
        queue = dispatch_queue_create("timerNamed", DISPATCH_QUEUE_CONCURRENT);
    });
    __block id var;
    dispatch_sync(queue, ^{
        var = [allTimers objectForKey:str];
    });
    if (!var) {
        var = [[AKTimer alloc] initWithName:str];
        dispatch_barrier_sync(queue, ^{
            [allTimers setObject:var forKey:str];
        });
    }
    return var;
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
        f = [self->_values valueForKey:str].floatValue;
    });
    
    f += [logDate timeIntervalSinceDate:self.start];
    
    dispatch_barrier_sync(_que, ^{
        [self->_values setValue:@(f) forKey:str];
        if (![self->_keys containsObject:str]) {
            [self->_keys addObject:str];
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
        iter = ++self->_printIterations;
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
            NSLog(@" <TIMER name = \"%@\">", self->_name);
            float sum = 0;
            float iterations = iter;//[[_iterations valueForKey:key] floatValue];;
            for (NSString *key in self->_keys) {
                float value = [(NSNumber *)[self->_values valueForKey:key] floatValue];
                sum += value;
                NSLog(@"    %f - %@ ",value/iterations,key);
            }
            if (self->_keys.count > 1){
                NSLog(@"   --------------");
                NSLog(@"   All: %f (%d iterations)", (sum / (float)iter), (int)iter);
            }
            NSLog(@" </TIMER>");
        });
    });
    
    if (self.clearOnPrint) {
        dispatch_barrier_sync(_que, ^{
            self->_keys = [[NSMutableArray alloc] init];
            self->_values = [[NSMutableDictionary alloc] init];
            self->_printIterations = 0;
        });
    }
}

-(void)reset {
    self.start = [NSDate date];
}

@end
