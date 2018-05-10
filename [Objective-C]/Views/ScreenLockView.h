//
//  ScreenLockView.h
//  Akciz
//
//  Created by Олег on 19.03.2018.
//  Copyright © 2018 Олег. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScreenLockViewDelegate;

@interface ScreenLockView : UIView
@property id<ScreenLockViewDelegate> delegate;
@property (nonatomic) NSArray *allowedViews;
-(void)presentInView:(UIView *)view;
-(void)updateMask;
@end

@protocol ScreenLockViewDelegate
-(void)lockView:(ScreenLockView *)view userDidTapWithEvent:(UIEvent *)event;
@end
