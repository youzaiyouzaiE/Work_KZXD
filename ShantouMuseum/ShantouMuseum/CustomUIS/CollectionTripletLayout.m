//
//  CollectionTripletLayout.m
//  ShantouMuseum
//
//  Created by jiahui on 15/5/7.
//  Copyright (c) 2015年 Home. All rights reserved.
//

#import "CollectionTripletLayout.h"

@interface CollectionTripletLayout ()

@property (nonatomic, assign) NSInteger numberOfCells;
@property (nonatomic, assign) CGFloat numberOfLines;
@property (nonatomic, assign) CGFloat itemSpacing;///小组间两图距离
@property (nonatomic, assign) CGFloat lineSpacing;///每一小组之间的间隔
@property (nonatomic, assign) CGFloat sectionSpacing;
@property (nonatomic, assign) CGSize collectionViewSize;
@property (nonatomic, assign) UIEdgeInsets insets;//////每一组的间隔 组内内容到组边框的距离
@property (nonatomic, assign) CGRect oldRect;
//@property (nonatomic, strong) NSArray *oldArray;
@property (nonatomic, strong) NSMutableArray *cellSizeArray;


@end

@implementation CollectionTripletLayout

- (void)prepareLayout {
    [super prepareLayout];
    self.delegate = (id<CollectionViewDelegateTripletLayout>)self.collectionView.delegate;
    _collectionViewSize = self.collectionView.bounds.size;
    
    //some values
    _itemSpacing = 0;
    _lineSpacing = 0;
    _sectionSpacing = 0;
    _insets = UIEdgeInsetsMake(0, 0, 0, 0);
    if ([self.delegate respondsToSelector:@selector(minimumInteritemSpacingForCollectionView:)]) {
        _itemSpacing = [self.delegate minimumInteritemSpacingForCollectionView:self.collectionView];
    }
    if ([self.delegate respondsToSelector:@selector(minimumLineSpacingForCollectionView:)]) {
        _lineSpacing = [self.delegate minimumLineSpacingForCollectionView:self.collectionView];
    }
    if ([self.delegate respondsToSelector:@selector(sectionSpacingForCollectionView:)]) {
        _sectionSpacing = [self.delegate sectionSpacingForCollectionView:self.collectionView];
    }
    if ([self.delegate respondsToSelector:@selector(insetsForCollectionView:)]) {
        _insets = [self.delegate insetsForCollectionView:self.collectionView];
    }
}



- (CGSize)collectionViewContentSize//////222  返回collectionView的内容的尺寸
{
    CGSize contentSize = CGSizeMake(_collectionViewSize.width, 0);
    for (NSInteger i = 0; i < self.collectionView.numberOfSections; i++) {
        NSInteger numberOfLines = ceil((CGFloat)[self.collectionView numberOfItemsInSection:i] / 3.f);
        CGFloat lineHeight = numberOfLines * _lineSpacing - _lineSpacing;
        contentSize.height += lineHeight;
    }
    contentSize.height += _insets.top + _insets.bottom + _sectionSpacing * (self.collectionView.numberOfSections - 1);
//    NSInteger numberOfItemsInLastSection = [self.collectionView numberOfItemsInSection:self.collectionView.numberOfSections - 1];
    return contentSize;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    _oldRect = rect;
    NSMutableArray *attributesArray = [NSMutableArray array];
    for (NSInteger i = 0; i < self.collectionView.numberOfSections; i++) {
        NSInteger numberOfCellsInSection = [self.collectionView numberOfItemsInSection:i];
        for (NSInteger j = 0; j < numberOfCellsInSection; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
            if (CGRectIntersectsRect(rect, attributes.frame)) {
                [attributesArray addObject:attributes];
            }
        }
    }
//    _oldArray = attributesArray;
    return  attributesArray;
}

///每个cell 的布局  返回对应于indexPath的位置的cell的布局属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    //cellSize   320 - 20 /3
    CGFloat cellSideLength = ((_collectionViewSize.width - _insets.left - _insets.right) - 2.f * _itemSpacing) / 3.f;
    CGFloat cellSideHeight =((_collectionViewSize.height - _insets.top - _insets.bottom) - 2.f * _lineSpacing) /3.f;
    _cellSize = CGSizeMake(cellSideLength, cellSideHeight);
    
    if ([self.delegate respondsToSelector:@selector(collectionView:sizeForLargeItemsInSection:)]) {
        if (!CGSizeEqualToSize([self.delegate collectionView:self.collectionView sizeForLargeItemsInSection:indexPath.section], RACollectionViewTripletLayoutStyleSquare)) {
            _cellSize = [self.delegate collectionView:self.collectionView sizeForLargeItemsInSection:indexPath.section];
        }
    }
    if (!_cellSizeArray) {
        _cellSizeArray = [NSMutableArray array];
    }
    _cellSizeArray[indexPath.section] = [NSValue valueWithCGSize:_cellSize];
    //section height
    CGFloat sectionHeight = 0;
    for (NSInteger i = 0; i <= indexPath.section - 1; i++) {
        NSInteger cellsCount = [self.collectionView numberOfItemsInSection:i];
        CGFloat cellHeight = [_cellSizeArray[i] CGSizeValue].height;
        NSInteger lines = ceil((CGFloat)cellsCount / 3.f);
        sectionHeight += lines * (_lineSpacing + cellHeight) + _sectionSpacing;
    }
    if (sectionHeight > 0) {
        sectionHeight -= _lineSpacing;
    }
    
    NSInteger line = indexPath.item / 3;
    CGFloat lineSpaceForIndexPath = _lineSpacing * line;
    CGFloat lineOriginY = _cellSize.height * line + sectionHeight + lineSpaceForIndexPath + _insets.top;
    CGFloat cellOriginX = _insets.left + (indexPath.item % 3)* (_cellSize.width + _itemSpacing);
    attribute.frame =CGRectMake(cellOriginX, lineOriginY, _cellSize.width, _cellSize.height);
    
    return attribute;
}

- (CGFloat)contentHeight
{
    CGFloat contentHeight = 0;
    NSInteger numberOfSections = self.collectionView.numberOfSections;
    CGSize collectionViewSize = self.collectionView.bounds.size;
    
    UIEdgeInsets insets = UIEdgeInsetsZero;
    if ([self.delegate respondsToSelector:@selector(insetsForCollectionView:)]) {
        insets = [self.delegate insetsForCollectionView:self.collectionView];
    }
    CGFloat sectionSpacing = 0;
    if ([self.delegate respondsToSelector:@selector(sectionSpacingForCollectionView:)]) {
        sectionSpacing = [self.delegate sectionSpacingForCollectionView:self.collectionView];
    }
    CGFloat itemSpacing = 0;
    if ([self.delegate respondsToSelector:@selector(minimumInteritemSpacingForCollectionView:)]) {
        itemSpacing = [self.delegate minimumInteritemSpacingForCollectionView:self.collectionView];
    }
    CGFloat lineSpacing = 0;
    if ([self.delegate respondsToSelector:@selector(minimumLineSpacingForCollectionView:)]) {
        lineSpacing = [self.delegate minimumLineSpacingForCollectionView:self.collectionView];
    }
    
    contentHeight += insets.top + insets.bottom + sectionSpacing * (numberOfSections - 1);
    
    for (NSInteger i = 0; i < numberOfSections; i++) {
        NSInteger numberOfLines = ceil((CGFloat)[self.collectionView numberOfItemsInSection:i] / 3.f);
        
        CGFloat cellSideLength = (2.f * (collectionViewSize.width - insets.left - insets.right) - itemSpacing) / 3.f;
         CGFloat cellSideHeight =((_collectionViewSize.height - _insets.top - _insets.bottom) - 2.f * _lineSpacing) /3.f;
        
        CGSize largeCellSize = CGSizeMake(cellSideLength, cellSideHeight);
        if ([self.delegate respondsToSelector:@selector(collectionView:sizeForLargeItemsInSection:)]) {
            if (!CGSizeEqualToSize([self.delegate collectionView:self.collectionView sizeForLargeItemsInSection:i], RACollectionViewTripletLayoutStyleSquare)) {
                largeCellSize = [self.delegate collectionView:self.collectionView sizeForLargeItemsInSection:i];
            }
        }
        CGFloat cellHeight = largeCellSize.height;
        CGFloat lineHeight = numberOfLines * (cellHeight + lineSpacing) - lineSpacing;
        contentHeight += lineHeight;
    }
    
    return contentHeight;
}

@end

