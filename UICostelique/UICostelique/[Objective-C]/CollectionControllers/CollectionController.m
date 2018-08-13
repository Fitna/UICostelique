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
    _indexPathsForSelectedItems = nil;
    collection.delegate = self;
    collection.dataSource = self;
    _collection = collection;
    [collection reloadData];
}

-(void)setRepresentedArray:(NSArray *)representedArray {
    _indexPathsForSelectedItems = nil;
    _representedArray = representedArray;
    [_collection reloadData];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([_delegate respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)]) {
        return [_delegate collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath];
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
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _representedArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *dequeuedCell = [collectionView dequeueReusableCellWithReuseIdentifier:_cellIdentifier forIndexPath:indexPath];
    if ([dequeuedCell conformsToProtocol: @protocol(CollectionControllerCell)]) {
        UICollectionViewCell<CollectionControllerCell> *cell = (id)dequeuedCell;
        [cell setSelection:[collectionView.indexPathsForSelectedItems containsObject:indexPath]];
        [cell setRepresentedObject: _representedArray[indexPath.item]];
        return cell;
    }
    return dequeuedCell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_unselectable && [_indexPathsForSelectedItems containsObject:indexPath]) {
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
    _indexPathsForSelectedItems = self.collection.indexPathsForSelectedItems;
    if ([self.delegate respondsToSelector:@selector(collectionController:userDidSelectObject:)])  {
        [self.delegate collectionController:self userDidSelectObject:_representedArray[indexPath.item]];
    }
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *collectionCell = [collectionView cellForItemAtIndexPath:indexPath];
    if ([collectionCell conformsToProtocol:@protocol(CollectionControllerCell)]) {
        UICollectionViewCell<CollectionControllerCell> *cell = (id)collectionCell;
        [cell setSelection:false];
    }
    if ([_delegate respondsToSelector:@selector(collectionView:didDeselectItemAtIndexPath:)]) {
        [_delegate collectionView:collectionView didDeselectItemAtIndexPath:indexPath];
    }
    _indexPathsForSelectedItems = self.collection.indexPathsForSelectedItems;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([_delegate respondsToSelector: @selector(scrollViewDidScroll:)]) {
        [_delegate scrollViewDidScroll: scrollView];
    }

}

-(NSArray *)selectedObjects {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (NSIndexPath *path in _indexPathsForSelectedItems) {
        [arr addObject:_representedArray[path.item]];
    }
    return arr;
}

-(void)setSelectedObjects:(NSArray *)selectedObjects {
    for (id object in selectedObjects) {
        if ([_representedArray containsObject:object]) {
            NSUInteger index = [_representedArray indexOfObject:object];
            NSIndexPath *path = [NSIndexPath indexPathForItem:index inSection:0];
            [_collection selectItemAtIndexPath:path animated:false scrollPosition:
             UICollectionViewScrollPositionCenteredVertically | UICollectionViewScrollPositionCenteredHorizontally];
        }
    }
}

-(bool)allowsMultipleSelection {
    return [_collection allowsMultipleSelection];
}
-(void)setAllowsMultipleSelection:(bool)allowsMultipleSelection {
    [_collection setAllowsMultipleSelection: allowsMultipleSelection];
}
@end
