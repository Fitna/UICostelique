//
//  PSCustomViewFromXib.m
//  CustomView
//
//  Created by Paul Solt on 4/28/14.
//  Copyright (c) 2014 Paul Solt. All rights reserved.
//

#import "ViewFromXib.h"

@implementation ViewFromXib

+(NSString *)xibFileName {
    NSString *className = NSStringFromClass(self);
    NSRange range = [className rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"."]];
    if (range.length > 0) {
        className = [className substringFromIndex: range.location + 1];
    }
    return className;
}
    
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        if (CGRectIsEmpty(frame)) {
            self.bounds = _customView.bounds;
        }
        [self prepareForNib];
        [self setupCustomView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder: aDecoder];
    if (self) {
        [self prepareForNib];
        [self setupCustomView];
    }
    return self;
}

-(void)prepareForNib {
    [self setOpaque: false];
    for (UIView *vi in self.subviews) {
        [vi removeFromSuperview];
    }
}


-(void)setupCustomView {
    NSString *xibName = [self.class xibFileName];
    _customView = [[[NSBundle mainBundle] loadNibNamed:xibName owner:self options:nil] firstObject];
    _customView.backgroundColor = UIColor.clearColor;
    _customView.frame = self.bounds;
    [self addSubview:_customView];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    _customView.frame = self.bounds;
}

@end
