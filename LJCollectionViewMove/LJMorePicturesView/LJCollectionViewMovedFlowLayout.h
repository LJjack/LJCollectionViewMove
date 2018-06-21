//
//  LJCollectionViewMovedFlowLayout.h
//  LJCollectionViewMove
//
//  Created by 刘俊杰 on 16/9/6.
//  Copyright © 2016年 不囧. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LJCollectionViewMovedFlowLayoutDataSource <UICollectionViewDataSource>

@optional

- (void)collectionView:(UICollectionView *)collectionView willMoveItemAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath;

- (void)collectionView:(UICollectionView *)collectionView didMoveItemAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath;

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath;

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath;

- (void)collectionView:(UICollectionView *)collectionView didDeleteWithIndexPath:(NSIndexPath *)indexPath;

@end

@interface LJCollectionViewMovedFlowLayout : UICollectionViewFlowLayout

@end

@interface UICollectionView (LJReordering)

// Support for reordering
- (BOOL)lj_beginInteractiveMovementForItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)lj_updateInteractiveMovementTargetPosition:(CGPoint)targetPosition;
- (void)lj_endInteractiveMovement;
- (void)lj_cancelInteractiveMovement;

@end


