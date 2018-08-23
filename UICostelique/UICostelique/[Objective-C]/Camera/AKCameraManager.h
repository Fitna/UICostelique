//
//  SessionManager.h
//  AuraMaker2
//
//  Created by Олег on 18.11.16.
//  Copyright © 2016 AV. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>


@interface AKCameraManager : NSObject
@property (readonly, nonatomic) CALayer *videoLayer;
@property (weak, nonatomic) id<AVCaptureVideoDataOutputSampleBufferDelegate> delegate;

-(void)capturePhotoWithDelegate:(id<AVCapturePhotoCaptureDelegate>)delegate;
-(void)changeCamera;

-(AVCaptureDevice *)currentDevice;
-(AVCaptureDevice *)frontCamera;
-(AVCaptureDevice *)backCamera;
-(BOOL)mirrored;
-(void)addVideoLayerTo:(CALayer *)layer;

-(BOOL)start;
-(void)stop;
-(BOOL)isRunning;

-(void)startVideoCapture;
-(void)stopVideoCaptureWithCompletion:(void (^)(NSURL *))completionBlock;
-(void)wrightSampleBuffer:(CVPixelBufferRef)imageBuffer at:(CMTime)timestamp;
@end
