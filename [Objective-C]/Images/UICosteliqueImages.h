//
//  UICosteliqueImages.h
//  Karma and destiny
//
//  Created by Олег on 16.11.2017.
//  Copyright © 2017 Олег. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreImage/CoreImage.h>
#import <UIKit/UIDevice.h>


@interface UIImage (Costelique)
- (UIImage *)initWithMTLTexture:(id<MTLTexture>)texture mirrored:(BOOL)mirrored;
- (UIImage *)crop:(CGRect)rect;
- (UIImage *)resize:(CGSize)size;
- (UIImage *)resize:(CGSize)size withScale:(CGFloat)scale;
- (UIImage *)scaleAndRotateImage;
- (NSString *)MD5HexDigest;
@end



@interface CIImage (Costelique)
-(CIImage *)rotateByDeviceOrientation:(UIDeviceOrientation)deviceOrient;
-(CIImage *)applyFilter:(long)i;
@end

