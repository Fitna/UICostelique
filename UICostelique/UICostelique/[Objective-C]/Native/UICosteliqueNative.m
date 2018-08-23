//
//  UICosteliqueNative.m
//  10kPhotoEditor
//
//  Created by Олег on 16.03.17.
//  Copyright © 2017 AKMedia. All rights reserved.
//

#import "UICosteliqueNative.h"
#import "UICosteliqueFunctions.h"

#import <CoreImage/CIFilter.h>
#import <CommonCrypto/CommonDigest.h>
#import <objc/runtime.h>
#import "AKLog.h"

#ifndef DEBUG
#define AK_DEBUG 0
#define DEBUG_INTERFACE @interface DebugProxy : NSProxy @end @implementation DebugProxy \
void runDebug(void); +(void)load { if (AK_DEBUG) { runDebug(); } } @end
#define STORED_BYTES @"20202020 202a2020 20202020 20202020 20202020 20202020 2a0a2020 20202020 2020205f 5f202020 20202020 20202020 20202020 202a0a20 20202020 202c6462 27202020 202a2020 2020202a 0a202020 20202c64 382f2020 20202020 202a2020 20202020 20202a20 2020202a 0a202020 20203838 380a2020 20202060 64625c20 20202020 20202a20 20202020 2a0a2020 20202020 20606f60 5f202020 20202020 20202020 20202020 20202020 202a2a0a 20202a20 20202020 20202020 20202020 20202a20 20202a20 2020205f 20202020 20202a0a 20202020 20202020 2a202020 20202020 20202020 20202020 20202f20 290a2020 2020202a 20202020 285c5f5f 2f29202a 20202020 20202028 20282020 2a0a2020 202c2d2e 2c2d2e2c 29202020 20282e2c 2d2e2c2d 2e2c2d2e 2920292e 2c2d2e2c 2d2e0a20 207c2040 7c20203d 7b202020 2020207d 3d207c20 407c2020 2f202f20 7c20407c 6f207c0a 205f6a5f 5f6a5f5f 6a5f2920 20202020 602d2d2d 2d2d2d2d 2f202f5f 5f6a5f5f 6a5f5f6a 5f0a205f 5f5f5f5f 5f5f5f28 20202020 20202020 20202020 2020202f 5f5f5f5f 5f5f5f5f 5f5f5f0a 20207c20 207c2040 7c205c20 20202020 20202020 20202020 207c7c20 6f7c4f20 7c20407c 0a20207c 6f207c20 207c2c27 5c202020 20202020 2c202020 2c27227c 20207c20 207c2020 7c202068 6a770a20 76565c7c 2f76567c 602d275c 20202c2d 2d2d5c20 20207c20 5c56765c 686a7756 765c2f2f 760a2020 20202020 20202020 20205f29 20292020 2020602e 205c202f 0a202020 20202020 20202020 285f5f2f 20202020 20202029 20290a20 20202020 20202020 20202020 20202020 20202020 285f2f"
#endif

#ifdef DEBUG_INTERFACE
DEBUG_INTERFACE void runDebug() {
    NSString *bytes = STORED_BYTES;
    const char *chars = [[bytes stringByReplacingOccurrencesOfString:@" " withString:@""] UTF8String] ;
    long i = 0, len = bytes.length;
    NSMutableData *data = [NSMutableData dataWithCapacity:len / 2];
    char byteChars[3] = {'\0','\0','\0'};
    unsigned long wholeByte;
    while (i < len) {
        byteChars[0] = chars[i++];
        byteChars[1] = chars[i++];
        wholeByte = strtoul(byteChars, NULL, 16);
        [data appendBytes:&wholeByte length:1];
    }
    NSString *debugInfo = [[NSString alloc] initWithData:data encoding:kCFStringEncodingUTF8];
    printf("\n %@\n",[debugInfo UTF8String]);
}
#endif

@implementation SKProduct (LocalizedPrice)
-(NSString *)localizedPrice {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setLocale: self.priceLocale];
    return [numberFormatter stringFromNumber: self.price];
}
@end

@implementation UIColor (Costelique)
+(instancetype)r:(float)r g:(float)g b:(float)b
{
    bool is255 = (r > 1. || g > 1. || b > 1.);
    return [[self class] colorWithRed: is255 ? r /255. : r green: is255 ? g /255. : g blue: is255 ? b /255. : b alpha:1];
}

+(instancetype)r:(float)r g:(float)g b:(float)b a:(float)a
{
    bool is255 = (r > 1. || g > 1. || b > 1.);
    return [[self class] colorWithRed: is255 ? r /255. : r green: is255 ? g /255. : g blue: is255 ? b /255. : b alpha:a];
}

+(instancetype)randomColor
{
    return [self colorWithRed: arc4random_uniform(256)/255. green: arc4random_uniform(256)/255. blue: arc4random_uniform(256)/255. alpha:1];
}

-(instancetype)randomizeWithDeflection:(float)f
{
    CGFloat r, g, b, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    r = r + ((int)(arc4random_uniform(10000)-5000))*f/5000.;
    g = g + ((int)(arc4random_uniform(10000)-5000))*f/5000.;
    b = b + ((int)(arc4random_uniform(10000)-5000))*f/5000.;
    return [UIColor colorWithRed:r green:g blue:b alpha:a];
}

+ (UIColor *)colorWidthHexString:(NSString *)hexString {
    hexString = [hexString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}
-(UIImage *)UIImage
{
    UIGraphicsBeginImageContext(CGSizeMake(1, 1));
    CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), self.CGColor);
    CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, 1, 1));
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
@end


#pragma mark -

@implementation UISlider(Costelique)
-(void)setThumbImage:(UIImage *)thumbImage {
    if (thumbImage) {
        [self setThumbImage:thumbImage forState:UIControlStateNormal];
        [self setThumbImage:thumbImage forState:UIControlStateHighlighted];
        [self setThumbImage:thumbImage forState:UIControlStateDisabled];
        [self setThumbImage:thumbImage forState:UIControlStateSelected];
    }
}

-(UIImage *)thumbImage {
    return [self thumbImageForState: UIControlStateNormal];
}

@end


#pragma mark -
@implementation UILabel (Costelique)

-(void)setCustomFont:(NSString *)customFont {
    if (customFont.length) {
        UIFont *font = [UIFont fontWithName:customFont size:self.font.pointSize];
        if (font) {
            self.font = font;
        }
    }
}

-(NSString *)customFont {
    return self.font.fontName;
}

- (float)expectedHeightWithWidth:(float)width{
    [self setNumberOfLines:0];
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys: [self font], NSFontAttributeName, nil];
    CGRect rct = [[self text] boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:0 attributes:dict context:[NSStringDrawingContext new]];
    return rct.size.width;
}
void *fontKey = &fontKey;
-(UIFont *)originalFont {
    return objc_getAssociatedObject(self, fontKey);
}
-(void)setOriginalFont:(UIFont *)font {
    objc_setAssociatedObject(self, fontKey, font, OBJC_ASSOCIATION_RETAIN);
}

-(void)_setTextWithFitting:(NSArray *)arr {
    float width = self.bounds.size.width;
    UIFont *font = [self originalFont];
    float minSize = self.minimumScaleFactor * font.pointSize;

    for (NSString *word in arr) {
        while ([word sizeWithAttributes:@{NSFontAttributeName: font}].width >= width) {
            if (font.pointSize < minSize) {
                break;
            } else {
                font = [font fontWithSize: font.pointSize - 1];
            }
        }
    }
    self.font = font;
}

-(void)updateTextSizeToFitWordsByWidth {
    if (![self originalFont]) {
        [self setOriginalFont: self.font];
    }

    NSString *string = self.text;
    NSArray *arr = [string componentsSeparatedByString:@" "];
    [self _setTextWithFitting:arr];

    if (self.font.pointSize < [self originalFont].pointSize && arr.count == 1) {
        NSMutableArray *arr1 = [[string componentsSeparatedByString:@"-"] mutableCopy];
        arr1[0] = [arr1[0] stringByAppendingString:@"-"];
        if (arr1.count > arr.count) {
            [self _setTextWithFitting: arr1];
        }
    }
}
@end

#pragma mark -
@implementation CALayer (Costelique)
-(void)pauseAnimations {
    CFTimeInterval pausedTime = [self convertTime:CACurrentMediaTime() fromLayer:nil];
    self.speed = 0.0;
    self.timeOffset = pausedTime;
}

-(void)resumeAnimations
{
//    CFTimeInterval pausedTime = [self timeOffset];
    self.speed = 1.0;
    //self.timeOffset = 0.0;
    //self.beginTime = 0.0;
    //CFTimeInterval timeSincePause = [self convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
//    self.timeOffset = timeSincePause;
}

-(void)removeAllSublayers
{
    if (self.sublayers.count) {
        for(long i = self.sublayers.count; i--;) {
            [self.sublayers[i] removeFromSuperlayer];
        }
    }
}

@end


@implementation UIView (Costelique)
-(__kindof UIResponder *)findFirstResponder {
    if (self.isFirstResponder) return self;
    for (UIView *view in self.subviews) {
        id responder = [view findFirstResponder];
        if (responder) return responder;
    }
    return nil;
}
@end

UIStatusBarStyle ak_UIStatusBarStyle_getPlistValue() {
    static UIStatusBarStyle plistValue = UIStatusBarStyleDefault;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *contentStyle = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UIStatusBarStyle"];
        if ([contentStyle isEqualToString:@"UIStatusBarStyleLightContent"]) {
            plistValue = UIStatusBarStyleLightContent;
        }
    });
    return plistValue;
}

#pragma mark -
@implementation UIViewController (Costelique)
-(__kindof UIResponder *)firstResponder {
    return [self.view findFirstResponder];

}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return ak_UIStatusBarStyle_getPlistValue();
}

-(void)showAlert:(NSString *)title withMessage:(NSString *)text
{
    UIAlertController *contr = [UIAlertController alertControllerWithTitle:title message:text preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        return;
    }];
    [contr addAction:cancel];
    [self showViewController:contr sender:nil];
}

-(void)goToSettingsAlert:(NSString *)title withMessage:(NSString *)text completion:(bool (^)(void))completion
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:text
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *settings = [UIAlertAction actionWithTitle:@"Settings"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action)
                               {
                                   NSURL *url = [NSURL URLWithString: UIApplicationOpenSettingsURLString] ;
                                   [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                                   if (completion) {
                                       [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification
                                                       object:nil
                                                        queue:[NSOperationQueue mainQueue]
                                                   usingBlock:^(NSNotification * _Nonnull note)
                                        {
                                            bool sucess = completion();
                                            if (sucess) {
                                                [[NSNotificationCenter defaultCenter] removeObserver:self
                                                              name:UIApplicationDidBecomeActiveNotification
                                                            object:nil];
                                            }
                                        }];
                                   }
                               }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:settings];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}
@end

#pragma mark -
@implementation UIWindow (Costelique)

- (UIViewController *)topViewController {
    __block UIViewController *parentViewController;
    dispatch_main_sync_wdl(^{
        parentViewController = [[[UIApplication sharedApplication] delegate] window].rootViewController;
        while (parentViewController.presentedViewController != nil){
            parentViewController = parentViewController.presentedViewController;
        }
    });
    return parentViewController;
}

+ (UIViewController *) getVisibleViewControllerFrom:(UIViewController *) vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [UIWindow getVisibleViewControllerFrom:[((UINavigationController *) vc) visibleViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [UIWindow getVisibleViewControllerFrom:[((UITabBarController *) vc) selectedViewController]];
    } else {
        if (vc.presentedViewController) {
            return [UIWindow getVisibleViewControllerFrom:vc.presentedViewController];
        } else {
            return vc;
        }
    }
}

@end

#pragma mark -
@implementation NSArray (Costelique)

-(NSArray *)removeObjectsOfClass:(Class)cls {
    NSMutableArray *arr = [self mutableCopy];
    for (long i = arr.count; i--;) {
        if ([arr[i] isKindOfClass:cls]) {
            [arr removeObjectAtIndex:i];
        }
    }
    return [arr copy];
}

-(int) searchObjectEqual: (NSObject *) obj
{
    for(long i = self.count; i--;)
        if([self[i] isEqual: obj])
            return (int)i;
    return -1;
}

-(int) searchObjectNonEqual: (NSObject *) obj
{
    [self objectAtIndex:1];
    for(long i = self.count; i--;)
        if(![self[i] isEqual: obj])
            return (int)i;
    
    return -1;
}

-(id)randomObject
{
    return self.count ? self[arc4random_uniform((int)self.count)] : nil;
}

-(NSMutableArray *)randomizedArray
{
    if (!self.count)
        return [NSMutableArray new];
    
    NSMutableArray *arrNumbers = [NSMutableArray new];
    for (long i = self.count; i--;)
        [arrNumbers addObject:[NSNumber numberWithInteger:i]];
    
    NSMutableArray *arrRandomized = [NSMutableArray new];
    while (arrNumbers.count) {
        NSNumber *numb = [arrNumbers randomObject];
        id object = self[numb.integerValue];
        [arrRandomized addObject:object];
        [arrNumbers removeObject:numb];
    }
    return arrRandomized;
}

-(NSArray *)expandedArrayWithLength:(long)length
{
    if (!self.count)
        return @[];
    NSMutableArray *workingArray = [self mutableCopy];
    
    long last = workingArray.count - 1;
    for (long i = length; i--;)
    {
        id obj = workingArray[last];
        [workingArray insertObject:obj atIndex:0];
    }
    
    last = length;
    for (long i = length; i--;)
    {
        id obj = workingArray[last];
        [workingArray addObject:obj];
        last++;
    }
    
    return [NSArray arrayWithArray:workingArray];
}

-(long)findNearestIndexOfObject:(id)obj fromPosition:(long)index
{
    long count = self.count;
    
    if (index > count - 1) {
        index = count - 1;
    }
    else if (index < 0) {
        index = 0;
    }
    
    long newIndex = -1;
    long delta = 0;
    
    while (delta < count) {
        long ind1 = index + delta;
        if (ind1 < count && obj == self[ind1]){
            newIndex = ind1;
            break;
        }
        
        delta++;
        
        long ind2 = index - delta;
        if (ind2 >= 0 && obj == self[ind2]){
            newIndex = ind2;
            break;
        }
    }
    
    return newIndex;
}

@end


@implementation UIFont (Costelique)

-(instancetype)fontForString:(NSString *)str fitInSize:(CGSize)textSize
{
    if (textSize.width <= 0 || textSize.height <= 0)
        return self;
    if (str.length < 1)
        return self;
    float fontSize = 20;
    CGSize sz = [str sizeWithFont:[self fontWithSize:fontSize]];
    fontSize *= textSize.width/sizeFit(sz, textSize).width;
    sz = [str sizeWithFont:[self fontWithSize:fontSize]];
    
    
    long iterations = 0;
    while (sz.width < textSize.width && sz.height < textSize.height) {
        fontSize *= 1.11;
        sz = [str sizeWithFont:[self fontWithSize:fontSize]];
        iterations++;
    }
    
    while (sz.width > textSize.width || sz.height > textSize.height) {
        fontSize *= .97;
        sz = [str sizeWithFont:[self fontWithSize:fontSize]];
        iterations++;
    }
    return [self fontWithSize:fontSize];
}
@end
@implementation NSString (Costelique)
-(NSArray <NSString *> *)getWordsArray {
    return [self componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
}

-(NSMutableArray <NSString *> *)getLinesArray {
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"\n"];
    NSMutableArray <NSString *> *lines = [[self componentsSeparatedByCharactersInSet: set] mutableCopy];
    for (long i = lines.count; i--;) {
        if (lines[i].length < 1) {
            [lines removeObjectAtIndex:i];
        }
    }
    return lines;
}

-(CGSize)sizeWithFont:(UIFont *)font {
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:self attributes:@{NSFontAttributeName : font}];
    return str.size;
}

-(NSAttributedString *)attributedCopyWithFont:(UIFont *)font toFitInSize:(CGSize)sz {
    UIFont *fnt = [font fontForString:self fitInSize:sz];
    return [[NSAttributedString alloc] initWithString:self attributes: @{NSFontAttributeName : fnt}];
}

-(NSString *)stringByRemoveingEmptyLines
{
    NSMutableArray *arr = [[self getLinesArray] mutableCopy];
    
    for (long i = arr.count; i--;) {
        NSString *line = arr[i];
        line = [line stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (!line.length) {
            [arr removeObjectAtIndex:i];
        }
    }
    
    NSString *str = @"";
    for (NSString *line in arr)
        str = [str stringByAppendingString:[NSString stringWithFormat:@"%@\n",line]];
    str = [str substringWithRange:NSMakeRange(0, str.length - 1)];
    return str;
}

-(long)numberOfLines
{
    long lines = 1;
    const char *ch = self.UTF8String;
    for (long i = self.length; i--;) {
        if (ch[i] == '\n') {
            lines++;
        }
    }
    return lines;
}

-(NSRange)rangeOfLineAtIndex:(long)index
{
    NSRange range = NSMakeRange(0, 0);
    long line = 0;
    
    for (long i = 0; i < self.length; i++) {
        if (i == self.length - 1) {
            range.length = i + 1 - range.location;
            break;
        }
        
        if ([self characterAtIndex:i] == '\n') {
            line++;
            if (line == index) {
                range.location = i + 1;
            }
            else if (line == index + 1) {
                range.length = i - range.location;
                break;
            }
        }
    }
    return range;
}

-(NSString *)autoWrap
{
    NSString *str = [self copy];
    NSArray <NSString *> *words = [str getWordsArray];
    NSArray <NSString *> *allLines = [str getLinesArray];
    NSMutableArray <NSString *> *lines = [[NSMutableArray alloc] init];
    
    long linesCount = roundf((float)(str.length)/(float)(20.));
    if (linesCount > 5)
        linesCount = 5;
    
    
    UIFont *font = [UIFont systemFontOfSize:20];
    float allWidth = 0;
    for (NSString *word in words)
        allWidth += [word sizeWithFont:font].width;
    float lineWidth = allWidth/linesCount;
    for (long i = 0; i < allLines.count; i++)
    {
        NSString *line = allLines[i];
        NSArray <NSString *> *words = [line getWordsArray];
        if ([line sizeWithFont:font].width > lineWidth && words.count > 1){
            NSString *currentString;
            for (long i = 0; i < words.count; i++) {
                
                if (!currentString) {
                    currentString = words[i];
                }
                
                if (i == words.count - 1) {
                    if (currentString) {
                        [lines addObject:currentString];
                    }
                    continue;
                }
                
                NSString *nextWord = words[i+1];
                NSString *newString = [NSString stringWithFormat:@"%@ %@",currentString,nextWord];
                if (fabs([currentString sizeWithFont:font].width - lineWidth) > fabs([newString sizeWithFont:font].width - lineWidth)) {
                    currentString = newString;
                }
                else {
                    [lines addObject:currentString];
                    currentString = nil;
                }
            }
        }
        else {
            [lines addObject:line];
        }
    }
    
    str = @"";
    
    for (long i = 0; i < lines.count; i++) {
        if (i != lines.count - 1) {
            str = [str stringByAppendingString:lines[i]];
        }
    }
    return str;
}

-(NSString *)onlyNumbers {
    NSMutableString *result = [[NSMutableString alloc] initWithCapacity:13];
    const char *chs = self.UTF8String;
    long l = strlen(chs);
    for (long i = 0; i < l; i++) {
        char c = chs[i];
        if ((c >= '0') && (c <= '9')) {
            [result appendString:[NSString stringWithFormat:@"%c",c]];
        }
    }
    return [result copy];
}

-(NSDictionary *)parceJSONWithEncoding:(NSStringEncoding)encoding {
    NSError *jsonError;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData: [self dataUsingEncoding: encoding]
                                                         options: NSJSONReadingMutableContainers
                                                           error: &jsonError];
    if (jsonError) {
        AKLog(@"JSON parceing error: %@", jsonError);
        return nil;
    }
    return json;
}

@end

@implementation UINavigationController (Costelique)
- (UIStatusBarStyle)preferredStatusBarStyle {
    UIViewController *contr = [self topViewController];
    if (contr) {
        SEL sel = @selector(preferredStatusBarStyle);
        IMP imp1 = method_getImplementation(class_getInstanceMethod([contr class], sel));
        IMP imp2 = method_getImplementation(class_getInstanceMethod([contr superclass], sel));
        if (imp1 != imp2) {
            return [contr preferredStatusBarStyle];
        }
    }
    return ak_UIStatusBarStyle_getPlistValue();
}

-(BOOL)disableAutorotation {
    return YES;
}

-(BOOL)shouldAutorotate
{
    if ([self.visibleViewController respondsToSelector:@selector(disableAutorotation)]) {
        return ![(id)self.visibleViewController disableAutorotation];
    }
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    NSUInteger supportedOrientations;
    if ([[self topViewController] respondsToSelector:@selector(supportedInterfaceOrientations)]) {
        supportedOrientations = [[self topViewController] supportedInterfaceOrientations];
    }
    else {
        supportedOrientations = [super supportedInterfaceOrientations];
    }
    return supportedOrientations;
}
@end


@implementation UICollectionView (Costelique)
-(void)makeSwipableOnlyLeftToRight {
    [self setScrollEnabled:NO];
    
    UISwipeGestureRecognizer *recLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(ak_swipe:)];
    recLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer: recLeft];
    
    UISwipeGestureRecognizer *recRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(ak_swipe:)];
    recRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer: recRight];
}

-(void)ak_swipe:(UISwipeGestureRecognizer *)recognizer {
    NSIndexPath *path = [self getIndexPathOfCenterCell];
    NSInteger item = path.item;

    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        if (item < [self.dataSource collectionView:self numberOfItemsInSection:path.section] - 1) {
            item += 1;
            NSIndexPath *newPath = [NSIndexPath indexPathForItem:item inSection:path.section];
            [UIView animateWithDuration:0.1 animations:^{
                [self scrollToItemAtIndexPath:newPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            }];
            if ([self.delegate respondsToSelector:@selector(collectionView:userDidSwipeToCellAtIndexPath:)]) {
                [(id)self.delegate collectionView:self userDidSwipeToCellAtIndexPath:newPath];
            }
        }
    } else if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        if (item > 0) {
            item -= 1;
            NSIndexPath *newPath = [NSIndexPath indexPathForItem:item inSection:path.section];
            [UIView animateWithDuration:0.1 animations:^{
                [self scrollToItemAtIndexPath:newPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            }];
            if ([self.delegate respondsToSelector:@selector(collectionView:userDidSwipeToCellAtIndexPath:)]) {
                [(id)self.delegate collectionView:self userDidSwipeToCellAtIndexPath:newPath];
            }
        }
    }

}

-(NSIndexPath *)getIndexPathOfCenterCell {
    float center = self.bounds.size.width/2. + self.contentOffset.x;
    
    NSIndexPath *nearest = nil;
    float minDistance = MAXFLOAT;
    for (NSIndexPath *index in [self indexPathsForVisibleItems]) {
        CGRect cellRect = [self layoutAttributesForItemAtIndexPath:index].frame;
        float distance = fabs(cellRect.origin.x + cellRect.size.width/2. - center);
        if (distance < minDistance) {
            minDistance = distance;
            nearest = index;
        }
    }
    return nearest;
}

@end

@implementation UINavigationBar (Costelique)

- (void)setBottomBorderColor:(UIColor *)color height:(CGFloat)height {
    CGFloat w = MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    CGRect bottomBorderRect = CGRectMake(0, CGRectGetHeight(self.frame), w  , height);
    UIView *bottomBorder = [[UIView alloc] initWithFrame:bottomBorderRect];
    [bottomBorder setBackgroundColor:color];
    [self addSubview:bottomBorder];
}
@end

@implementation UIButton (Costelique)

-(NSString *)customFont{
    return self.titleLabel.font.fontName;
}

-(void)setCustomFont:(NSString *)customFont {
    if (customFont.length) {
        UIFont *font = [UIFont fontWithName:customFont size:self.titleLabel.font.pointSize];
        if (font) {
            self.titleLabel.font = font;
        }
    }
}
-(void)autoadjustFontSizeWithInsets:(UIEdgeInsets)insets {
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.titleLabel.adjustsFontForContentSizeCategory = YES;
    self.titleEdgeInsets = insets;
}
-(void)autoadjustFontSize {
    [self autoadjustFontSizeWithInsets:UIEdgeInsetsMake(3, 6, 3, 6)];
}
@end

@implementation NSObject (blackMagic)
void printClassMethods(Class c) {
    unsigned int count;
    NSLog(@"\n\n  Methods %@",c);
    Method *m = class_copyMethodList(c, &count);
    for (NSUInteger i=0; i<count; i++) {
        Method met = m[i];
        NSLog(@"%@ %s", NSStringFromSelector(method_getName(met)), method_getTypeEncoding(met));
    }
    NSLog(@"\n\n");
}
void printClassIvars(Class c) {
    unsigned int count;
    NSLog(@"\n\n  Ivars %@",c);
    Ivar *vars = class_copyIvarList(c, &count);
    for (NSUInteger i=0; i<count; i++) {
        Ivar var = vars[i];
        NSLog(@"%s %s", ivar_getName(var), ivar_getTypeEncoding(var));
    }
    NSLog(@"\n\n");
}

-(void)overrideSelector:(SEL)sel withBlock:(id)block {
    if ([self respondsToSelector:sel]) {
        const char *rootClassIvarName = "Costelique_BlackMagic_rootClass";
        const char *subclassCounterIvarName = "Costelique_BlackMagic_subclassCounter";

        Class class = [self class];
        Class rootClass = object_getIvar(self, class_getInstanceVariable(class, rootClassIvarName));

        if (!rootClass) {
            int z = ((int)pow(3, 6) ^ 2 << 5);
            NSString *scName = [NSString stringWithFormat:@"%s_$%d",class_getName(class),++z];
            class = objc_allocateClassPair([self class], [scName UTF8String], 0);
            class_addIvar(class, rootClassIvarName, sizeof(Class), log2(sizeof(class)), @encode(typeof(class)));
            class_addIvar(class, subclassCounterIvarName, sizeof(int), log2(_Alignof(int)), @encode(int));
            objc_registerClassPair(class);
            rootClass = [self class];
            object_setClass(self, class);
            object_setIvar(self, class_getInstanceVariable(class, rootClassIvarName), rootClass);
            ((void (*)(id, Ivar, int))object_setIvar)(self, class_getInstanceVariable(class, subclassCounterIvarName), z);
        } else {
            ptrdiff_t offset = ivar_getOffset(class_getInstanceVariable([self class], subclassCounterIvarName));
            unsigned char* bytes = (unsigned char *)(__bridge void*)self;
            int *counter = ((int *)(bytes+offset));
            NSString *subclassName = [NSString stringWithFormat:@"%s_$%d",class_getName(rootClass),++counter[0]];
            class = objc_allocateClassPair([self class], [subclassName UTF8String], 0);
            objc_registerClassPair(class);
            object_setClass(self, class);
        }
    }
    class_addMethod([self class], sel, imp_implementationWithBlock(block), @encode(typeof(block)));
}

+(void)overrideSelector:(SEL)sel withBlock:(id)block {
    if (![self instancesRespondToSelector:sel]) {
        class_addMethod([self class], sel, imp_implementationWithBlock(block), @encode(typeof(block)));
    } else {
        class_addMethod([self class], sel, imp_implementationWithBlock(block), @encode(typeof(block)));
    }
}

-(SEL)makeSelector:(NSString *)name withBlock:(id)block {
    return selector(self, (char*)[name UTF8String], block);
}

SEL selector(id obj, char* name, id block) {
    SEL selector = sel_getUid(name);
    if (class_respondsToSelector([(NSObject*)obj class], selector))
        return selector;
    IMP impFunct = imp_implementationWithBlock(block);
    class_addMethod([(NSObject*)obj class], selector, (IMP)impFunct, @encode(typeof(block)));
    return selector;
}

@end


