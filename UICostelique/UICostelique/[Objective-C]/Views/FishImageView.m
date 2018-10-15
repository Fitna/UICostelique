//
//  FishImageView.m
//  UICostelique
//
//  Created by Олег on 14.08.2018.
//  Copyright © 2018 Олег. All rights reserved.
//

#import "FishImageView.h"

@implementation FishImageView
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.image = nil;
        self.backgroundColor = UIColor.clearColor;
        self.alpha = 0;
        [self setHidden:YES];
    }
    return self;
}
@end
