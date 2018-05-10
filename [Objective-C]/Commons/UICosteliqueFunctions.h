//
//  UICosteliqueFunctions.h
//  10kPhotoEditor
//
//  Created by Олег on 16.03.17.
//  Copyright © 2017 AKMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import <Metal/MTLTexture.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnullability-completeness"

void logPoint(CGPoint point);
void logFrame(CGRect frame);

bool coordInclude(CGPoint point, CGRect rect);

CGFloat pointDistance(CGPoint point1, CGPoint point2);
CGFloat pointsAngle(CGPoint center, CGPoint point1, CGPoint point2);

CGPoint pointshift(CGPoint p, CGPoint offset);
CGPoint pointdeshift(CGPoint p, CGPoint offset);
CGPoint pointDelta(CGPoint point1, CGPoint point2);
CGPoint pointFitInRect(CGPoint point, CGRect rect);
CGPoint pointScale (CGPoint point, float scale);
CGPoint pointCenterOfFrame(CGRect frame);

CGSize sizeScale(CGSize size, float scale);
CGSize sizeFill(CGSize size, CGSize sizeToFill);
CGSize sizeFit(CGSize size, CGSize sizeToFit);
CGSize sizeMono(float size);

CGRect frameCenter(CGSize size, CGSize sizeToCenter);

CGFloat affineGetScale(CGAffineTransform trans);
CGFloat affineGetAngle(CGAffineTransform at);
bool affineFlipped(CGAffineTransform trans);

void CATransactionMake(float duration, __nullable id function, void(^ _Nullable transaction)(void), void(^ _Nullable complBlock)(void));

CVPixelBufferRef CVPixelBufferWithMTLTexture(id<MTLTexture> texture);

CALayer * DrawSetka(CALayer *lay, UIColor *clr, CGRect rct, float wdth, float wdth2, float lngth);
CAShapeLayer *drawPoint(CALayer *layer, CGPoint center, float radius, UIColor *color);
CALayer *drawOvalGrad(CALayer *layer, CGPoint center, CGSize sz, UIColor *color);

NSString *randomStringWithLength(int len);
UIViewController *topViewControllerWithNavigationControllerControllers(void);
UIViewController *topViewController(void);

NSURL *cachesDirectory(void);

void dispatch_async_default(dispatch_block_t block);
void dispatch_after_default(float after, dispatch_block_t block);

void dispatch_sync_main_wdl(dispatch_block_t block);
void dispatch_async_main(dispatch_block_t block);
void dispatch_after_main(float after, dispatch_block_t block);

void repeat_periodically(float period, void(^block)(bool *souldStop));

id staticVariableWithID(NSString *identifier, id(^initializer)(void));

double realRand(void);

BOOL IPAD(void);

BOOL hasConnectivity(void);

#pragma clang diagnostic pop
