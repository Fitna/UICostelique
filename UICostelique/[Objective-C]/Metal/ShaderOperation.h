//
//  Shaders.h
//  ScreenStitch
//
//  Created by Олег on 24.05.2018.
//  Copyright © 2018 Олег. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Metal/Metal.h>
#import "Texture&Images.h"

@protocol ShaderOperationProtocol
+(NSString *)functionName;
@optional
//both called on startEncodeing
-(MTLSize)getThreadgroupSize:(id<MTLComputePipelineState>)pipeline;
-(MTLSize)getThreadgroupsCountForTexture:(id<MTLTexture>)texture threadgroupSize:(MTLSize)trs;
@end


@interface ShaderOperation : NSObject <ShaderOperationProtocol>
@property id<MTLComputeCommandEncoder> commandEncoder;
-(void)startEncodeing:(id<MTLCommandBuffer>)commandBuffer forTexture:(id<MTLTexture>)texture;
-(void)finishEncodeing;
@end

