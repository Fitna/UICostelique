//
//  RadialGradientLayer.m
//  Karma and destiny
//
//  Created by Олег on 16.11.2017.
//  Copyright © 2017 Олег. All rights reserved.
//

#import "RadialGradientLayer.h"
#import <UIKit/UIKit.h>
#import "AKTimer.h"

@implementation RadialGradientLayer
{
    bool _gradientAnimated;
    bool _increase;
    float _gradientColorCenter;
    NSTimer *_timer;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.contentsScale = 0.3;//[UIScreen mainScreen].scale;
        _gradientCenter = CGPointMake(.5, .5);
        _gradientColorCenter = .5;
        _increase = YES;
        _gradientAnimated = NO;
        memcpy(_controlPoints, (float[]){0., .5, 1.}, sizeof(float) * 3);
    }
    return self;
}

-(void)setGradientAnimated:(bool)gradientAnimated {
    _gradientAnimated = gradientAnimated;
    [_timer invalidate];
    if (gradientAnimated)
        _timer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(gradientAnimation) userInfo:nil repeats:YES];
}

-(bool)gradientAnimated {
    return _gradientAnimated;
}

-(void)gradientAnimation {
    if (_increase) {
        _gradientColorCenter += arc4random_uniform(100)/3333.;
        if (_gradientColorCenter > (_controlPoints[2] + _controlPoints[1])/2.)
            _increase = NO;
    } else {
        _gradientColorCenter -= arc4random_uniform(100)/3333.;
        if (_gradientColorCenter < (_controlPoints[0] + _controlPoints[1])/2.)
            _increase = YES;
    }
    [self setNeedsDisplay];
}

-(void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    [self setNeedsDisplay];
}

-(void)drawInContext:(CGContextRef)ctx {
    CGFloat r1,g1,b1,a1,r2,g2,b2,a2;
    [_colorCenter getRed:&r1 green:&g1 blue:&b1 alpha:&a1];
    [_colorEdge getRed:&r2 green:&g2 blue:&b2 alpha:&a2];
    CGFloat gradLocations[] = {_controlPoints[0], _controlPoints[1], _controlPoints[2]};
    float m1 = _gradientColorCenter;
    float m2 = 1-_gradientColorCenter;
    CGFloat gradColors[] = {r1, g1, b1, a1, (r1*m1+r2*m2), (g1*m1+g2*m2), (b1*m1+b2*m2), (a1*m1+a2*m2), r2, g2, b2, a2};
    CGColorSpaceRef clrspc = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(clrspc, gradColors, gradLocations, 3);
    CGContextSetBlendMode(ctx, kCGBlendModeHue);
    CGPoint gradCenter = CGPointMake(self.bounds.size.width*_gradientCenter.x, self.bounds.size.height*_gradientCenter.y);
    float gradRadius = MIN(self.bounds.size.width/2. , self.bounds.size.height/2.);
    CGContextDrawRadialGradient (ctx, gradient, gradCenter, 0, gradCenter, gradRadius, kCGGradientDrawsAfterEndLocation);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(clrspc);
}

-(float *)controlPoints {
    return _controlPoints;
}

@end
