//
//  AKAnimator.m
//  Karma and destiny
//
//  Created by Олег on 16.11.2017.
//  Copyright © 2017 Олег. All rights reserved.
//

#import "AKAnimator.h"
#import <objc/runtime.h>

@interface AKAnimator ()
@property (weak) UIView *view;
@property () BOOL animateHideing;
@property () BOOL animateHideingLastValue;
@end

@implementation AKAnimator
{
}

-(instancetype)initWithView:(UIView *)view {
    _view = view;
    _duration = -1;
    _amplitude = 1;
    return self;
}

- (void) shake
{
    float duration = _duration;
    if (duration == -1)
        duration = 0.6;
    
    float amplitude = _amplitude*(_view.frame.size.width/20.+_view.frame.size.height/20.);
    float x = _view.transform.tx;
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.duration = duration;
    animation.values = @[ @(x-amplitude), @(x+amplitude), @(x-amplitude), @(x+amplitude), @(x-amplitude/2.), @(x+amplitude/2.), @(x-amplitude/4.), @(x+amplitude/4.), @(x) ];
    
    [_view.layer addAnimation:animation forKey:@"AKAnimator.shake"];
}
- (void) jump
{
    float duration = _duration;
    if (duration == -1)
        duration = 0.4;
    
    float height = _amplitude*(_view.frame.size.height/10.);
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.y"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.duration = duration;
    animation.values = @[ @(-height), @(0),@(-height/3.), @(0)];
    
    [_view.layer addAnimation:animation forKey:@"AKAnimator.jump"];
}
- (void) scale
{
    float duration = _duration;
    if (duration == -1)
        duration = 0.15;
    
    float newScale = _amplitude*(1.1);
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.duration = duration;
    animation.values = @[ @(1), @(newScale),@(1)];
    
    [_view.layer addAnimation:animation forKey:@"AKAnimator.scale"];
}

-(void)shakeRadial
{
    float duration = _duration;
    if (duration == -1)
        duration = 1;
    
    float amplitude = _amplitude*(M_PI/16.);
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.duration = duration;
    animation.values = @[ @(-amplitude), @(amplitude), @(-amplitude), @(amplitude), @(-amplitude/2.), @(amplitude/2.), @(-amplitude/4.), @(amplitude/4.), @(0) ];
    
    [_view.layer addAnimation:animation forKey:@"AKAnimator.shakeRadial"];
}

-(void)setHidden:(BOOL)hide
{
    float duration = _duration;
    if (duration == -1)
        duration = 0.3;
    
    if (_animateHideing && hide == _animateHideingLastValue)
        return;
    if (hide && _view.hidden) {
        _animateHideingLastValue = hide;
        return;
    }
    if (hide == NO && !_view.hidden && !(_animateHideing && _animateHideingLastValue)) {
        _animateHideingLastValue = hide;
        return;
    }
    _animateHideing = YES;
    _animateHideingLastValue = hide;
    CGAffineTransform scaled = CGAffineTransformMakeScale(.9, .9);
    if (hide) {
        _view.transform = CGAffineTransformMakeScale(1, 1);
    }
    else {
        _view.alpha = 0;
        _view.hidden = NO;
        _view.transform = scaled;
    }
    
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         if (hide) {
                             self.view.alpha = 0;
                             self.view.transform = scaled;
                         }
                         else {
                             self.view.alpha = 1;
                             self.view.transform = CGAffineTransformIdentity;
                         }
                     }
                     completion:^(BOOL finished){
                         if (hide && self.animateHideingLastValue) {
                             self.view.hidden = YES;
                         }
                         self.animateHideing = NO;
                     }
     ];
}
-(void)setHiddenNoScale:(BOOL)hide
{
    float duration = _duration;
    if (duration == -1)
        duration = 0.2;

    if (_animateHideing && hide == _animateHideingLastValue)
        return;

    if (hide == NO && !_view.hidden && !(_animateHideing && _animateHideingLastValue))
        return;
    
    _animateHideing = YES;
    _animateHideingLastValue = hide;

    if (!hide){
        _view.alpha = 0;
        _view.hidden = NO;
    }

    [UIView animateWithDuration:duration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                             self.view.alpha = hide ? 0 : 1;
                     }
                     completion:^(BOOL finished){
                         if (hide &&  self.animateHideingLastValue) {
                              self.view.hidden = YES;
                         }
                          self.animateHideing = NO;
                     }
     ];
}
@end


@implementation UIView (AKAnimator)
static void *ak_animatorKey = &ak_animatorKey;
-(AKAnimator *)animator {
    AKAnimator *anim = objc_getAssociatedObject(self, ak_animatorKey);
    if (!anim) {
        anim = [[AKAnimator alloc] initWithView:self];
        objc_setAssociatedObject(self, ak_animatorKey, anim, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return anim;
}

@end

