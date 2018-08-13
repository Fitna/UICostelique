//
//  Shaders.m
//  ScreenStitch
//
//  Created by Олег on 24.05.2018.
//  Copyright © 2018 Олег. All rights reserved.
//

#import "ShaderOperation.h"
#import "MetalContext.h"
#import <MetalKit/MetalKit.h>


@interface ShaderOperation()
@property MetalContext *context;
@property id<MTLFunction> function;
@property id<MTLComputePipelineState> pipeline;
@property MTLSize threadgroupSize_precalculated;
@property MTLSize threadgroupSize;
@property MTLSize threadgroupsCount;
@end


@implementation ShaderOperation
-(instancetype)init {
    if ([self isMemberOfClass:[ShaderOperation class]]) {
        NSLog(@"Must subclass ShaderFilter");
        abort();
    }

    if (self = [super init]) {
        _context = [MetalContext defaultContext];
        _function = [_context.library newFunctionWithName:[[self class] functionName]];
        if (_context.library && !_function) {
            NSLog(@"Must implement +(NSString *)functionName in ShaderFilter subclass");
            abort();
        }
        NSError *err;
        _pipeline = [_context.device newComputePipelineStateWithFunction:_function error:&err];
        if (err) {
            NSLog(@"Comute pipeline initialisation error \n %@", err);
            abort();
        }
        _threadgroupSize_precalculated = ({
            NSUInteger w = _pipeline.threadExecutionWidth;
            NSUInteger h = _pipeline.maxTotalThreadsPerThreadgroup / w;
            MTLSizeMake(w, h, 1);
        });

    }
    return self;
}

+(NSString *)functionName {
    return nil;
}

-(void)startEncodeing:(id<MTLCommandBuffer>)commandBuffer forTexture:(id<MTLTexture>)texture {
    id<MTLComputeCommandEncoder> encoder = [commandBuffer computeCommandEncoder];
    [encoder setComputePipelineState: _pipeline];
    _threadgroupSize = [self getThreadgroupSize:_pipeline];
    _threadgroupsCount = [self getThreadgroupsCountForTexture:texture threadgroupSize:_threadgroupSize];
    _commandEncoder = encoder;
}

-(void)finishEncodeing {
    [_commandEncoder dispatchThreadgroups:_threadgroupsCount threadsPerThreadgroup:_threadgroupSize];
    [_commandEncoder endEncoding];
    _commandEncoder = nil;
}

-(MTLSize)getThreadgroupSize:(id<MTLComputePipelineState>)pipeline {
    return _threadgroupSize_precalculated;
}

-(MTLSize)getThreadgroupsCountForTexture:(id<MTLTexture>)texture threadgroupSize:(MTLSize)trs {
    NSUInteger w = texture.width / trs.width + (bool)(texture.width % trs.width);
    NSUInteger h = texture.height / trs.height + (bool)(texture.height % trs.height);
    return MTLSizeMake(w, h, 1);
}

-(id<MTLTexture>)makeTextureFromImage:(UIImage *)image {
    MTKTextureLoader *loader = [[MTKTextureLoader alloc] initWithDevice: _context.device];
    CGImageRef cgimg = image.CGImage;
    if (cgimg) {
        return [loader newTextureWithCGImage:cgimg options:nil error:nil];
    }
    return nil;
}
@end

