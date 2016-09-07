//
//  LJPictureView.m
//  LJCollectionViewMove
//
//  Created by 刘俊杰 on 16/9/7.
//  Copyright © 2016年 不囧. All rights reserved.
//

#import "LJPictureView.h"
#import "LJPictureCell.h"
#import "LJCollectionViewMovedFlowLayout.h"

static NSString * const addPictureName = @"icon-addpicture";

@interface LJPictureView ()<LJCollectionViewMovedFlowLayoutDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray<NSString *> *dataList;

@end

@implementation LJPictureView

- (instancetype)init {
    if (self = [super init]) {
        //设置默认值
        self.perLineNum = 3;
        self.cellSpacing = 4;
        self.lineSpacing = 4;
        self.maxPictureNum = 9;
        
        //添加视图
        [self addSubview:self.collectionView];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.collectionView.frame = self.bounds;
}

//<! cell的宽度
- (CGFloat)cellWidth {
    return floor((self.bounds.size.width - self.cellSpacing * (self.perLineNum - 1))/self.perLineNum);
}

#pragma mark - LJCollectionViewMovedFlowLayoutDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LJPictureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ViewController_cell" forIndexPath:indexPath];
    
    cell.imageName = self.dataList[indexPath.section * indexPath.row + indexPath.row];
    
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.pictureNames.count < self.maxPictureNum) {
        if (indexPath.row == self.dataList.count - 1) {
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    
    if (self.pictureNames.count < self.maxPictureNum) {
        if (toIndexPath.row == self.dataList.count - 1) {
            return NO;
        }
    }
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView willMoveItemAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    [self.dataList exchangeObjectAtIndex:fromIndexPath.item withObjectAtIndex:toIndexPath.item];
}

- (void)handleLongPresGestureRecognizer:(UIGestureRecognizer *)gesture {
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[gesture locationInView:gesture.view]];
            [self.collectionView lj_beginInteractiveMovementForItemAtIndexPath:indexPath];
        } break;
        case UIGestureRecognizerStateChanged: {
            [self.collectionView lj_updateInteractiveMovementTargetPosition:[gesture locationInView:gesture.view]];
        } break;
        case UIGestureRecognizerStateEnded: {
            [self.collectionView lj_endInteractiveMovement];
            
        } break;
        default: [self.collectionView lj_cancelInteractiveMovement];
            break;
    }
}

#pragma mark - UICollectionViewDelegate


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if (self.pictureNames.count < self.maxPictureNum) {
        if (row == self.dataList.count - 1) {
            if ([self.delegate respondsToSelector:@selector(pictureViewDidSelectAddCell:)]) {
                [self.delegate pictureViewDidSelectAddCell:self];
            }
            return;
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(pictureView:didSelectCellIndexPath:)]) {
        [self.delegate pictureView:self didSelectCellIndexPath:indexPath];
    }
    
}

#pragma mark ---- UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat cellWidth = [self cellWidth];
    return CGSizeMake(cellWidth, cellWidth);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return self.lineSpacing;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return self.cellSpacing;
}

#pragma mark - Setters

- (void)setPictureNames:(NSArray<NSString *> *)pictureNames {
    _pictureNames = pictureNames;
    self.dataList = pictureNames.mutableCopy;
    if (pictureNames.count < self.maxPictureNum) {
        [self.dataList addObject:addPictureName];
    }
    [self.collectionView reloadData];
    __weak typeof(self) weakSelf = self;
    [self.collectionView performBatchUpdates:nil completion:^(BOOL finished) {
        CGRect frame = weakSelf.frame;
        frame.size.height = weakSelf.collectionView.contentSize.height;
        weakSelf.frame = frame;
    }];
    
}

#pragma mark - Getters

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        LJCollectionViewMovedFlowLayout *flowLayout = [[LJCollectionViewMovedFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        _collectionView.backgroundColor = [UIColor colorWithRed:0.8568 green:0.8568 blue:0.8568 alpha:1.0];
        [_collectionView registerClass:[LJPictureCell class] forCellWithReuseIdentifier:@"ViewController_cell"];
        UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPresGestureRecognizer:)];
        // 兼容系统手势
        for (UIGestureRecognizer *gestureRecognizer in _collectionView.gestureRecognizers) {
            if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
                [gestureRecognizer requireGestureRecognizerToFail:longPressGestureRecognizer];
            }
        }
        
        [_collectionView addGestureRecognizer:longPressGestureRecognizer];
    }
    return _collectionView;
}

@end
