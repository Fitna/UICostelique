//
//  Texture&Images.h
//  ScreenStitch
//
//  Created by Олег on 30.05.2018.
//  Copyright © 2018 Олег. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShaderOperation.h"
#import "MetalContext.h"

id<MTLTexture> makeMetalTexture(MTLPixelFormat format, int width, int height);
id<MTLBuffer> makeMetalBuffer(NSUInteger length, MTLResourceOptions options);

@interface UIImage (MTLCostelique)
-(id<MTLTexture>)metalTexture;
- (UIImage *)initWithMTLTexture:(id<MTLTexture>)texture mirrored:(BOOL)mirrored;
@end
