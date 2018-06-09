//
//  CollectionController.h
//  ScreenStitch
//
//  Created by Олег on 11.05.2018.
//  Copyright © 2018 Олег. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CollectionControllerCell <NSObject> //must be implemented for cells
-(void)setRepresentedObject:(id)object;
-(void)setSelection:(BOOL)selected;
@end


@interface CollectionController : NSObject <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
@property (weak) id<UICollectionViewDelegateFlowLayout> delegate;
@property NSInteger cellsInRow;
@property float aspectRatio;
@property IBOutlet UICollectionView *collection;
@property NSArray *representedArray;
@end
