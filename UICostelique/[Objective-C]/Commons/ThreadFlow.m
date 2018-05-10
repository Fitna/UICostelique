//
//  ThreadFlow.m
//  Karma and destiny
//
//  Created by Олег on 16.11.2017.
//  Copyright © 2017 Олег. All rights reserved.
//

#import "ThreadFlow.h"

@interface ThreadFlow ()
@property long counter;
@end

@implementation ThreadFlow
-(id)initWithName:(NSString *)name
{
    self = [super init];
    if (self) {
        _counter = 0;
        _name = name;
    }
    return self;
}



+(ThreadFlow *)flowNamed:(NSString *)str
{
    static NSMutableDictionary *allFlows;
    static dispatch_queue_t queue;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        allFlows = [NSMutableDictionary new];
        queue = dispatch_queue_create("flowNamed:", DISPATCH_QUEUE_CONCURRENT);
        dispatch_set_target_queue(queue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0));
    });
    
    __block ThreadFlow *flow;
    dispatch_sync(queue, ^{
        flow = [allFlows objectForKey:str];
    });
    if (!flow) {
        dispatch_barrier_sync(queue, ^{
            flow = [[ThreadFlow alloc] initWithName:str];
            [allFlows setObject:flow forKey:str];
        });
    }
    return flow;
}

-(void)dispatchAfter:(float)sec block:(dispatch_block_t)block
{
    @synchronized (self) {
        _counter++;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((sec - 0.08)* NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        long i;
        @synchronized (self) {
            i = --_counter;
        }
        if (!i && block) {
            dispatch_async(dispatch_get_main_queue(), block);
        }
    });
}
@end
