//
//  PSCustomViewFromXib.m
//  CustomView
//
//  Created by Paul Solt on 4/28/14.
//  Copyright (c) 2014 Paul Solt. All rights reserved.
//

#import "ViewFromXib.h"

@implementation ViewFromXib

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self prepareForNib];
        [self setupCustomView];
        if(CGRectIsEmpty(frame)) {
            self.bounds = _customView.bounds;
        }
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self prepareForNib];
        [self setupCustomView];
    }
    return self;
}

-(void)prepareForNib{
    for (UIView *vi in self.subviews) {
        [vi removeFromSuperview];
    }
    self.backgroundColor = UIColor.clearColor;
}

-(void)setupCustomView {
    NSString *className = NSStringFromClass([self class]);
    NSRange range = [className rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"."]];
    if (range.length > 0) {
        className = [className substringFromIndex: range.location + 1];
    }
    
    _customView = [[[NSBundle mainBundle] loadNibNamed:className owner:self options:nil] firstObject];
    _customView.frame = self.bounds;
    [self addSubview:_customView];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    _customView.frame = self.bounds;
}

@end
