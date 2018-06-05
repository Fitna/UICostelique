//
//  SOCopy.h
//  ScreenStitch
//
//  Created by Олег on 28.05.2018.
//  Copyright © 2018 Олег. All rights reserved.
//

#import "ShaderOperation.h"

@interface SOCopy : ShaderOperation
-(void)src:(id<MTLTexture>)src dst:(id<MTLTexture>)dst commandBuffer:(id<MTLCommandBuffer>)comBuf;
-(void)switchPointers:(id<MTLTexture> *)src1 and:(id<MTLTexture> *)src2;
@end
