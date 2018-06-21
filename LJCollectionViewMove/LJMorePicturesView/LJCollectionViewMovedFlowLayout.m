//
//  LJCollectionViewMovedFlowLayout.m
//  LJCollectionViewMove
//
//  Created by 刘俊杰 on 16/9/6.
//  Copyright © 2016年 不囧. All rights reserved.
//

#import "LJCollectionViewMovedFlowLayout.h"
#import <objc/runtime.h>

@interface LJCollectionViewMovedFlowLayout ()

@property (strong, nonatomic) NSIndexPath *selectedItemIndexPath;

@end

@implementation LJCollectionViewMovedFlowLayout

#pragma mark - Private Methods

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    if (layoutAttributes.indexPath == self.selectedItemIndexPath) {
        layoutAttributes.hidden = YES;
    }
}

#pragma mark - UICollectionViewLayout overridden methods

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *layoutAttributesForElementsInRect = [super layoutAttributesForElementsInRect:rect];
    
    for (UICollectionViewLayoutAttributes *layoutAttributes in layoutAttributesForElementsInRect) {
        switch (layoutAttributes.representedElementCategory) {
            case UICollectionElementCategoryCell: {
                [self applyLayoutAttributes:layoutAttributes];
            } break;
            default: {
                // Do nothing...
            } break;
        }
    }
    
    return layoutAttributesForElementsInRect;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *layoutAttributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    
    switch (layoutAttributes.representedElementCategory) {
        case UICollectionElementCategoryCell: {
            [self applyLayoutAttributes:layoutAttributes];
        } break;
        default: {
            // Do nothing...
        } break;
    }
    
    return layoutAttributes;
}

@end

CG_INLINE CGPoint
LJ_CGPointAdd(CGPoint point1, CGPoint point2) {
    return CGPointMake(point1.x + point2.x, point1.y + point2.y);
}

CG_INLINE CGSize
LJ_CGSizeScale(CGSize size, CGFloat scale) {
    return CGSizeMake(size.width * scale, size.height * scale);
}

typedef NS_ENUM(NSUInteger, LJScrollingDirection) {
    LJScrollingDirectionUnknown = 0,
    LJScrollingDirectionUp,
    LJScrollingDirectionDown,
    LJScrollingDirectionLeft,
    LJScrollingDirectionRight
};

@interface UICollectionView ()

@property (strong, nonatomic) UIView *moveView;

@property (strong, nonatomic) UIView *deleteView;

@property (strong, nonatomic) UILabel *deleteLabel;

@property (strong, nonatomic) NSIndexPath *selectedItemIndexPath;

@property (weak  , nonatomic) id<LJCollectionViewMovedFlowLayoutDataSource> lj_dataSource;

@end

@implementation UICollectionView (LJReordering)

- (BOOL)lj_beginInteractiveMovementForItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedItemIndexPath = indexPath;
    if ([[self lj_dataSource] respondsToSelector:@selector(collectionView:canMoveItemAtIndexPath:)] &&
        ![[self lj_dataSource] collectionView:self canMoveItemAtIndexPath:indexPath]) {
        return NO;
    }
    
    UICollectionViewCell *collectionViewCell = [self cellForItemAtIndexPath:indexPath];
    
    [self setupUIWithCell:collectionViewCell];
    
    [self.collectionViewLayout invalidateLayout];
    return YES;
}
- (void)lj_updateInteractiveMovementTargetPosition:(CGPoint)targetPosition {
    self.moveView.center = targetPosition;
    CGSize cellMovedSize = LJ_CGSizeScale(self.moveView.bounds.size, 0.3);
    
    [self updateLayoutMovementTargetPosition:targetPosition];
    switch ([self lj_collectionViewLayout].scrollDirection) {
        case UICollectionViewScrollDirectionVertical: {
            if (targetPosition.y - cellMovedSize.height < CGRectGetMinY(self.bounds)) {
                [self setupScrollBeyondScreenInDirection:LJScrollingDirectionUp];
            } else if (targetPosition.y + cellMovedSize.height > CGRectGetMaxY(self.bounds)) {
                [self setupScrollBeyondScreenInDirection:LJScrollingDirectionDown];
            }
        } break;
        case UICollectionViewScrollDirectionHorizontal: {
            if (targetPosition.x - cellMovedSize.width < CGRectGetMinX(self.bounds)) {
                [self setupScrollBeyondScreenInDirection:LJScrollingDirectionLeft];
            } else if (targetPosition.x + cellMovedSize.width > CGRectGetMaxX(self.bounds)) {
                [self setupScrollBeyondScreenInDirection:LJScrollingDirectionRight];
            }
        } break;
    }
    
}
- (void)lj_endInteractiveMovement {
    if (self.selectedItemIndexPath) {
        [self.moveView removeFromSuperview];
        self.moveView = nil;
        self.selectedItemIndexPath = nil;
        [self.collectionViewLayout invalidateLayout];
    }
}
- (void)lj_cancelInteractiveMovement {
    [self lj_endInteractiveMovement];
}

#pragma mark - Private Methods

- (void)updateLayoutMovementTargetPosition:(CGPoint)targetPosition {
    NSIndexPath *previousIndexPath = self.selectedItemIndexPath;
    NSIndexPath *newIndexPath = [self indexPathForItemAtPoint:targetPosition];
    if (!newIndexPath || !previousIndexPath || newIndexPath == previousIndexPath) {
        return;
    }
    
    if ([[self lj_dataSource] respondsToSelector:@selector(collectionView:canMoveItemAtIndexPath:toIndexPath:)] &&
        ![[self lj_dataSource] collectionView:self canMoveItemAtIndexPath:previousIndexPath toIndexPath:newIndexPath]) {
        return;
    }
    if ([[self lj_dataSource] respondsToSelector:@selector(collectionView:canMoveItemAtIndexPath:)] &&
        ![[self lj_dataSource] collectionView:self canMoveItemAtIndexPath:previousIndexPath]) {
        return;
    }
    
    self.selectedItemIndexPath = newIndexPath;
    
    if ([[self lj_dataSource] respondsToSelector:@selector(collectionView:willMoveItemAtIndexPath:toIndexPath:)]) {
        [[self lj_dataSource] collectionView:self willMoveItemAtIndexPath:previousIndexPath toIndexPath:newIndexPath];
    }
    
    __weak typeof(self) weakSelf = self;
    [self performBatchUpdates:^{
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf) {
//            [strongSelf deleteItemsAtIndexPaths:@[previousIndexPath]];
//            [strongSelf insertItemsAtIndexPaths:@[newIndexPath]];
            [strongSelf moveItemAtIndexPath:previousIndexPath toIndexPath:newIndexPath];
        }
    } completion:^(BOOL finished) {
        __strong typeof(self) strongSelf = weakSelf;
        if ([[strongSelf lj_dataSource] respondsToSelector:@selector(collectionView:didMoveItemAtIndexPath:toIndexPath:)]) {
            [[strongSelf lj_dataSource] collectionView:strongSelf didMoveItemAtIndexPath:previousIndexPath toIndexPath:newIndexPath];
        }
        
        
    }];
}

//设置当滚出屏幕时，移动屏幕
- (void)setupScrollBeyondScreenInDirection:(LJScrollingDirection)direction {
    
    CGSize frameSize = self.bounds.size;
    CGSize contentSize = self.contentSize;
    CGPoint contentOffset = self.contentOffset;
    UIEdgeInsets contentInset = self.contentInset;
    
    CGPoint translation = CGPointZero;
    CGFloat distance = 8;//每次移动的距离
    switch(direction) {
        case LJScrollingDirectionUp: {
            CGFloat minY = - contentInset.top;
            if (contentOffset.y <= minY) return;
            
            translation = CGPointMake(0.0f, - distance);
        } break;
        case LJScrollingDirectionDown: {
            CGFloat maxY = MAX(contentSize.height, frameSize.height) - frameSize.height + contentInset.bottom;
            if (contentOffset.y >= maxY) return;
            
            translation = CGPointMake(0.0f, distance);
        } break;
        case LJScrollingDirectionLeft: {
            CGFloat minX = - contentInset.left;
            if (contentOffset.x <= minX) return;
            
            translation = CGPointMake(- distance, 0.0f);
        } break;
        case LJScrollingDirectionRight: {
            CGFloat maxX = MAX(contentSize.width, frameSize.width) - frameSize.width + contentInset.right;
            if (contentOffset.x >= maxX) return;
            
            translation = CGPointMake(distance, 0.0f);
        } break;
        case LJScrollingDirectionUnknown: break;
    }
    self.moveView.center = LJ_CGPointAdd(self.moveView.center, translation);
    self.contentOffset = LJ_CGPointAdd(contentOffset, translation);
}

- (void)injected
{
    [self.deleteView removeFromSuperview];
    [self setupUI];
    
}

- (void)setupUI {
    CGSize size = [UIScreen mainScreen].bounds.size;
    CGRect deleteFrame = CGRectMake(0, size.height - 60, size.width, 60);
    UIView *deleteView = [[UIView alloc] initWithFrame:deleteFrame];
    deleteView.hidden = YES;
    deleteView.backgroundColor = [UIColor colorWithRed:250 green:52 blue:70 alpha:0.8];
    [self.window addSubview:deleteView];
    
    UIImageView *deleImgView = [[UIImageView alloc] initWithFrame:CGRectMake((size.width - 30) * 0.5, 10, 30, 30)];
    deleImgView.image = [UIImage imageNamed:@"move_bottom_delete"];
    [deleImgView addSubview:deleImgView];
    
    UILabel *deleteLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10 + 30 + 5, size.width, 20)];
    deleteLabel.textAlignment = NSTextAlignmentCenter;
    deleteLabel.text = @"推动到此处删除";
    [deleteView addSubview:deleteLabel];
    self.deleteLabel = deleteLabel;
    self.deleteView = deleImgView;
}


- (void)setupUIWithCell:(UICollectionViewCell *)cell {
    
    self.moveView = [cell snapshotViewAfterScreenUpdates:NO];
    self.moveView.frame = cell.frame;
    self.moveView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //    [self addSubview:self.moveView];
    [self.window addSubview:self.moveView];
    
    [self setupUI];
}

#pragma mark - Getters And Setters

- (id<LJCollectionViewMovedFlowLayoutDataSource>)lj_dataSource {
    return (id<LJCollectionViewMovedFlowLayoutDataSource>)self.dataSource;
}

- (void)setMoveView:(UIView *)moveView {
    objc_setAssociatedObject(self, "LJReordering_moveView", moveView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)moveView {
    return objc_getAssociatedObject(self, "LJReordering_moveView");
}

- (void)setDeleteView:(UIView *)deleteView {
    objc_setAssociatedObject(self, "LJReordering_deleteView", deleteView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)deleteView {
    return objc_getAssociatedObject(self, "LJReordering_deleteView");
}

- (void)setSelectedItemIndexPath:(NSIndexPath *)selectedItemIndexPath {
   [self lj_collectionViewLayout].selectedItemIndexPath = selectedItemIndexPath;

    objc_setAssociatedObject(self, "LJReordering_selectedItemIndexPath", selectedItemIndexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSIndexPath *)selectedItemIndexPath {
    return objc_getAssociatedObject(self, "LJReordering_selectedItemIndexPath");
}

- (LJCollectionViewMovedFlowLayout *)lj_collectionViewLayout {
    if ([self.collectionViewLayout isKindOfClass:[LJCollectionViewMovedFlowLayout class]]) {
        return (LJCollectionViewMovedFlowLayout *)self.collectionViewLayout;
    } else {
        NSAssert(NO, @"collectionView 实例化 collectionViewLayout 必须是 LJReorderingCollectionViewFlowLayout");
        return nil;
    }
}

@end

