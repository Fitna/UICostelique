//
//  MetalContext.m
//  ScreenStitch
//
//  Created by Олег on 24.05.2018.
//  Copyright © 2018 Олег. All rights reserved.
//

#import "MetalContext.h"

@implementation MetalContext
-(instancetype)init {
    if (self = [super init]) {
        _device = MTLCreateSystemDefaultDevice();
        _library = [_device newDefaultLibrary];
        _commandQueue = [_device newCommandQueue];
    }
    return self;
}

+(MetalContext *)defaultContext {
    static MetalContext *context;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        context = [[MetalContext alloc] init];
    });
    return context;
}
@end
