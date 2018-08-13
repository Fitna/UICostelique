//
//  CollectionController.h
//  ScreenStitch
//
//  Created by Олег on 11.05.2018.
//  Copyright © 2018 Олег. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CollectionControllerCell <NSObject> //must be implemented for cells
-(void)setRepresentedObject:(id)object;
-(void)setSelection:(BOOL)selected;
@end

@class CollectionController;

@protocol CollectionControllerDelegate <UICollectionViewDelegateFlowLayout>
@optional
-(void)collectionController:(CollectionController*)contr userDidSelectObject:(id)object;
@end

@interface CollectionController : NSObject <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
@property (nonatomic, nullable, weak) id<CollectionControllerDelegate> delegate;
@property NSString *cellIdentifier; //default is "cell"
@property NSInteger cellsInRow;
@property float aspectRatio;
@property (nonatomic, nullable) IBOutlet UICollectionView *collection;
@property (nonatomic, nullable) NSArray *representedArray;
@property bool unselectable; //false by default
@property (nonatomic) NSArray *selectedObjects;
@property (nonatomic) bool allowsMultipleSelection;
-(instancetype)init;
@end

NS_ASSUME_NONNULL_END
