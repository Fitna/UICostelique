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

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initGradient];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initGradient];
    }
    return self;
}

-(void)initGradient {
    _gradient = [CAGradientLayer layer];
    [self.layer addSublayer:_gradient];
    [self updateColor];
}

-(void)updateColor {
    if (_colorTop && _colorBottom) {
        _gradient.colors = @[(__bridge id)_colorTop.CGColor, (__bridge id)_colorBottom.CGColor];
    }
}

-(void)layoutSubviews {
    if (!CGSizeEqualToSize(_gradient.frame.size, self.bounds.size)) {
        [CATransaction begin];
        [CATransaction setDisableActions: true];
        _gradient.frame = self.bounds;
        [CATransaction commit];
    }
}

-(void)setColorTop:(UIColor *)colorTop {
    _colorTop = colorTop;
    [self updateColor];
}

-(void)setColorBottom:(UIColor *)colorBottom {
    _colorBottom = colorBottom;
    [self updateColor];
}
@end
