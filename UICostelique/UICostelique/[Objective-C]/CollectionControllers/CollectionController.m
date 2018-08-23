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
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            _cellsInRow = 8;
        } else {
            _cellsInRow = 4;
        }
        _aspectRatio = 1;
        _unselectable = false;
        _indexPathsForSelectedItems = @[];
    }
    return self;
}

-(__kindof UICollectionViewCell *__nullable)cellForItem:(id)item {
    NSUInteger index = [_representedArray indexOfObject:item];
    if (index == NSNotFound) {
        return nil;
    }
    NSIndexPath *path = [NSIndexPath indexPathForItem:index inSection:0];
    return [_collection cellForItemAtIndexPath: path];
}

#pragma mark Collection delegate
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([_delegate respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)]) {
        return [_delegate collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath];
    }

    if (_cellSize != nil) {
        return [_cellSize CGSizeValue];
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

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [(id<CollectionControllerCell>)cell setSelection:[_indexPathsForSelectedItems containsObject:indexPath]];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *dequeuedCell = [collectionView dequeueReusableCellWithReuseIdentifier:_cellIdentifier forIndexPath:indexPath];
    if ([dequeuedCell conformsToProtocol: @protocol(CollectionControllerCell)]) {
        UICollectionViewCell<CollectionControllerCell> *cell = (id)dequeuedCell;
        if ([cell respondsToSelector:@selector(setAdditionalParameters:)]) {
            cell.additionalParameters = _additionalParameters;
        }
        [cell setRepresentedObject: _representedArray[indexPath.item]];
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
    if ([_indexPathsForSelectedItems containsObject:indexPath]) {
        if (_unselectable) {
            [self.collection deselectItemAtIndexPath:indexPath animated:false];
            [self collectionView:collectionView didDeselectItemAtIndexPath: indexPath];
        } else if (_allowsRepeatSelection) {
            if ([self.delegate respondsToSelector:@selector(collectionView:didSelectItemAtIndexPath:)]) {
                [self.delegate collectionView:collectionView didSelectItemAtIndexPath:indexPath];
            }
            if ([self.delegate respondsToSelector:@selector(collectionController:userDidSelectObject:)])  {
                [self.delegate collectionController:self userDidSelectObject:_representedArray[indexPath.item]];
            }
        }
        return;
    }
    if ([self.delegate respondsToSelector:@selector(collectionView:didSelectItemAtIndexPath:)]) {
        [self.delegate collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    }
    NSMutableArray *arr = [_indexPathsForSelectedItems mutableCopy];
    if (!self.allowsMultipleSelection) {
        [arr removeObject: indexPath];
        [self setSelection:false forCellsAtIndexPaths:arr];
    }
    _indexPathsForSelectedItems = collectionView.indexPathsForSelectedItems;
    if ([self.delegate respondsToSelector:@selector(collectionController:userDidSelectObject:)])  {
        [self.delegate collectionController:self userDidSelectObject:_representedArray[indexPath.item]];
    }
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self setSelection:false forCellsAtIndexPaths:@[indexPath]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setSelection:false forCellsAtIndexPaths:@[indexPath]];
    });
    if ([_delegate respondsToSelector:@selector(collectionView:didDeselectItemAtIndexPath:)]) {
        [_delegate collectionView:collectionView didDeselectItemAtIndexPath:indexPath];
    }
    _indexPathsForSelectedItems = collectionView.indexPathsForSelectedItems;
}

-(void)setSelection:(BOOL)selection forCellsAtIndexPaths:(NSArray<NSIndexPath *> *)paths {
    for (NSIndexPath *path in paths) {
        UICollectionViewCell *collectionCell = [_collection cellForItemAtIndexPath:path];
        if ([collectionCell conformsToProtocol:@protocol(CollectionControllerCell)]) {
            UICollectionViewCell<CollectionControllerCell> *cell = (id)collectionCell;
            [cell setSelection:selection];
        }
    }

}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([_delegate respondsToSelector: @selector(scrollViewDidScroll:)]) {
        [_delegate scrollViewDidScroll: scrollView];
    }
}

#pragma mark setters
-(void)setCellSize:(NSValue *)cellSize {
    CGSize oldSz = _cellSize ? _cellSize.CGSizeValue : CGSizeMake(-1000, -1000);
    CGSize newSz = cellSize ? cellSize.CGSizeValue : CGSizeMake(-100, -100);
    if (CGSizeEqualToSize(oldSz, newSz)) {
        return;
    }
    _cellSize = cellSize;
    [self.collection reloadData];
}

-(void)setCollection:(UICollectionView *)collection {
    _indexPathsForSelectedItems = @[];
    collection.delegate = self;
    collection.dataSource = self;
    _collection = collection;
    [collection reloadData];
}

-(void)setRepresentedArray:(NSArray *)representedArray {
    _indexPathsForSelectedItems = @[];
    _representedArray = representedArray;
    for (UICollectionViewCell <CollectionControllerCell>* cell in [_collection visibleCells]) {
        [cell setSelection: NO];
    }
    [_collection reloadData];
}

-(NSArray *)selectedObjects {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (NSIndexPath *path in _indexPathsForSelectedItems) {
        [arr addObject:_representedArray[path.item]];
    }
    return arr;
}

-(void)setSelectedObjects:(NSArray *)selectedObjects {
    NSMutableArray *newIndexPaths = [[NSMutableArray alloc] init];
    for (id object in selectedObjects) {
        if ([_representedArray containsObject:object]) {
            NSUInteger index = [_representedArray indexOfObject:object];
            NSIndexPath *path = [NSIndexPath indexPathForItem:index inSection:0];
            [newIndexPaths addObject: path];
        }
    }
    [self setSelection:true forCellsAtIndexPaths:newIndexPaths];

    NSMutableArray *removeSelectionPath = [_indexPathsForSelectedItems mutableCopy];
    for (NSIndexPath *path in newIndexPaths) {
        [removeSelectionPath removeObject:path];
    }
    [self setSelection:false forCellsAtIndexPaths:removeSelectionPath];
    _indexPathsForSelectedItems = newIndexPaths;
}

-(bool)allowsMultipleSelection {
    return [_collection allowsMultipleSelection];
}

-(void)setAllowsMultipleSelection:(bool)allowsMultipleSelection {
    [_collection setAllowsMultipleSelection: allowsMultipleSelection];
}
@end
