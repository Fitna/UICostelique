//
//  Texture&Images.m
//  ScreenStitch
//
//  Created by Олег on 30.05.2018.
//  Copyright © 2018 Олег. All rights reserved.
//

#import "Texture&Images.h"
#import <MetalKit/MetalKit.h>
#import "AKLog.h"

id<MTLTexture> makeMetalTexture(MTLPixelFormat format, int width, int height) {
    if (width > 16384 || height > 16384) {
        return nil;
    }
    MTLTextureDescriptor *descriptor = [MTLTextureDescriptor texture2DDescriptorWithPixelFormat:format width:width height:height mipmapped:false];
    id<MTLTexture> texture = [MetalContext.defaultContext.device newTextureWithDescriptor: descriptor];
    return texture;
}

id<MTLBuffer> makeMetalBuffer(NSUInteger length, MTLResourceOptions options) {
    return [[MetalContext defaultContext].device newBufferWithLength:length options: options];
}

@implementation  UIImage (MTL)

static void MBEReleaseDataCallback(void *info, const void *data, size_t size)
{
    free((void *)data);
}

- (UIImage *)initWithMTLTexture:(id<MTLTexture>)texture mirrored:(BOOL)mirrored {
    
    CGFloat width = [texture width];
    CGFloat height = [texture height];
    size_t imageByteCount = width * height * 4;
    void *imageBytes = malloc(imageByteCount);

    NSUInteger bytesPerRow = width * 4;
    MTLRegion region = MTLRegionMake2D(0, 0, width, height);
    [texture getBytes:imageBytes bytesPerRow:bytesPerRow fromRegion:region mipmapLevel:0];
    if (texture.pixelFormat == MTLPixelFormatR32Float) {
        for (int i = 0; i < imageByteCount/4; i++) {
            float f = ((float *)imageBytes)[i];
            u_char *j = &((u_char *)imageBytes)[i*4];
            j[0] = f * 255;
            j[1] = f * 255;
            j[2] = f * 255;
            j[3] = 255;
        }
    }

    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, imageBytes, imageByteCount, MBEReleaseDataCallback);
    int bitsPerComponent = 8;
    int bitsPerPixel = 32;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo;
    switch ([texture pixelFormat]) {
        case MTLPixelFormatRGBA8Unorm:
            bitmapInfo = kCGImageByteOrder32Big | kCGImageAlphaPremultipliedLast;
            break;
        case MTLPixelFormatBGRA8Unorm_sRGB:
            bitmapInfo = kCGImageByteOrder32Big | kCGImageAlphaPremultipliedLast;
            break;
        case MTLPixelFormatR32Float:
            bitmapInfo = kCGImageByteOrder32Big | kCGImageAlphaPremultipliedLast;
            break;
        default:
            AKLog(@"wrong pixel format: %ld", [texture pixelFormat]);
            abort();
    }
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    CGImageRef imageRef = CGImageCreate(width,
                                        height,
                                        bitsPerComponent,
                                        bitsPerPixel,
                                        bytesPerRow,
                                        colorSpaceRef,
                                        bitmapInfo,
                                        provider,
                                        NULL,
                                        false,
                                        renderingIntent);

    UIImageOrientation orientation = mirrored ? UIImageOrientationUpMirrored : UIImageOrientationUp;
    self = [UIImage imageWithCGImage:imageRef scale:1.0 orientation:orientation];

    CFRelease(provider);
    CFRelease(colorSpaceRef);
    CFRelease(imageRef);
    return self;
}

-(id<MTLTexture>)metalTexture {
    CGImageRef cgimg = self.CGImage;
    BOOL needRelease = false;
    if ((CGImageGetBitmapInfo(cgimg) & kCGImageByteOrder32Big) == 0) {
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGImageRef imageRef = [self CGImage];
        CGFloat w = self.size.width;
        CGBitmapInfo info = kCGImageByteOrder32Big | kCGImageAlphaPremultipliedLast;
        CGContextRef bitmap = CGBitmapContextCreate(NULL, w, self.size.height, 8, w * 4, colorSpace, info);
        CGContextDrawImage(bitmap, CGRectMake(0, 0, self.size.width, self.size.height), imageRef);
        cgimg = CGBitmapContextCreateImage(bitmap);
        CGContextRelease(bitmap);
        CGColorSpaceRelease(colorSpace);
        needRelease = true;
    }

    MTKTextureLoader *loader = [[MTKTextureLoader alloc] initWithDevice: MetalContext.defaultContext.device];
    if (cgimg) {
        id<MTLTexture> texture =  [loader newTextureWithCGImage:cgimg options:nil error:nil];
        if (needRelease) {
            CGImageRelease(cgimg);
        }
        if (texture.pixelFormat != MTLPixelFormatRGBA8Unorm) {
            texture = [texture newTextureViewWithPixelFormat: MTLPixelFormatRGBA8Unorm];
        }
        return texture;
    }
    return nil;
}

@end
