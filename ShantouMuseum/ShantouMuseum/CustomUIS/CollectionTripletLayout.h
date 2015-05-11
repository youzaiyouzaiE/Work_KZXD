//
//  CollectionTripletLayout.h
//  ShantouMuseum
//
//  Created by jiahui on 15/5/7.
//  Copyright (c) 2015年 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#define RACollectionViewTripletLayoutStyleSquare CGSizeZero

@protocol CollectionViewDelegateTripletLayout <UICollectionViewDelegateFlowLayout>

@optional

- (CGSize)collectionView:(UICollectionView *)collectionView sizeForLargeItemsInSection:(NSInteger)section; //Default to automaticaly grow square !
- (UIEdgeInsets)insetsForCollectionView:(UICollectionView *)collectionView;
- (CGFloat)sectionSpacingForCollectionView:(UICollectionView *)collectionView;
- (CGFloat)minimumInteritemSpacingForCollectionView:(UICollectionView *)collectionView;
- (CGFloat)minimumLineSpacingForCollectionView:(UICollectionView *)collectionView;

@end

@interface CollectionTripletLayout : UICollectionViewFlowLayout
@property (nonatomic, assign) id<CollectionViewDelegateTripletLayout> delegate;
@property (nonatomic, assign, readonly) CGSize cellSize;

- (CGFloat)contentHeight;

@end
