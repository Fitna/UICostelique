//
//  OnePixelView.m
//  Akciz
//
//  Created by Олег on 27.04.2018.
//  Copyright © 2018 Олег. All rights reserved.
//

#import "OnePixelView.h"

@implementation OnePixelView

-(NSLayoutConstraint *)constraint:(NSLayoutAttribute)attr {
    for (NSLayoutConstraint *constr in [self constraints]) {
        if (constr.firstAttribute == attr) {
            return constr;
        }
    }
    return nil;
}

-(void)awakeFromNib {
    [super awakeFromNib];
    [self constraint:NSLayoutAttributeHeight].constant = 1 / [UIScreen mainScreen].scale;
    [self constraint:NSLayoutAttributeWidth].constant = 1 / [UIScreen mainScreen].scale;
}

@end
