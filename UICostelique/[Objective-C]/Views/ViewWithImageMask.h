//
//  ViewWithImageMask.h
//  Akciz
//
//  Created by Олег on 24.04.2018.
//  Copyright © 2018 Олег. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewWithImageMask : UIView
@property CGRect maskRect;
@property UIImage *maskImage;
-(void)updateMask;
@end
