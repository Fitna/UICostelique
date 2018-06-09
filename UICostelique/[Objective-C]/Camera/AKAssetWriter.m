//
//  AKAssetWriter.m
//  Sparkle Effects Editor
//
//  Created by Олег on 13.11.2017.
//  Copyright © 2017 Олег. All rights reserved.
//

#import "AKAssetWriter.h"

@interface AKAssetWriter ()
@property NSURL *videoOutputURL;
@property AVAssetWriter *videoWriter;
@property AVAssetWriterInputPixelBufferAdaptor *videoPixelAdaptor;
@end

@implementation AKAssetWriter
-(void)startVideoCaptureWithSize:(CGSize)size
{
    NSURL *url = [self createFileOutputURL];
    self.videoOutputURL = url;
    NSError *error;
    AVAssetWriter *writer = [[AVAssetWriter alloc] initWithURL:url fileType:AVFileTypeQuickTimeMovie error:&error];
    if (error) {
        NSLog(@"%@", error);
    }
    NSDictionary *videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                   AVVideoScalingModeResizeAspect, AVVideoScalingModeKey,
                                   [NSNumber numberWithInt:size.width], AVVideoWidthKey,
                                   [NSNumber numberWithInt:size.height], AVVideoHeightKey,
                                   nil];
    if (@available(iOS 11.0, *)) {
//    AVOutputSettingsAssistant *assistant = [AVOutputSettingsAssistant outputSettingsAssistantWithPreset:AVOutputSettingsPreset960x540];
        videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                   AVVideoCodecTypeH264, AVVideoCodecKey,
                                   AVVideoScalingModeResizeAspect, AVVideoScalingModeKey,
                                   [NSNumber numberWithInt:size.width], AVVideoWidthKey,
                                   [NSNumber numberWithInt:size.height], AVVideoHeightKey,
                                   nil];
    }
    AVAssetWriterInput *writerInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:videoSettings];
    writerInput.naturalSize = CGSizeMake(540,940);
    writerInput.transform = CGAffineTransformMakeScale(-1, 1);
//    writerInput.naturalSize = CGSizeMake(960,540);
//    writerInput.transform = CGAffineTransformMakeRotation(M_PI/2.);
    writerInput.expectsMediaDataInRealTime = YES;
    
    AVAssetWriterInputPixelBufferAdaptor *adaptor = [AVAssetWriterInputPixelBufferAdaptor assetWriterInputPixelBufferAdaptorWithAssetWriterInput:writerInput sourcePixelBufferAttributes:nil];
    self.videoPixelAdaptor = adaptor;
    
    [writer addInput:writerInput];
    self.videoWriter = writer;
}

-(NSURL *)createFileOutputURL {
    NSURL *cachesUrl = [[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask].firstObject;
    NSTimeInterval timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *filename = [NSString stringWithFormat:@"video_%08x.mov", (int)timestamp];
    NSString *path = [NSString stringWithFormat:@"%@/%@", cachesUrl.path, filename];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    for (NSString *str in [[fileManager contentsOfDirectoryAtPath:cachesUrl.path error:nil] reverseObjectEnumerator]) {
        [fileManager removeItemAtPath:str error:nil];
    }
    [fileManager createDirectoryAtURL:cachesUrl withIntermediateDirectories:YES attributes:nil error:nil];
    if([fileManager fileExistsAtPath:path]) {
        [fileManager removeItemAtPath:path error:nil];
    }
    
    return [NSURL fileURLWithPath:path];
}

-(void)stopVideoCaptureWithCompletion:(void (^)(NSURL *))completionBlock {
    if (self.videoWriter.status != AVAssetWriterStatusUnknown) {
        [self.videoWriter finishWritingWithCompletionHandler:^{
            completionBlock(self.videoOutputURL);
        }];
    }
}

-(void)wrightSampleBuffer:(CVPixelBufferRef)imageBuffer at:(CMTime)timestamp {
    if ([self.videoWriter status] == AVAssetWriterStatusUnknown) {
        [self.videoWriter startWriting];
        [self.videoWriter startSessionAtSourceTime:timestamp];
    }
    
    if ([self.videoWriter status] == AVAssetWriterStatusWriting) {
        if ([self.videoWriter.inputs.firstObject isReadyForMoreMediaData]) {
            [self.videoPixelAdaptor appendPixelBuffer:imageBuffer withPresentationTime:timestamp];
        }
    }
}

@end
