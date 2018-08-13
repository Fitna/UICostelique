//
//  Geometry.h
//  Karma and destiny
//
//  Created by Олег on 16.11.2017.
//  Copyright © 2017 Олег. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGGeometry.h>
NS_ASSUME_NONNULL_BEGIN
@interface Geometry : NSObject

@property (readonly, class) Geometry * (^size)(CGSize sz);
@property (readonly, class) Geometry * (^rect)(CGRect rct);
@property (readonly, class) Geometry * (^point)(CGPoint pnt);

@property (readonly) Geometry * (^fill)(CGSize sizeToFill);
@property (readonly) Geometry * (^fit)(CGSize sizeToFit);
@property (readonly) Geometry * (^scale)(CGFloat scale);
@property (readonly) Geometry * (^shift)(CGFloat shift);
@property (readonly) Geometry * (^move)(CGPoint move);
@property (readonly) Geometry * roundf;

-(CGRect)rect;
-(CGPoint)point;
-(CGSize)size;
-(CGPoint)center;

-(CGFloat)x;
-(CGFloat)y;
-(CGFloat)width;
-(CGFloat)height;
@end
NS_ASSUME_NONNULL_END
