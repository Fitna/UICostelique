//
//  SFSrednee.h
//  ScreenStitch
//
//  Created by Олег on 25.05.2018.
//  Copyright © 2018 Олег. All rights reserved.
//

#import "ShaderOperation.h"

@interface SOAdd : ShaderOperation
-(void)src1:(const id<MTLTexture>)src1 src2:(const id<MTLTexture>)src2 dst:(id<MTLTexture>)dst opacity:(float)opacity commandBuffer:(id<MTLCommandBuffer>)comBuf;
@end
