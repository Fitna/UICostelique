//
//  AKAssetWriter.h
//  Sparkle Effects Editor
//
//  Created by Олег on 13.11.2017.
//  Copyright © 2017 Олег. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>


@interface AKAssetWriter : NSObject
-(void)startVideoCaptureWithSize:(CGSize)size;
-(void)stopVideoCaptureWithCompletion:(void (^)(NSURL *))completionBlock;
-(void)wrightSampleBuffer:(CVPixelBufferRef)imageBuffer at:(CMTime)timestamp;
@end
