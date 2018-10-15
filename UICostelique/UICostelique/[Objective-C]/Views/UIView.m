//
//  UIView+Costelique.m
//  Karma and destiny
//
//  Created by Олег on 16.11.2017.
//  Copyright © 2017 Олег. All rights reserved.
//

#import "UIView.h"
#import "UICosteliqueFunctions.h"
#import <objc/runtime.h>

@implementation UIView (Costelique)
-(void)removeAllSubviewsRecursively:(bool)flag;
{
    for (UIView *subv in [self.subviews reverseObjectEnumerator]) {
        if (flag) {
            [subv removeAllSubviewsRecursively:true];
        }
        [subv removeFromSuperview];
    }
}

- (id)subviewOfClass:(Class)datClass {
    for (UIView *vi in self.subviews) {
        if ([vi isMemberOfClass:datClass]) {
            return vi;
        }
    }
    return nil;
}

- (id)allSubviewsOfClass:(Class)datClass {
    NSMutableArray* arr = [NSMutableArray new];
    
    for (UIView *vi in self.subviews) {
        if ([vi isMemberOfClass:datClass]) {
            [arr addObject:vi];
        }
    }
    return arr;
}

- (id)findSubviewWithTag:(long)datTag {
    for (UIView *vi in self.subviews) {
        if (vi.tag == datTag) {
            return vi;
        }
        UIView *svi = [vi findSubviewWithTag:datTag];
        if (svi) {
            return svi;
        }
    }
    return nil;
}

-(id)findAllSubviewsTag:(long)datTag {
    NSMutableArray* arr = [NSMutableArray new];
    
    for (UIView *vi in self.subviews)
        if (vi.tag == datTag)
            [arr addObject:vi];
    return arr;
}

- (UIImage *)imageRepresentationOLD {
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenshot;
}

- (UIImage *)imageRepresentation {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.mainScreen.scale);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    UIImage * screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenshot;
}

-(void)blockViewSilent {
    [self blockView];
    [self hideBlockView];
}

#define BLOCK_VIEW_TAG 8712385
-(void)blockView
{
    for (UIView *vi in self.subviews) {
        if (vi.tag == BLOCK_VIEW_TAG) {
            return;
        }
    }
    UIView *view = [[UIView alloc] initWithFrame:[self bounds]];
    view.userInteractionEnabled = YES;
    view.tag = BLOCK_VIEW_TAG;
    [self addSubview:view];
    view.backgroundColor = [UIColor colorWithWhite:0 alpha:.3];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleWidth;
    CGRect rct = frameCenter(sizeMono(20), view.frame.size);
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithFrame:rct];
    [view addSubview:indicator];
    [indicator startAnimating];
    indicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
}

-(void)hideBlockView {
    for (UIView *vi in self.subviews) {
        if (vi.tag == BLOCK_VIEW_TAG) {
            [vi removeAllSubviewsRecursively:NO];
            vi.backgroundColor = nil;
        }
    }
}

-(void)unblockView {
    for (UIView *vi in self.subviews) {
        if (vi.tag == BLOCK_VIEW_TAG) {
            [vi removeFromSuperview];
        }
    }
}

-(NSLayoutConstraint *)constraint:(NSLayoutAttribute)attr {
    for (NSLayoutConstraint *constr in [self constraints]) {
        if (constr.firstAttribute == attr) {
            return constr;
        }
    }
    for (NSLayoutConstraint *constr in [self.superview constraints]) {
        if (constr.firstAttribute == attr && constr.firstItem == self) {
            return constr;
        }
        if (constr.secondAttribute == attr && constr.secondItem == self) {
        return  constr;
        }
    }
    return nil;
}

-(NSArray<NSLayoutConstraint *> *)constraints:(NSLayoutAttribute)attr {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (NSLayoutConstraint *constr in [self constraints]) {
        if (constr.firstAttribute == attr) {
            [arr addObject:constr];
        }
    }
    for (NSLayoutConstraint *constr in [self.superview constraints]) {
        if (constr.firstAttribute == attr && constr.firstItem == self) {
            [arr addObject:constr];
        } else if (constr.secondAttribute == attr && constr.secondItem == self) {
            [arr addObject:constr];
        }
    }
    return arr;
}

-(NSLayoutConstraint *)heightConstraint {
    for (NSLayoutConstraint *constr in [self constraints]) {
        if (constr.firstAttribute == NSLayoutAttributeHeight) {
            return constr;
        }
    }
    return nil;
}

-(NSLayoutConstraint *)widthConstraint {
    for (NSLayoutConstraint *constr in [self constraints]) {
        if (constr.firstAttribute == NSLayoutAttributeWidth) {
            return constr;
        }
    }
    return nil;
}


-(void)addScaleAnimation
{
    UIView *view = self;
    [view.layer removeAllAnimations];
    float scaleDurtation = 1;
    float scale = 1.1;
    float pause1 = 1.;
    float pause2 = 3.;
    NSArray *counts = @[@(1),@(2),@(1),@(2),@(5)];
    
    NSMutableArray *animations = [NSMutableArray new];
    float cuttrntTime = 0;
    for (NSNumber *numb in counts)
    {
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.duration = scaleDurtation;
        animation.repeatCount = numb.integerValue;
        animation.values = @[@(1), @(scale),@(1)];
        animation.beginTime = cuttrntTime;
        cuttrntTime += animation.repeatCount * scaleDurtation + pause1;
        [animations addObject:animation];
    }
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = cuttrntTime + pause2;
    animationGroup.repeatCount = INFINITY;
    animationGroup.animations = animations;
    [view.layer addAnimation:animationGroup forKey:@"scale animation"];
}

- (UIViewController *)parentViewController {
    UIResponder *responder = self;
    while ([responder isKindOfClass:[UIView class]]) {
        responder = [responder nextResponder];
    }
    return (UIViewController *)responder;
}

void *realHiddenKey = &realHiddenKey;

-(void)animateHidden:(BOOL)hidden {
    objc_setAssociatedObject(self, realHiddenKey, [NSNumber numberWithBool:hidden], OBJC_ASSOCIATION_RETAIN);

    if (hidden) {
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            BOOL realHidden = [(NSNumber *)objc_getAssociatedObject(self, realHiddenKey) boolValue];
            if (realHidden) {
                self.hidden = YES;
            }
        }];
    }
    if (!hidden) {
        if (self.isHidden) {
            self.alpha = 0;
            self.hidden = false;
        }
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 1;
        }];
    }
}

-(void)setShadow:(UIColor *)color withOffset:(CGSize)size radius:(CGFloat)radius {
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = size;
    self.layer.shadowRadius = radius;
    self.layer.shadowOpacity = 1;
}

void *botInset = &botInset;
-(void)setAddBottomInsetToHeightConstraint:(BOOL)addBottomInsetToHeightConstraint {
    objc_setAssociatedObject(self, botInset, [NSNumber numberWithBool:addBottomInsetToHeightConstraint], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(BOOL)addBottomInsetToHeightConstraint {
    return [objc_getAssociatedObject(self, botInset) boolValue];
}

void *topInset = &topInset;
-(void)setAddTopInsetToHeightConstraint:(BOOL)addTopInsetToHeightConstraint {
    objc_setAssociatedObject(self, botInset, [NSNumber numberWithBool:addTopInsetToHeightConstraint], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(BOOL)addTopInsetToHeightConstraint {
    return [objc_getAssociatedObject(self, topInset) boolValue];
}
@end

