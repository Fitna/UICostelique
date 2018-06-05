//
//  UICosteliqueImages.m
//  Karma and destiny
//
//  Created by Олег on 16.11.2017.
//  Copyright © 2017 Олег. All rights reserved.
//

#import "UICosteliqueImages.h"
#import <CommonCrypto/CommonDigest.h>
#import <Metal/MTLTexture.h>

@implementation UIImage (Costelique)

+ (long)filtersCount
{
    return 13;
}

- (UIImage *)crop:(CGRect)rect {
    if (self.scale > 1.0f) {
        rect = CGRectMake(rect.origin.x * self.scale,
                          rect.origin.y * self.scale,
                          rect.size.width * self.scale,
                          rect.size.height * self.scale);
    }
    rect.origin.x = round(rect.origin.x);
    rect.origin.y = round(rect.origin.y);
    rect.size.width = round(rect.size.width);
    rect.size.height = round(rect.size.height);

    //    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    //    UIImage *result = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    //    CGImageRelease(imageRef);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, self.scale);
    [self drawAtPoint:CGPointMake(-rect.origin.x, -rect.origin.y)];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

-(UIImage *)resize:(CGSize)size withScale:(CGFloat)scale {
    size.width = roundf(size.width);
    size.height = roundf(size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)resize:(CGSize)size {
    return [self resize:size withScale: self.scale];
}

- (NSString *)MD5HexDigest {
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    NSData *rep = UIImagePNGRepresentation(self);
    CC_MD5(rep.bytes, (unsigned int)rep.length, result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for (int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}

- (UIImage *)scaleAndRotateImage
{
    CGImageRef imgRef = self.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = self.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageNew = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageNew;
}

+(NSArray *)filterNames
{
    static NSArray *names;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        names = @[@"Original",@"Sepia", @"Old Photo", @"Mono", @"Instant", @"Shift", @"Hue", @"Invert", @"Falce", @"Tonal", @"Transfer", @"Process", @"Chrome"];
    });
    return names;
}

- (UIImage *)applyFilter:(long)i
{
    CIImage *ciImage = [[CIImage alloc] initWithImage: self];
    CIImage *result = [ciImage applyFilter:i];
    CGRect extent1 = [result extent];
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage1 = [context createCGImage:result fromRect:extent1];
    UIImage *img = [UIImage imageWithCGImage:cgImage1];
    CGImageRelease(cgImage1);
    return img;
}

@end

@implementation CIImage (Costelique)
-(CIImage *)rotateByDeviceOrientation:(UIDeviceOrientation)deviceOrient
{
    double angle = 0;
    if (deviceOrient == UIDeviceOrientationLandscapeLeft)
        angle = M_PI/2.;
    else if (deviceOrient == UIDeviceOrientationLandscapeRight)
        angle = - M_PI/2.;
    else if (deviceOrient == UIDeviceOrientationPortraitUpsideDown)
        angle = M_PI;
    //    if (angle)
    {
        CGAffineTransform trans = CGAffineTransformRotate(CGAffineTransformIdentity, angle);
        trans = CGAffineTransformMakeScale(-1, 1);
        CIImage *ciimg = [self imageByApplyingTransform:trans];
        trans = CGAffineTransformIdentity;
        CGRect extent = ciimg.extent;
        trans.tx -= extent.origin.x;
        trans.ty -= extent.origin.y;
        ciimg = [ciimg imageByApplyingTransform:trans];
        return ciimg;
    }
    return self;
}




-(CIImage *)applyFilter:(long)i
{
    CIFilter *filter;
    
    switch (i) {
        case 0:
            return [self copy];
            break;
        case 1:
            filter = [CIFilter filterWithName:@"CISepiaTone"];
            break;
        case 2:
            filter = [CIFilter filterWithName:@"CIColorMonochrome"];
            break;
        case 3:
            filter = [CIFilter filterWithName:@"CIPhotoEffectMono"];
            break;
        case 4:
            filter = [CIFilter filterWithName:@"CIPhotoEffectInstant"];
            break;
        case 5:
            filter = [CIFilter filterWithName:@"CIHueAdjust"];
            [filter setDefaults];
            [filter setValue: [NSNumber numberWithFloat: M_PI] forKey: kCIInputAngleKey];
            break;
        case 6:
            filter = [CIFilter filterWithName:@"CIHueAdjust"];
            [filter setDefaults];
            [filter setValue: [NSNumber numberWithFloat: M_PI_2] forKey: kCIInputAngleKey];
            break;
        case 7:
            filter = [CIFilter filterWithName:@"CIColorInvert"];
            break;
        case 8:
            filter = [CIFilter filterWithName:@"CIFalseColor"];
            break;
        case 9:
            filter = [CIFilter filterWithName:@"CIPhotoEffectTonal"];
            break;
        case 10:
            filter= [CIFilter filterWithName:@"CIPhotoEffectTransfer"];
            break;
        case 11:
            filter= [CIFilter filterWithName:@"CIPhotoEffectProcess"];
            break;
        case 12:
            filter= [CIFilter filterWithName:@"CIPhotoEffectChrome"];
            break;
        case 30:
            filter = [CIFilter filterWithName:@"CIGaussianBlur"];
            [filter setDefaults];
            [filter setValue: [NSNumber numberWithFloat:(self.extent.size.width + self.extent.size.height)/30.] forKey:@"inputRadius"];
        default:
            break;
    }
    
    [filter setValue:self forKey:kCIInputImageKey];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    return result;
}
@end
