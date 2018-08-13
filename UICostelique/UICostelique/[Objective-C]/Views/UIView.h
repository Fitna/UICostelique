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
- (id)findSubviewWithTag:(long)datTag;
- (NSMutableArray *)findAllSubviewsTag:(long)datTag;
- (id)findSubviewClass:(Class)datClass;
- (NSMutableArray *)findAllSubviewsClass:(Class)datClass;
//- (id)findAllSubviewsClass:(Class)datClass;
-(void)blockView;
-(void)blockViewSilent;
-(void)unblockView;
-(NSLayoutConstraint *)heightConstraint;
-(NSLayoutConstraint *)widthConstraint;
-(NSLayoutConstraint *_Nullable)constraint:(NSLayoutAttribute)attr;
-(void)addScaleAnimation;
- (UIViewController *)parentViewController;
-(void)setShadow:(UIColor *)color withOffset:(CGSize)size radius:(CGFloat)radius;
@end

NS_ASSUME_NONNULL_END
