//
//  RadialGradientView.h
//  Jevelry AR
//
//  Created by Олег on 02.08.2018.
//  Copyright © 2018 Yegitov Aleksey. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE @interface RadialGradientView : UIView
@property (nonatomic) IBInspectable UIColor *centerColor;
@property (nonatomic) IBInspectable UIColor *edgeColor;

@end
