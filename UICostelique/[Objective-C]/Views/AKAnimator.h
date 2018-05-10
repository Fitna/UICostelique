//
//  AKAnimator.h
//  Karma and destiny
//
//  Created by Олег on 16.11.2017.
//  Copyright © 2017 Олег. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIView.h>

@interface AKAnimator : NSProxy
@property float duration;
@property float amplitude;
-(void)shake;
-(void)jump;
-(void)scale;
-(void)shakeRadial;
-(void)setHidden:(BOOL)hide;
-(void)setHiddenNoScale:(BOOL)hide;
@end

@interface UIView (AKAnimator)
@property (nonatomic, readonly) AKAnimator *animator;
@end
