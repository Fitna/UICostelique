//
//  GradientView.m
//  AuraMaker2
//
//  Created by Олег on 05.12.16.
//  Copyright © 2016 AV. All rights reserved.
//

#import "GradientView.h"

@implementation GradientView {
    CAGradientLayer *_gradient;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.backgroundColor = [UIColor clearColor];
        [self initGradient];
    }
    return self;
}

-(void)initGradient {
    [_gradient removeFromSuperlayer];
    _gradient = [CAGradientLayer layer];
    if (_colorTop && _colorBottom) {
        _gradient.colors = @[(__bridge id)_colorTop.CGColor, (__bridge id)_colorBottom.CGColor];
//        CGFloat r1, g1, b1, a1, r2, g2, b2, a2;
//        [_colorTop getRed:&r1 green:&g1 blue:&b1 alpha:&a1];
//        [_colorBottom getRed:&r2 green:&g2 blue:&b2 alpha:&a2];
//        UIColor *middleColor = [UIColor colorWithRed:(r1+r2)/2.0 green:(g1+g2)/2.0 blue:(b1+b2)/2.0 alpha:(a1+a2)/2.0];
//        _gradient.colors = @[(__bridge id)_colorTop.CGColor, (__bridge id)middleColor.CGColor, (__bridge id)_colorBottom.CGColor];
//        _gradient.locations = @[@(0),@(0.3),@(1)];
    }
    [self.layer addSublayer:_gradient];
    _gradient.zPosition = 0 - 1;
}

-(void)layoutSubviews {
    _gradient.frame = self.bounds;
}

-(void)setColorTop:(UIColor *)colorTop {
    _colorTop = colorTop;
    [self initGradient];
}

-(void)setColorBottom:(UIColor *)colorBottom {
    _colorBottom = colorBottom;
    [self initGradient];
}
@end
