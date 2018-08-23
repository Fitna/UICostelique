//
//  CollectionController.h
//  ScreenStitch
//
//  Created by Олег on 11.05.2018.
//  Copyright © 2018 Олег. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

 //must be implemented for cells
@protocol CollectionControllerCell <NSObject>
-(void)setRepresentedObject:(id)object;
-(void)setSelection:(BOOL)selected;
@optional
@property NSDictionary <NSString *, id> *_Nullable additionalParameters;
@end


@class CollectionController;
@protocol CollectionControllerDelegate <UICollectionViewDelegateFlowLayout>
@optional
-(void)collectionController:(CollectionController*)contr userDidSelectObject:(id)object;
@end


@interface CollectionController : NSObject <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
@property (nonatomic, nullable) UICollectionView *collection;
@property (nonatomic, nullable) NSArray *representedArray;
@property (nonatomic, nullable, weak) id<CollectionControllerDelegate> delegate;

//dequeue identifier, default is "cell"
@property NSString *cellIdentifier;

//parameter for autolayout, used when no "...sizeForItemAtIndexPath:" method in delegate
@property (nullable, nonatomic) NSValue* cellSize; //CGSize

//2 parameters for autolayout, used when no cellSize value
@property NSUInteger cellsInRow; //, default == 4 (8 for iPad)
@property double aspectRatio; //Double, default == 1

 //if true, cells can be unselected. false by default
@property bool unselectable;

@property bool allowsRepeatSelection;
@property (nonatomic) NSArray *selectedObjects;
@property (nonatomic) bool allowsMultipleSelection;
-(__kindof UICollectionViewCell *__nullable)cellForItem:(id)item;

@property (nullable) NSDictionary <NSString *, id> *additionalParameters;
@end

NS_ASSUME_NONNULL_END
