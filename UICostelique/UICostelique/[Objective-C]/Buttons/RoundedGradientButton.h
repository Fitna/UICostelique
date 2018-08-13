//
//  RoundedGradientButton.h
//  ManicureAR
//
//  Created by Олег on 09.08.2018.
//  Copyright © 2018 Олег. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

IB_DESIGNABLE @interface RoundedGradientButton : UIButton
@property (nonatomic) IBInspectable float cornerRadius; //if < 0, button is rounded
@property (nonatomic) IBInspectable UIColor *leftColor;
@property (nonatomic) IBInspectable UIColor *rightColor;
@property (nonatomic) IBInspectable float angle;
@end

NS_ASSUME_NONNULL_END
