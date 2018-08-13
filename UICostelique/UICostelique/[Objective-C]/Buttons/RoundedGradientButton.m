//
//  RoundedGradientButton.m
//  ManicureAR
//
//  Created by Олег on 09.08.2018.
//  Copyright © 2018 Олег. All rights reserved.
//

#import "RoundedGradientButton.h"

@implementation RoundedGradientButton
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
    }
    return self;
}

- (void)drawRect:(CGRect)rect {

    CGFloat gradColors[8];
    [_leftColor getRed:gradColors green:gradColors+1 blue:gradColors+2 alpha:gradColors+3];
    [_rightColor getRed:gradColors+4 green:gradColors+5 blue:gradColors+6 alpha:gradColors+7];
    CGFloat locations[2] = {0, 1};

    CGFloat h = self.bounds.size.height/2.0;
    CGPoint points[2] = {CGPointMake(0, h), CGPointMake(self.bounds.size.width, h)};
    CGFloat radius = _cornerRadius >= 0 ? _cornerRadius : h;
    CGPathRef path = CGPathCreateWithRoundedRect(self.bounds, radius, radius, nil);
    CGGradientDrawingOptions drawOptions = 0;
    if (_angle != 0) {
        [self rotateTwoPoints:points withAngle: _angle];
        drawOptions = kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation;
    }
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGGradientRef grad = CGGradientCreateWithColorComponents(space, gradColors, locations, 2);

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, grad, points[0], points[1], drawOptions);
    CGContextRestoreGState(context);

    CGGradientRelease(grad);
    CGColorSpaceRelease(space);
}

-(void)rotateTwoPoints:(CGPoint *)points withAngle:(float)angle {
    CGPoint center = CGPointMake((points[0].x + points[1].x)/2., (points[0].y + points[1].y)/2.);
    CGPoint tmpPoint = points[0];
    points[0].x = center.x + (tmpPoint.x - center.x) * cos(angle) - (tmpPoint.y - center.y) * sin(angle);
    points[0].y = center.y + (tmpPoint.x - center.x) * sin(angle) + (tmpPoint.y - center.y) * cos(angle);
    tmpPoint = points[1];
    points[1].x = center.x + (tmpPoint.x - center.x) * cos(angle) - (tmpPoint.y - center.y) * sin(angle);
    points[1].y = center.y + (tmpPoint.x - center.x) * sin(angle) + (tmpPoint.y - center.y) * cos(angle);

    points[0].x = MIN(points[0].x, self.bounds.size.width);
    points[0].y = MIN(points[0].y, self.bounds.size.height);
    points[1].x = MIN(points[1].x, self.bounds.size.width);
    points[1].y = MIN(points[1].y, self.bounds.size.height);

    points[0].x = MAX(points[0].x, 0);
    points[0].y = MAX(points[0].y, 0);
    points[1].x = MAX(points[1].x, 0);
    points[1].y = MAX(points[1].y, 0);
}

-(void)setAngle:(float)angle {
    _angle = angle;
    [self setNeedsDisplay];
}

-(void)setLeftColor:(UIColor *)leftColor {
    _leftColor = leftColor;
    [self setNeedsDisplay];
}

-(void)setRightColor:(UIColor *)rightColor {
    _rightColor = rightColor;
    [self setNeedsDisplay];
}

-(void)setCornerRadius:(float)cornerRadius {
    _cornerRadius = cornerRadius;
    [self setNeedsDisplay];
}

@end
