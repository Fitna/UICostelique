//
//  RemoveADsButton.m
//  Hologramium
//
//  Created by Олег on 13.06.17.
//  Copyright © 2017 Олег. All rights reserved.
//

#import "GlareButton.h"
#import "UICostelique.h"

@interface GlareButton()
@property CAShapeLayer *layOval;
@property CAShapeLayer *layStroke;
@property UIView *clipView;
@property UILabel *label;
@property NSTimer *animationTimer;
@end


@implementation GlareButton
{
    INIT_TOKEN
}
INIT_ALL(initialize)

-(void)initialize
{
    UIColor *clr = [UIColor r:0 g:1 b:.3];
    
    _layStroke = [[CAShapeLayer alloc] init];
    _layStroke.fillColor = [UIColor colorWithWhite:0 alpha:.3].CGColor;
    _layStroke.strokeColor = clr.CGColor;
    _layStroke.lineWidth = 1;
    [self.layer addSublayer:_layStroke];
    
    _layStroke.shadowColor = clr.CGColor;
    _layStroke.shadowOffset = CGSizeZero;
    _layStroke.shadowRadius = 5;
    _layStroke.shadowOpacity = 1;
    
    _layOval = [[CAShapeLayer alloc] init];
    _layOval.fillColor = clr.CGColor;
    _layOval.strokeColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:_layOval];
    
    
    _clipView = [[UIView alloc] init];
    _clipView.layer.masksToBounds = true;
    _clipView.userInteractionEnabled = false;
    [self addSubview:_clipView];
    
    _label = [[UILabel alloc] init];
    _label.text = @"Remove ads";
    _label.font = [UIFont systemFontOfSize:18];
    _label.userInteractionEnabled = false;
    [self addSubview:_label];
}

-(void)willMoveToWindow:(UIWindow *)newWindow
{
    [super willMoveToWindow:newWindow];
    [self.animationTimer invalidate];
    self.animationTimer =   [NSTimer scheduledTimerWithTimeInterval:glareDuration1+0.5 repeats:YES block:^(NSTimer *timer){
        if (self.window) {
            [self animationGlare];
        } else {
            [timer invalidate];
        }
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self startTouchAnimation];
    [super touchesBegan:touches withEvent:event];
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self stopTouchAnimation];
    [super touchesCancelled:touches withEvent:event];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self stopTouchAnimation];
    [super touchesEnded:touches withEvent:event];
}

-(void)startTouchAnimation {
    [UIView transitionWithView:_label duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionCurveEaseOut animations:^{
        self.label.textColor = [UIColor whiteColor];
    } completion:nil];
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.duration = 0.5;
    animation.repeatCount = HUGE_VAL;
    animation.values = @[@(1), @(1.1),@(1)];
    [_layStroke addAnimation:animation forKey:@"sdadasasdasd"];
}

-(void)stopTouchAnimation
{
    [UIView transitionWithView:_label duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionCurveEaseOut animations:^{
        self.label.textColor = [UIColor blackColor];
    } completion:nil];
    [_layStroke removeAnimationForKey:@"sdadasasdasd"];
}

-(void)layoutSubviews
{
    CGRect strokeRect = self.bounds;
    strokeRect.origin.x += _layStroke.lineWidth/2;
    strokeRect.origin.y += _layStroke.lineWidth/2;
    strokeRect.size.width -= _layStroke.lineWidth;
    strokeRect.size.height -= _layStroke.lineWidth;
    
    _layStroke.path = [UIBezierPath bezierPathWithRoundedRect:strokeRect cornerRadius:MIN(strokeRect.size.width, strokeRect.size.height)/2.].CGPath;
    
    CGRect ovalRect = self.bounds;
    strokeRect.origin.x += _layStroke.lineWidth + 3;
    strokeRect.origin.y += _layStroke.lineWidth + 3;
    strokeRect.size.width -= (_layStroke.lineWidth + 3) * 2;
    strokeRect.size.height -= (_layStroke.lineWidth + 3) * 2;
    
    _layOval.path = [UIBezierPath bezierPathWithRoundedRect:ovalRect cornerRadius:MIN(ovalRect.size.width, ovalRect.size.height)/2.].CGPath;
    
    CAShapeLayer *clipLayer = [[CAShapeLayer alloc] init];
    clipLayer.frame = self.bounds;
    clipLayer.path =  [UIBezierPath bezierPathWithRoundedRect:ovalRect cornerRadius:MIN(ovalRect.size.width, ovalRect.size.height)/2.].CGPath;
    _clipView.layer.mask = clipLayer;
    
    _layOval.frame = self.bounds;
    _layStroke.frame = self.bounds;
    _clipView.frame = self.bounds;
    
    CGSize sz = _label.attributedText.size;
    _label.frame = CGRectMake(self.bounds.size.width/2. - sz.width/2., self.bounds.size.height/2. - sz.height/2., sz.width, sz.height);
}

static float glareDuration1 = 2;
-(void)animationGlare
{
    UIImage *glareImage = [UIImage imageNamed:@"Glare"];
    UIImageView *glareView = [[UIImageView alloc] initWithImage:glareImage];
    float w = self.bounds.size.height * glareImage.size.height / glareImage.size.width;
    CGRect startRect = CGRectMake(-w, 0, w, self.bounds.size.height);
    glareView.frame = startRect;
    [self.clipView addSubview:glareView];
    [UIView animateWithDuration:glareDuration1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        CGRect endRect = startRect;
        endRect.origin.x = self.bounds.size.width;
        glareView.frame = endRect;
    } completion:^(BOOL finished) {
        [glareView removeFromSuperview];
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(glareDuration1 * 0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self animationGlare2];
    });
}

-(void)animationGlare2
{
    UIImage *glareImage = [UIImage imageNamed:@"Star3"];
    UIImageView *iv = [[UIImageView alloc] initWithImage:glareImage];
    iv.frame = CGRectMake(0, 0, 30, 30);
    CGPoint glarePoint = CGPointMake(self.bounds.size.width - 6, self.bounds.size.height - 6);
    CGPoint center = [self convertPoint:glarePoint fromView:self];
    iv.center = center;
    [self addSubview:iv];
    iv.transform = CGAffineTransformMakeScale(0.01, 0.01);
    iv.alpha = 0;
    float duration = glareDuration1*0.467;
    [UIView animateWithDuration:duration/2. delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        iv.transform = CGAffineTransformIdentity;//;CGAffineTransformMakeRotation(M_PI-0.01);
        iv.alpha = 1;
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:duration/2. delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            CGAffineTransform trans = CGAffineTransformMakeScale(0.01, 0.01);
            iv.transform = trans;
        }completion:^(BOOL finished) {
        }];
    }];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.duration = duration;
    animation.values = @[@(0),@(M_PI-0.01), @((M_PI-0.01)*2.), @((M_PI-0.01)*3.)];
    [iv.layer addAnimation:animation forKey:@"AKAnimator.Radial"];
    
}
@end
