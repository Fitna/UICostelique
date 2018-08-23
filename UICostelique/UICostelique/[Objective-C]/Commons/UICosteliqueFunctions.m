//
//  UICosteliqueFunctions.m
//  10kPhotoEditor
//
//  Created by Олег on 16.03.17.
//  Copyright © 2017 AKMedia. All rights reserved.
//

#import "UICosteliqueFunctions.h"

#import <sys/socket.h>
#import <netinet/in.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "AKLog.h"

#ifdef DEBUG
bool _UICostelique_log_enabled = true;
#else
bool _UICostelique_log_enabled = false;
#endif

void UICostelique_enable_log(BOOL newValue) {
    _UICostelique_log_enabled = newValue;
}

void AKLog(NSString *string, ...) {
    if (!_UICostelique_log_enabled) {
        return;
    }
//    static float startTime;
//    if (startTime == 0) {
        // startTime = CFAbsoluteTimeGetCurrent();
//    }
    printf("UICostelique: ");//, CFAbsoluteTimeGetCurrent() - startTime);
    if (string) {
        va_list args;
        va_start(args, string);
        printf("%s", [[NSString alloc] initWithFormat:string arguments:args].UTF8String);
        va_end(args);
    }
    printf("\n");
}

void nyan()
{
    AKLog(@"\n                                                    /\\_/\\ \n                                                   ( o.o )\n                                                    > ^ <");
}

void logPoint(CGPoint point)
{
    AKLog(@"x = %f, y = %f", point.x, point.y);
}

void logFrame(CGRect frame)
{
    AKLog(@"x: %f, y:%f, width: %f, height: %f",frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
}

bool coordInclude( CGPoint point, CGRect rect)
{
    return point.x>rect.origin.x && point.y>rect.origin.y && point.x<rect.origin.x+rect.size.width && point.y<rect.origin.y+rect.size.height;
}

CGFloat pointDistance(CGPoint point1, CGPoint point2)
{
    CGFloat dx = point1.x - point2.x;
    CGFloat dy = point1.y - point2.y;
    return sqrt(dx*dx + dy*dy);
}

CGPoint pointshift(CGPoint p, CGPoint offset)
{
    return CGPointMake(p.x + offset.x, p.y + offset.y);
}
CGPoint pointdeshift(CGPoint p, CGPoint offset)
{
    return CGPointMake(p.x - offset.x, p.y - offset.y);
}
CGFloat pointsAngle(CGPoint center, CGPoint point1, CGPoint point2)
{
    return atan2(point1.y - center.y, point1.x - center.x) - atan2(point2.y - center.y, point2.x - center.x);
}

CGPoint pointDelta(CGPoint point1, CGPoint point2)
{
    return CGPointMake(point2.x-point1.x, point2.y- point1.y);
}

CGPoint pointFitInRect(CGPoint point, CGRect rect)
{
    CGFloat x = MIN(MAX(point.x, rect.origin.x), rect.size.width + rect.origin.x);
    CGFloat y = MIN(MAX(point.y, rect.origin.y), rect.size.height + rect.origin.y);
    return CGPointMake(x, y);
}

CGPoint pointCenterOfFrame(CGRect frame)
{
    return CGPointMake(frame.origin.x + frame.size.width/2., frame.origin.y + frame.size.height/2.);
}


CGSize sizeFit(CGSize size, CGSize sizeToFit)
{
    return size.width/sizeToFit.width>size.height/sizeToFit.height ? CGSizeMake(sizeToFit.width, sizeToFit.width*size.height/size.width) : CGSizeMake(sizeToFit.height*size.width/size.height, sizeToFit.height);
}

CGSize sizeFill(CGSize size, CGSize sizeToFill)
{
    return size.width / sizeToFill.width < size.height / sizeToFill.height ? CGSizeMake(sizeToFill.width, sizeToFill.width*size.height/size.width) : CGSizeMake(sizeToFill.height*size.width/size.height, sizeToFill.height);
}

CGSize sizeScale(CGSize size, float scale)
{
    return CGSizeMake(size.width*scale, size.height*scale);
}


CGRect frameCenter(CGSize size, CGSize sizeToCenter)
{
    return CGRectMake(sizeToCenter.width/2. - size.width/2., sizeToCenter.height/2. - size.height/2., size.width, size.height);
}

CGSize sizeMono(float size)
{
    return CGSizeMake(size, size);
}

NSString *randomStringWithLength(int len)
{
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    for (int i = 0; i < len; i++) {
        [randomString appendFormat: @"%c", [letters characterAtIndex: arc4random_uniform((int)[letters length])]];
    }
    
    return randomString;
}

CGFloat affineGetAngle(CGAffineTransform at)
{
    return atan2(at.b, at.a);
}

CGFloat affineGetScale(CGAffineTransform trans) {
    return sqrt(trans.a * trans.a + trans.b * trans.b);
}

bool affineFlipped(CGAffineTransform trans)
{
    return trans.a/trans.d < 0;
}

CGPoint pointShift(CGPoint point, CGPoint shift)
{
    return CGPointMake(point.x+shift.x, point.y+shift.y);
}

CAShapeLayer *drawLine(CALayer *location, UIColor *color, CGFloat width, CGPoint start, CGPoint end)
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(roundf(start.x), roundf(start.y))];
    [path addLineToPoint:CGPointMake(roundf(end.x), roundf(end.y))];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = [path CGPath];
    shapeLayer.strokeColor = [color CGColor];
    shapeLayer.lineWidth = width;
    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    [location addSublayer:shapeLayer];
    return shapeLayer;
}

CAShapeLayer *drawPoint(CALayer *location, CGPoint center, float radius, UIColor *color)
{
    CAShapeLayer *sl = [CAShapeLayer layer];
    sl.path = [[UIBezierPath bezierPathWithRoundedRect: CGRectMake(0, 0, 2.0 * radius, 2.0*radius) cornerRadius: radius] CGPath];
    sl.position = CGPointMake(center.x-radius, center.y-radius);
    sl.fillColor = color.CGColor;
    sl.lineWidth = 0;
    [location addSublayer: sl];
    return sl;
}

CGPoint pointScale (CGPoint point, float scale)
{
    return CGPointMake(point.x*scale, point.y*scale);
}

UIViewController *topViewControllerWithNavigationControllerControllers() {
    __block UIViewController *parentViewController;
    dispatch_main_sync_wdl(^{
        parentViewController = [[[UIApplication sharedApplication] delegate] window].rootViewController;
        while (parentViewController.presentedViewController != nil) {
            parentViewController = parentViewController.presentedViewController;
        }
        if ([parentViewController isKindOfClass:[UINavigationController class]]) {
            parentViewController = ((UINavigationController *)parentViewController).viewControllers.lastObject;
        }
    });
    return parentViewController;
}

UIViewController *topViewController() {
    __block UIViewController *parentViewController;
    dispatch_main_sync_wdl(^{
        parentViewController = [[[UIApplication sharedApplication] delegate] window].rootViewController;
        while (parentViewController.presentedViewController != nil) {
            parentViewController = parentViewController.presentedViewController;
        }
    });
    return parentViewController;
}

void CATransactionMake(float duration, __nullable id function, void(^transaction)(void)) {
    CATransactionMakeWithCompletion(duration, function, transaction, nil);
}

void CATransactionMakeWithCompletion(float duration, __nullable id function, void(^transaction)(void), void(^ _Nullable complBlock)(void))
{
    [CATransaction begin];
    if (duration <= 0) {
        [CATransaction setDisableActions:YES];
    }
    else {
        [CATransaction setAnimationDuration:duration];
        if ([function isKindOfClass:[CAMediaTimingFunction class]]) {
            [CATransaction setAnimationTimingFunction:function];
        } else if ([function isKindOfClass:[NSString class]]) {
            [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:function]];
        }
    }
    if (complBlock) {
        [CATransaction setCompletionBlock:complBlock];
    }
    
    if (transaction) {
        transaction();
    }
    [CATransaction commit];
}

NSURL *cachesDirectory()
{
    NSURL *url = [[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask].firstObject;
    return url;
}

void dispatch_async_default(dispatch_block_t block)
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
}

void dispatch_main_async(dispatch_block_t block)
{
    dispatch_async(dispatch_get_main_queue(), block);
}


void dispatch_after_default(float after, dispatch_block_t block)
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(after * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
}
void dispatch_main_after(float after, dispatch_block_t block)
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(after * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
}

void dispatch_main_sync_wdl(dispatch_block_t block)
{
    if (NSThread.isMainThread) {
        block();
    }
    else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

static void CVReleaseDataCallback(void *info, const void *data) {
    free((void *)data);
}


CVPixelBufferRef CVPixelBufferWithMTLTextureWithBytesBuffer(id<MTLTexture> texture, void *pixelBytes)
{
    NSUInteger bytesPerRow = 4 * texture.width;
    MTLRegion region = MTLRegionMake2D(0, 0, texture.width, texture.height);
    [texture getBytes:pixelBytes bytesPerRow:bytesPerRow fromRegion:region mipmapLevel:0];
    CVPixelBufferRef buffer;
    CVReturn result = CVPixelBufferCreateWithBytes(nil, texture.width, texture.height, kCVPixelFormatType_32BGRA, pixelBytes, bytesPerRow, CVReleaseDataCallback, nil, nil, &buffer);
    if (result == kCVReturnSuccess) {
        return buffer;
    }
    return nil;
}

CVPixelBufferRef CVPixelBufferWithMTLTexture(id<MTLTexture> texture)
{
    void *pixelBytes = malloc(4 * texture.width * texture.height);
    return CVPixelBufferWithMTLTextureWithBytesBuffer(texture, pixelBytes);
}


void repeat_periodically(float period, void (^block)(bool *))
{
    bool stop = NO;
    NSDate *startDate = [NSDate date];
    do {
        block(&stop);
        startDate = [startDate dateByAddingTimeInterval:period];
        do {
            int sleep = MAX(100, roundf(USEC_PER_SEC * period / 5.));
            usleep(sleep);
        }
        while ([startDate timeIntervalSinceNow] > 0);
    }
    while (!stop);
}

id staticVariableWithID(NSString *identifier, id(^initializer)(void)) {
    static NSMutableDictionary *allStatics;
    static dispatch_queue_t queue;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        allStatics = [[NSMutableDictionary alloc] init];
        queue = dispatch_queue_create("staticVariableWithID", DISPATCH_QUEUE_CONCURRENT);
    });
    
    __block id var;
    
    dispatch_sync(queue, ^{
        var = [allStatics objectForKey:identifier];
    });
    
    if (!var) {
        var = initializer();
        dispatch_barrier_sync(queue, ^{
            [allStatics setObject:var forKey:identifier];
        });
    }
    return var;
}

void dispatch_once_(NSString *token, dispatch_block_t block) {
    static dispatch_once_t onceToken[100];
    dispatch_once(&onceToken[0], block);
}

BOOL IPAD(void) {
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

static bool NO_CONNECTION = false;

void hasConnectivity_disable() {
    NO_CONNECTION = true;
}

void hasConnectivity_enable() {
    NO_CONNECTION = false;
}

BOOL hasConnectivity() {
    if (NO_CONNECTION) {
        return false;
    }
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;

    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)&zeroAddress);
    if (reachability != NULL) {
        //NetworkStatus retVal = NotReachable;
        SCNetworkReachabilityFlags flags;
        if (SCNetworkReachabilityGetFlags(reachability, &flags)) {
            if ((flags & kSCNetworkReachabilityFlagsReachable) == 0) {
                // If target host is not reachable
                CFRelease(reachability);
                return NO;
            }

            if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0) {
                // If target host is reachable and no connection is required
                //  then we'll assume (for now) that your on Wi-Fi
                CFRelease(reachability);
                return YES;
            }

            if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
                 (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0)) {
                // ... and the connection is on-demand (or on-traffic) if the
                //     calling application is using the CFSocketStream or higher APIs.

                if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0) {
                    // ... and no [user] intervention is needed
                    CFRelease(reachability);
                    return YES;
                }
            }

            if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN) {
                // ... but WWAN connections are OK if the calling application
                //     is using the CFNetwork (CFSocketStream?) APIs.
                CFRelease(reachability);
                return YES;
            }
        }
        CFRelease(reachability);
    }
    return NO;
}

typedef struct
{
    int x;
    union {
        int y;
        int z;
    };
} coords;

void fooTest()
{
    static void *lab[] = {&&$a, &&b, &&$c};
    goto *lab[2];
    
    $a:
    {
        long s[10];
        long *p = s;
        for (int i = 0; i < 10; i++) {
            *p++ = i;
            printf("s[%d]=%ld,   ",i,s[i]);
        }
        printf("\n");
        return;
    }
b:
    {
        simd_int8 v1 = {0,1,2,3,4,5,6,7};
        simd_int8 v2 = {7,6,5,4,3,2,1,0};
        simd_int8 v3 = v1 * v2;
        printf("v3 = %d, %d, %d, %d, %d, %d, %d, %d\n",v3[0],v3[1],v3[2],v3[3],v3[4],v3[5],v3[6],v3[7]);
        typedef int v __attribute__ ((vector_size (16)));
        v a = {1, 2, 3, 4};
        v b = {3, 3, 1, 10};
        v c = a - b;
        printf("c = %d, %d, %d, %d \n\n",c[0],c[1],c[2],c[3]);
        goto *lab[0];
    }
    $c:
    {
        coords s[10] = {[0 ... 2].x = 10, [3 ... 6].x = 9, [8].z = 6};
        int *arr = (int[]){[0] = s[4].x, [1 ... 9] = s[8].z};
        int d = ({*arr-=arr[9];});
        int h1 = s[1].x + d, h2, h3;
        switch (h1) {
            case 10 ... 15:
                h2 = 5;
                break;
            default:
                h2 = -1;
                break;
        }
        h3 = h2 + 1 ? : -1;
        printf("\nh1 = %d,   h2 = %d,   h3 = %d \n\n", h1, h2, h3);
        goto *lab[1];
    }
}



