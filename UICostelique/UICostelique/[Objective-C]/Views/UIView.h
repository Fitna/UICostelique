//
//  UIView+Costelique.h
//  Karma and destiny
//
//  Created by Олег on 16.11.2017.
//  Copyright © 2017 Олег. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Costelique)
//@property (nonatomic) IBInspectable BOOL addBottomInsetToHeightConstraint;
//@property (nonatomic) IBInspectable BOOL addTopInsetToHeightConstraint;
- (UIImage *)imageRepresentation;
- (void)removeAllSubviewsRecursively:(bool)flag;
- (__kindof UIView *__nullable)findSubviewWithTag:(long)datTag;
- (NSArray <__kindof UIView* >*)findAllSubviewsTag:(long)datTag;

- (__kindof UIView *__nullable)subviewOfClass:(Class)datClass;
- (NSArray <__kindof UIView* >*)allSubviewsOfClass:(Class)datClass;
//- (id)findAllSubviewsClass:(Class)datClass;

-(void)blockView;
-(void)blockViewSilent;
-(void)unblockView;
-(NSLayoutConstraint *_Nullable)heightConstraint;
-(NSLayoutConstraint *_Nullable)widthConstraint;
-(NSLayoutConstraint *_Nullable)constraint:(NSLayoutAttribute)attr;
-(NSArray<NSLayoutConstraint *> *)constraints:(NSLayoutAttribute)attr;
-(void)addScaleAnimation;
- (UIViewController *)parentViewController;
-(void)setShadow:(UIColor *)color withOffset:(CGSize)size radius:(CGFloat)radius;
@end

NS_ASSUME_NONNULL_END
