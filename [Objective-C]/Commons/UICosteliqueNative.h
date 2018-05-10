//
//  UICosteliqueNative.h
//  10kPhotoEditor
//
//  Created by Олег on 16.03.17.
//  Copyright © 2017 AKMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/SKProduct.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnullability-completeness"
@protocol MTLTexture;

@interface SKProduct (LocalizedPrice)
-(NSString *)localizedPrice;
@end

@interface UIColor (Costelique)
+ (UIColor *)colorWidthHexString:(NSString *)hexString;
+ (UIColor *)r:(float)r g:(float)g b:(float)b;
+ (instancetype)r:(float)r g:(float)g b:(float)b a:(float)a;
+ (instancetype)randomColor;
- (instancetype)randomizeWithDeflection:(float)f;
- (UIImage *)UIImage;
@end


@interface UILabel (Costelique)
@property (nonatomic) IBInspectable NSString *customFont;
- (float)expectedHeightWithWidth:(float)width;
-(void)updateTextSizeToFitWordsByWidth;
@end

@interface CALayer (Costelique)
-(void) removeAllSublayers;
-(void) pauseAnimations;
-(void) resumeAnimations;
@end

@interface UISlider(Costelique)
@property IBInspectable UIImage *thumbImage;
@end

@interface UIWindow (Costelique)
- (UIViewController *) topViewController;
@end

@interface UIViewController (Costelique)
-(__kindof UIResponder * _Nullable)firstResponder;
-(void)showAlert:(NSString *)title withMessage:(NSString *)text;
-(void)goToSettingsAlert:(NSString *)title withMessage:(NSString *)text completion:(bool (^)(void))completion;
@end

@interface NSArray<__covariant ObjectType> (Costelique)
-(int) searchObjectEqual: (NSObject *) obj;
-(int) searchObjectNonEqual: (NSObject *) obj;
-(ObjectType) randomObject;
-(NSMutableArray *)randomizedArray;
-(NSArray *)expandedArrayWithLength:(long)length;
-(long)findNearestIndexOfObject:(id)obj fromPosition:(long)index;
-(NSArray *)removeObjectsOfClass:(Class)cls;
@end

@interface UIFont (Costelique)
-(instancetype)fontForString:(NSString *)str fitInSize:(CGSize)sz;
@end

@interface NSString (Costelique)
@property (readonly) long numberOfLines;
-(NSAttributedString *)attributedCopyWithFont:(UIFont *)font toFitInSize:(CGSize)sz;
-(NSArray <NSString *> *)getWordsArray;
-(NSMutableArray <NSString *> *)getLinesArray;
-(CGSize)sizeWithFont:(UIFont *)font;
-(NSString *)stringByRemoveingEmptyLines;
-(NSString *)autoWrap;
-(NSRange)rangeOfLineAtIndex:(long)index;
-(NSString *)onlyNumbers;
-(NSDictionary *)parceJSONWithEncoding:(NSStringEncoding)encoding;
@end

@protocol SwipableCollectionDelegate
-(void)collectionView:(UICollectionView *)view userDidSwipeToCellAtIndexPath:(NSIndexPath *)path;
@end

@interface UICollectionView (Costelique)
-(NSIndexPath *)getIndexPathOfCenterCell;
-(void)makeSwipableOnlyLeftToRight;
@end

@interface UINavigationBar (Costelique)
- (void)setBottomBorderColor:(UIColor *)color height:(CGFloat)height;
@end

@interface UIButton (Costelique)
@property (nonatomic) IBInspectable NSString *customFont;
-(void)autoadjustFontSizeWithInsets:(UIEdgeInsets)insets;
-(void)autoadjustFontSize;
@end

#pragma clang diagnostic pop
