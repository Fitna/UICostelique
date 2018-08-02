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
    }
    [self.layer addSublayer:_gradient];
    _gradient.zPosition = 0 - 1;
}

-(void)layoutSubviews {
    [CATransaction begin];
    [CATransaction setDisableActions: true];
    _gradient.frame = self.bounds;
    [CATransaction commit];
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
