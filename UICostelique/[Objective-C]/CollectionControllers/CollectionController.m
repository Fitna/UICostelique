//
//  CollectionController.m
//  ScreenStitch
//
//  Created by Олег on 11.05.2018.
//  Copyright © 2018 Олег. All rights reserved.
//

#import "CollectionController.h"

@interface CollectionController() 

@end

@implementation CollectionController
-(instancetype)init {
    if (self = [super init]) {
        _cellsInRow = 3;
        _aspectRatio = UIScreen.mainScreen.bounds.size.height / UIScreen.mainScreen.bounds.size.width;
    }
    return self;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]]) {
        UICollectionViewFlowLayout *layout = (id)collectionViewLayout;
        CGFloat spacing = layout.minimumLineSpacing;
        CGFloat count = self.cellsInRow;
        CGFloat width = (self.collection.bounds.size.width - spacing * (count - 1))/count;
        CGFloat height = width * self.aspectRatio;
        return CGSizeMake(width, height);
    }
    return CGSizeMake(100, 100);
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.representedArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *dequeuedCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if ([dequeuedCell conformsToProtocol: @protocol(CollectionControllerCell)]) {
        UICollectionViewCell<CollectionControllerCell> *cell = (id)dequeuedCell;
        [cell setSelection:[collectionView.indexPathsForSelectedItems containsObject:indexPath]];
        [cell setRepresentedObject: self.representedArray[indexPath.item]];
        return cell;
    }
    return dequeuedCell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *collectionCell = [collectionView cellForItemAtIndexPath:indexPath];
    if ([collectionCell conformsToProtocol:@protocol(CollectionControllerCell)]) {
        UICollectionViewCell<CollectionControllerCell> *cell = (id)collectionCell;
        [cell setSelection:true];
    }
    [self.delegate collectionView:collectionView didSelectItemAtIndexPath:indexPath];
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *collectionCell = [collectionView cellForItemAtIndexPath:indexPath];
    if ([collectionCell conformsToProtocol:@protocol(CollectionControllerCell)]) {
        UICollectionViewCell<CollectionControllerCell> *cell = (id)collectionCell;
        [cell setSelection:false];
    }
    [self.delegate collectionView:collectionView didDeselectItemAtIndexPath:indexPath];
}

@end
