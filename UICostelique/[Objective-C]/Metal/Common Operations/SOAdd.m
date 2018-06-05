//
//  SFSrednee.m
//  ScreenStitch
//
//  Created by Олег on 25.05.2018.
//  Copyright © 2018 Олег. All rights reserved.
//

#import "SOAdd.h"

@implementation SOAdd

+(NSString *)functionName {
    return @"summTexture";
}

-(void)src1:(const id<MTLTexture>)src1 src2:(const id<MTLTexture>)src2 dst:(id<MTLTexture>)dst opacity:(float)opacity commandBuffer:(id<MTLCommandBuffer>)comBuf {
    [self startEncodeing: comBuf forTexture:dst];
    [self.commandEncoder setTexture:src1 atIndex:0];
    [self.commandEncoder setTexture:src2 atIndex:1];
    [self.commandEncoder setTexture:dst atIndex:2];
    [self.commandEncoder setBytes:&opacity length:sizeof(opacity) atIndex:0];
    [self finishEncodeing];
}

@end
