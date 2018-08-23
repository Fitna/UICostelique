//
//  SessionManager.m
//  AuraMaker2
//
//  Created by Олег on 18.11.16.
//  Copyright © 2016 AV. All rights reserved.
//

#import "AKCameraManager.h"
#import "AKAssetWriter.h"
#import "AKLog.h"

static void dispatch_sync_main_wdl(dispatch_block_t block)
{
    if (NSThread.isMainThread) {
        block();
    }
    else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

static UIViewController* topViewController() {
    __block UIViewController *parentViewController;
    dispatch_sync_main_wdl(^{
        parentViewController = [UIApplication sharedApplication].windows.lastObject.rootViewController;
        
        while (parentViewController.presentedViewController != nil) {
            parentViewController = parentViewController.presentedViewController;
        }
        if ([parentViewController isKindOfClass:[UINavigationController class]]) {
            parentViewController = ((UINavigationController *)parentViewController).viewControllers.lastObject;
        }
    });
    return parentViewController;
}


@interface AKCameraManager ()
@property AVCaptureSession *session;
@property AVCaptureDevice *device;
@property AVCaptureVideoDataOutput *videoDataOutput;
@property AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
@property AVCapturePhotoOutput *photoOutput;

@property (weak) id innerDelegate;
@property BOOL recordeingNow;
@property BOOL isLastFrameWritten;
@property AKAssetWriter *assetWriter;
@end

@implementation AKCameraManager {
    BOOL _mirrored;
}

-(instancetype)init {
    if (self = [super init]) {
        [self setupCaptureVideoDataOutput];
    }
    return self;
}

-(void)setupCaptureVideoDataOutput {
    _session = ({
        AVCaptureSession *captureSession = [[AVCaptureSession alloc] init];
        [captureSession setSessionPreset: AVCaptureSessionPresetiFrame960x540];
        captureSession;
    });
    
    _device = ({
        AVCaptureDevice *device = [self backCamera];
        NSError *error;
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error: &error];
        if([_session canAddInput:input]) {
            [_session addInput:input];
        }
        device;
    });
    
    _photoOutput = ({
        AVCapturePhotoOutput *stillPhotoOutput = [[AVCapturePhotoOutput alloc] init];
        if (stillPhotoOutput.livePhotoCaptureSupported) {
            stillPhotoOutput.livePhotoCaptureEnabled = YES;
        }
        
        if ([_session canAddOutput:stillPhotoOutput]) {
            [_session addOutput:stillPhotoOutput];
        }
        stillPhotoOutput;
    });
    
    _videoDataOutput = ({AVCaptureVideoDataOutput *videoOutput = [[AVCaptureVideoDataOutput alloc] init];
        videoOutput.videoSettings = @{
                                      (id)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_32BGRA),
//                                      (id)kCVPixelBufferMetalCompatibilityKey : (__bridge id)kCFBooleanTrue
                                      };
        videoOutput.alwaysDiscardsLateVideoFrames = YES;
        if ([_session canAddOutput:videoOutput]) {
            [_session addOutput:videoOutput];
        }
        videoOutput;
    });
}

-(CALayer *)videoLayer {
    return _captureVideoPreviewLayer;
}

-(void)setDelegate:(id<AVCaptureVideoDataOutputSampleBufferDelegate>) delegate {
    [self.videoDataOutput setSampleBufferDelegate:(id)self queue:dispatch_queue_create("capture_session_queue", DISPATCH_QUEUE_SERIAL)];
    self.innerDelegate = delegate;
}

-(id<AVCaptureVideoDataOutputSampleBufferDelegate>)delegate {
    return self.innerDelegate;
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    self.isLastFrameWritten = NO;
    if ([self.innerDelegate respondsToSelector:@selector(captureOutput:didOutputSampleBuffer:fromConnection:)]) {
        [self.innerDelegate captureOutput:captureOutput didOutputSampleBuffer:sampleBuffer fromConnection:connection];
    }
    if (self.recordeingNow && !self.isLastFrameWritten) {
        CVPixelBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        CMTime time = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
        [self wrightSampleBuffer:imageBuffer at:time];
    }
}

-(void)wrightSampleBuffer:(CVPixelBufferRef)imageBuffer at:(CMTime)timestamp {
    self.isLastFrameWritten = YES;
    [self.assetWriter wrightSampleBuffer:imageBuffer at:timestamp];
}

-(void)capturePhotoWithDelegate:(id<AVCapturePhotoCaptureDelegate>)delegate {
    [self.photoOutput capturePhotoWithSettings:[AVCapturePhotoSettings photoSettings] delegate:delegate];
}

-(AVCaptureDevice *)currentDevice {
    return self.device;
}

- (AVCaptureDevice *)frontCamera {
    NSMutableArray *devices = [[[AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes: @[AVCaptureDeviceTypeBuiltInWideAngleCamera, AVCaptureDeviceTypeBuiltInTelephotoCamera] mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionFront] devices] mutableCopy];
    if (@available(iOS 10.2, *)) {
        [devices addObjectsFromArray:[[AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes: @[AVCaptureDeviceTypeBuiltInDualCamera] mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionFront] devices]];
    }

    AVCaptureDevice * camera = devices.firstObject;
    if ([camera isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
        NSError *error;
        [camera lockForConfiguration:&error];
        if (!error) {
            camera.focusMode = AVCaptureFocusModeContinuousAutoFocus;
            [camera unlockForConfiguration];
        }
    }
    return camera;
}

- (AVCaptureDevice *)backCamera {
    NSMutableArray *devices = [[[AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes: @[AVCaptureDeviceTypeBuiltInWideAngleCamera, AVCaptureDeviceTypeBuiltInTelephotoCamera] mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack] devices] mutableCopy];
    if (@available(iOS 10.2, *)) {
        [devices addObjectsFromArray:[[AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes: @[AVCaptureDeviceTypeBuiltInDualCamera] mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionFront] devices]];
    }
    AVCaptureDevice * camera = devices.firstObject;
    if ([camera isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
        NSError *error;
        [camera lockForConfiguration:&error];
        if (!error) {
            camera.focusMode = AVCaptureFocusModeContinuousAutoFocus;
            [camera unlockForConfiguration];
        }
    }
    return camera;
}

-(BOOL)mirrored {
    return !_mirrored;
}

-(void)fixOutput:(AVCaptureOutput *)output {
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in output.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection)
            break;
    }
    _mirrored = !(self.device == [self frontCamera]);
    [videoConnection setVideoOrientation: AVCaptureVideoOrientationPortrait];
    [videoConnection setVideoMirrored: _mirrored];
}

-(BOOL)start {
    if (!self.session.outputs.count) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Camera" message:@"Allow application use camera" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *settings = [UIAlertAction actionWithTitle:@"Open Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
            }];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:settings];
            [alert addAction:cancel];
            [topViewController() presentViewController:alert animated:YES completion:nil];
            [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
                [self start];
                [[NSNotificationCenter defaultCenter] removeObserver:self];
            }];
        });
    }
    
    if (![self.session isRunning] && self.session.outputs.count) {
        [self fixOutput:self.videoDataOutput];
//        [self fixOutput:self.photoOutput];
        [self.session startRunning];
    }
    
    if ([self.session isRunning]) {
        return YES;
    }
    return NO;
}

-(void)stop {
    if ([self.session isRunning]) {
        [self.session stopRunning];
    }
}

-(BOOL)isRunning {
    return [self.session isRunning];
}

-(void)changeCamera {
    bool running = [self isRunning];
    if (running) {
        [self stop];
    }
    
    if (self.device == [self backCamera]) {
        self.device = [self frontCamera];
    } else {
        self.device = [self backCamera];
    }
    
    for (AVCaptureInput *inp in [self.session.inputs reverseObjectEnumerator]) {
        [self.session removeInput:inp];
    }
    
    NSError *error;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice: self.device error: &error];
    if([self.session canAddInput: input]) {
        [self.session addInput: input];
    }
    
    [self fixOutput:self.videoDataOutput];
//    [self fixOutput:self.photoOutput];
    
    if (running) {
        [self start];
    }
}

- (void)addVideoLayerTo:(CALayer *)layer {
    if (_captureVideoPreviewLayer) {
        [_captureVideoPreviewLayer.superlayer removeObserver:self forKeyPath:@"bounds"];
        [_captureVideoPreviewLayer removeFromSuperlayer];
        _captureVideoPreviewLayer = nil;
    }

    if (self.session.inputs.count) {
        _captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession: self.session];
        _captureVideoPreviewLayer.masksToBounds = YES;
    }
    
    if (_captureVideoPreviewLayer) {
        [_captureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        _captureVideoPreviewLayer.frame = layer.bounds;
        _captureVideoPreviewLayer.zPosition = -1;
        [layer insertSublayer: _captureVideoPreviewLayer atIndex:0];
        [layer addObserver:self forKeyPath:@"bounds" options:NSKeyValueObservingOptionNew context:nil];
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"bounds"] && [object isKindOfClass:[CALayer class]]) {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        _captureVideoPreviewLayer.frame = ((CALayer *)object).bounds;
        [CATransaction commit];
    }
}

-(void)startVideoCapture {
    self.assetWriter = [[AKAssetWriter alloc] init];
    [self.assetWriter startVideoCaptureWithSize:CGSizeMake(540, 960)];
    self.recordeingNow = YES;
}

-(void)stopVideoCaptureWithCompletion:(void (^)(NSURL *))completionBlock {
    self.recordeingNow = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.assetWriter stopVideoCaptureWithCompletion:completionBlock];
    });
}

-(void)dealloc {
    [_session stopRunning];
    [_captureVideoPreviewLayer.superlayer removeObserver:self forKeyPath:@"bounds"];
    [_captureVideoPreviewLayer removeFromSuperlayer];
}

@end
