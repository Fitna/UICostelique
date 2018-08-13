//
//  AKTimer.m
//  Karma and destiny
//
//  Created by Олег on 16.11.2017.
//  Copyright © 2017 Олег. All rights reserved.
//

#import "AKTimer.h"

static char *const AKTimer_format = "  TIMER: ";

@interface AKTimer ()
@property CFAbsoluteTime start;
@property NSMutableDictionary <NSString *, NSNumber *> *values;
//@property NSMutableDictionary <NSString *, NSNumber *> *iterations;
@property NSMutableArray <NSString *> *keys;
@property long printIterations;
@property (readonly) NSString *name;
@end

@implementation AKTimer {

}
CFTimeInterval startDate;
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
        _start = CFAbsoluteTimeGetCurrent();
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
    }
    return self;
}

-(void)log:(NSString *)str {
    CFAbsoluteTime t = CFAbsoluteTimeGetCurrent();
    double f = [self->_values valueForKey:str].doubleValue;
    f += t - _start;

    [self->_values setValue:@(f) forKey:str];
    if (![self->_keys containsObject:str]) {
        [self->_keys addObject:str];
    }

    [self reset];
}

-(void)print {
    [self printAfterIterations:1];
}

-(bool)printAfterIterations:(NSInteger)iterations {
    long iter = ++self->_printIterations;
    if (iter % iterations) {
        return false;
    }
    
    static dispatch_queue_t printQueue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        printQueue = dispatch_queue_create("lock", DISPATCH_QUEUE_SERIAL);
    });
    
    dispatch_sync(printQueue, ^{
        printf("\n");
        printf("<TIMER name = \"%s\">\n", self->_name.UTF8String);
        double sum = 0;
        float iterations = iter;//[[_iterations valueForKey:key] floatValue];;
        for (NSString *key in self->_keys) {
            double value = [(NSNumber *)[self->_values valueForKey:key] doubleValue];
            sum += value;
            printf("    %f - %s\n",value/(self->_clearOnPrint ? iterations : 1),key.UTF8String);
        }
        if (self->_keys.count > 1){
            printf("   --------------\n");
            printf("   All: %f (%d iterations)\n", sum / (float)(self->_clearOnPrint ? iterations : 1), (int)iter);
        }
        printf("</TIMER>\n");
    });
    
    if (self.clearOnPrint) {
        self->_keys = [[NSMutableArray alloc] init];
        self->_values = [[NSMutableDictionary alloc] init];
        self->_printIterations = 0;
    }
    return true;
}

-(void)reset {
    self->_start = CFAbsoluteTimeGetCurrent();
}

@end
