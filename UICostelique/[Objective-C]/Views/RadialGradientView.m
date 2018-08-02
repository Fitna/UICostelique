//
//  RadialGradientView.m
//  Jevelry AR
//
//  Created by Олег on 02.08.2018.
//  Copyright © 2018 Yegitov Aleksey. All rights reserved.
//

#import "RadialGradientView.h"
#import "RadialGradientLayer.h"

@implementation RadialGradientView {
    RadialGradientLayer *_gradient;
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
    _gradient = [RadialGradientLayer layer];
    [self.layer addSublayer:_gradient];
    _gradient.zPosition = 0 - 1;
    [self updateColor];
}

-(void)updateColor {
    _gradient.colorCenter = _centerColor;
    _gradient.colorEdge = _edgeColor;
    [_gradient setNeedsDisplay];
}

-(void)layoutSubviews {
    if (_gradient.frame.size.width != self.bounds.size.width) {
        [CATransaction begin];
        [CATransaction setDisableActions: true];
        _gradient.frame = self.bounds;
        [CATransaction commit];
    }
}

-(void)setEdgeColor:(UIColor *)edgeColor {
    _edgeColor = edgeColor;
    [self updateColor];
}

-(void)setCenterColor:(UIColor *)centerColor {
    _centerColor = centerColor;
    [self updateColor];
}

@end
