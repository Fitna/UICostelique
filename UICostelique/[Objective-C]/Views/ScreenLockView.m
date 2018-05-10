//
//  ScreenLockView.m
//  Akciz
//
//  Created by Олег on 19.03.2018.
//  Copyright © 2018 Олег. All rights reserved.
//

#import "ScreenLockView.h"
#import "AKTimer.h"

@interface ScreenLockView ()
@property NSMutableArray *viewsInUse;
@property BOOL maskNeedsUpdadte;
@property dispatch_queue_t arrayQueue;
@property CALayer *maskLayer;
@end

@implementation ScreenLockView
-(instancetype)init{
    if (self != [super init]) {
        return nil;
    }
    _arrayQueue = dispatch_queue_create("queue", DISPATCH_QUEUE_CONCURRENT);
    _viewsInUse = [[NSMutableArray alloc] init];
    _maskLayer = [[CALayer alloc] init];
    self.layer.zPosition = 9000;
    self.layer.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7].CGColor;
    self.layer.masksToBounds = YES;
    self.layer.mask = _maskLayer;
    return self;
}

-(void)presentInView:(UIView *)view {
    [view addSubview:self];
    self.frame = view.bounds;
    self.maskNeedsUpdadte = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self _updateMask];
    });
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
    NSArray *arr = [self viewInUseCopy];

    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    float scale = [[UIScreen mainScreen] scale];
    CGContextRef context = CGBitmapContextCreate(NULL, self.bounds.size.width * scale, self.bounds.size.height * scale,
                                                 8, 0, rgbColorSpace, kCGImageAlphaPremultipliedFirst);
    CGContextScaleCTM(context, scale, scale);
    CGContextSetRGBFillColor(context, 0, 0, 0, 1);
    CGContextFillRect(context, self.bounds);

    for (UIView *view in arr) {
        CGRect bounds = view.bounds;
        CGRect convertedRect = [self convertRect:bounds fromView:view];
        convertedRect.origin.y = self.bounds.size.height - convertedRect.origin.y - convertedRect.size.height;
        UIGraphicsBeginImageContextWithOptions(bounds.size, NO, scale);
        [view drawViewHierarchyInRect:bounds afterScreenUpdates:NO];
        CGContextScaleCTM(UIGraphicsGetCurrentContext(), scale, scale);
        UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        CGContextSaveGState(context);
        CGContextClipToMask(context, convertedRect, snapshotImage.CGImage);
        CGContextClearRect(context, convertedRect);
        CGContextRestoreGState(context);
    }
    CGImageRef ret = CGBitmapContextCreateImage(context);

    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _maskLayer.frame = self.bounds;
    [CATransaction commit];

    [CATransaction begin];
    [CATransaction setDisableActions:YES];
//    [CATransaction setAnimationDuration:0.2];
//    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    _maskLayer.contents = (__bridge id)(ret);
    [CATransaction commit];

    CGImageRelease(ret);
    CGContextRelease(context);
}

-(void)removeFromSuperview {
    [super removeFromSuperview];
    _maskLayer.contents = nil;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.delegate lockView:self userDidTapWithEvent:event];
}

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    for (UIView *view in _viewsInUse) {
        if ([view pointInside: [self convertPoint:point toView:view] withEvent:event]) {
            return NO;
        }
    }
    return YES;
}


-(NSArray *)allowedViews {
    return [self viewInUseCopy];
}

-(void)setAllowedViews:(NSArray *)clickableViews {
    NSMutableArray *mut =  [clickableViews mutableCopy];
    dispatch_barrier_sync(_arrayQueue, ^{
        _viewsInUse = mut;
    });
    self.maskNeedsUpdadte = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self _updateMask];
    });
}

-(NSArray *)viewInUseCopy {
    __block NSArray *arr;
    dispatch_sync(_arrayQueue, ^{
        arr = [_viewsInUse copy];
    });
    return arr;
}

-(void)dealloc {
    _maskLayer.contents = nil;
}
@end


