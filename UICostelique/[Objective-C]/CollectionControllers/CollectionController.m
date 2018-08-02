//
//  CollectionController.m
//  ScreenStitch
//
//  Created by Олег on 11.05.2018.
//  Copyright © 2018 Олег. All rights reserved.
//

#import "CollectionController.h"

@interface CollectionController() 
@property NSArray <NSIndexPath *> *indexPathsForSelectedItems;
@end

@implementation CollectionController
-(instancetype)init {
    if (self = [super init]) {
        _cellIdentifier = @"cell";
        _cellsInRow = 3;
        _aspectRatio = UIScreen.mainScreen.bounds.size.height / UIScreen.mainScreen.bounds.size.width;
        _unselectable = false;
    }
    return self;
}

-(void)setCollection:(UICollectionView *)collection {
    collection.delegate = self;
    collection.dataSource = self;
    _collection = collection;
    [collection reloadData];
}

-(void)setRepresentedArray:(NSArray *)representedArray {
    _representedArray = representedArray;
    [_collection reloadData];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)]) {
        return [self.delegate collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath];
    }
    
    if ([collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]]) {
        UICollectionViewFlowLayout *layout = (id)collectionViewLayout;
        CGFloat spacing = layout.minimumInteritemSpacing;
        CGFloat count = self.cellsInRow;
        CGFloat width = (self.collection.bounds.size.width - spacing * (count - 1))/count;
        CGFloat height = width * self.aspectRatio;
        return CGSizeMake(width, height);
    }
    return CGSizeMake(100, 100);
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    self.indexPathsForSelectedItems = nil;
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.representedArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *dequeuedCell = [collectionView dequeueReusableCellWithReuseIdentifier:_cellIdentifier forIndexPath:indexPath];
    if ([dequeuedCell conformsToProtocol: @protocol(CollectionControllerCell)]) {
        UICollectionViewCell<CollectionControllerCell> *cell = (id)dequeuedCell;
        [cell setSelection:[collectionView.indexPathsForSelectedItems containsObject:indexPath]];
        [cell setRepresentedObject: self.representedArray[indexPath.item]];
        return cell;
    }
    return dequeuedCell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.unselectable && [self.indexPathsForSelectedItems containsObject:indexPath]) {
        [self.collection deselectItemAtIndexPath:indexPath animated:false];
        [self collectionView:collectionView didDeselectItemAtIndexPath: indexPath];
        return;
    }
    UICollectionViewCell *collectionCell = [collectionView cellForItemAtIndexPath:indexPath];
    if ([collectionCell conformsToProtocol:@protocol(CollectionControllerCell)]) {
        UICollectionViewCell<CollectionControllerCell> *cell = (id)collectionCell;
        [cell setSelection:true];
    }
    if ([self.delegate respondsToSelector:@selector(collectionView:didSelectItemAtIndexPath:)]) {
        [self.delegate collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    }
    self.indexPathsForSelectedItems = self.collection.indexPathsForSelectedItems;
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *collectionCell = [collectionView cellForItemAtIndexPath:indexPath];
    if ([collectionCell conformsToProtocol:@protocol(CollectionControllerCell)]) {
        UICollectionViewCell<CollectionControllerCell> *cell = (id)collectionCell;
        [cell setSelection:false];
    }
    if ([self.delegate respondsToSelector:@selector(collectionView:didDeselectItemAtIndexPath:)]) {
        [self.delegate collectionView:collectionView didDeselectItemAtIndexPath:indexPath];
    }
    self.indexPathsForSelectedItems = self.collection.indexPathsForSelectedItems;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector: @selector(scrollViewDidScroll:)]) {
        [self.delegate scrollViewDidScroll: scrollView];
    }

}
@end
