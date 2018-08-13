//
//  ViewWithImageMask.m
//  Akciz
//
//  Created by Олег on 24.04.2018.
//  Copyright © 2018 Олег. All rights reserved.
//

#import "ViewWithImageMask.h"
@interface ViewWithImageMask()
@property BOOL maskNeedsUpdadte;
@property CALayer *maskLayer;
@end

@implementation ViewWithImageMask
{
    CALayer *_layer;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        _maskLayer = [[CALayer alloc] init];
        self.layer.zPosition = 9000;
        self.layer.backgroundColor = [UIColor colorWithWhite:0 alpha:1].CGColor;
//        self.layer.masksToBounds = YES;
        self.layer.mask = _maskLayer;
    }
    return self;
}

-(void)updateMask {
    self.maskNeedsUpdadte = YES;
    [self _updateMask];
}

-(void)_updateMask {
    if (!self.maskNeedsUpdadte) {
        return;
    }
    self.maskNeedsUpdadte = NO;

    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    float scale = [[UIScreen mainScreen] scale];
    CGContextRef context = CGBitmapContextCreate(NULL, self.bounds.size.width * scale, self.bounds.size.height * scale,
                                                 8, 0, rgbColorSpace, kCGImageAlphaPremultipliedFirst);
    CGContextScaleCTM(context, scale, scale);
    CGContextSetRGBFillColor(context, 0, 0, 0, 1);
    CGContextFillRect(context, self.bounds);


    CGRect imageBounds = self.maskRect;
    imageBounds.origin.y = self.bounds.size.height - imageBounds.origin.y - imageBounds.size.height;
    CGContextSaveGState(context);
    CGContextClipToMask(context, imageBounds, self.maskImage.CGImage);
    CGContextClearRect(context, imageBounds);
    CGContextRestoreGState(context);

    CGImageRef ret = CGBitmapContextCreateImage(context);

    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _maskLayer.frame = self.bounds;
    [CATransaction commit];

    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _maskLayer.contents = (__bridge id)(ret);
    [CATransaction commit];

    CGImageRelease(ret);
    CGContextRelease(context);
}

@end
