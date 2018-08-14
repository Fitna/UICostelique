//
//  SOCopy.m
//  ScreenStitch
//
//  Created by Олег on 28.05.2018.
//  Copyright © 2018 Олег. All rights reserved.
//

#import "SOCopy.h"

@implementation SOCopy

+(NSString *)functionName {
    return @"copyTexture";
}

-(void)src:(id<MTLTexture>)src dst:(id<MTLTexture>)dst commandBuffer:(id<MTLCommandBuffer>)comBuf {
    [self startEncodeing: comBuf forTexture:dst];
    [self.commandEncoder setTexture:src atIndex:0];
    [self.commandEncoder setTexture:dst atIndex:1];
    [self finishEncodeing];
}

-(void)switchPointers:(id<MTLTexture> *)src1 and:(id<MTLTexture> *)src2 {
    __autoreleasing id <MTLTexture> *tmp = src2;
    src2 = src1;
    src1 = tmp;
    if (src2 == src1) return;
}
@end
