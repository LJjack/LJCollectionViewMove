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

@interface LJPictureView ()<LJCollectionViewMovedFlowLayoutDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, LJPictureCellDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataList;

@property (nonatomic, strong) LJCollectionViewMovedFlowLayout *movedFlowLayout;

@property (nonatomic, assign) BOOL finishDeleteCell;

@end

@implementation LJPictureView

- (instancetype)init {
    if (self = [super init]) {
        [self setupDefaults];
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupDefaults];
        [self setupUI];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = [self cellWidth];
    if (width > 0) {
        self.collectionView.frame = self.bounds;
        self.movedFlowLayout.itemSize = CGSizeMake(width, width);
        self.movedFlowLayout.minimumLineSpacing = self.lineSpacing;
        self.movedFlowLayout.minimumInteritemSpacing = self.cellSpacing;
    }
}

//设置默认值
- (void)setupDefaults {
    self.perLineNum = 3;
    self.cellSpacing = 4;
    self.lineSpacing = 4;
    self.maxPictureNum = 9;
    self.hiddenAddView = YES;
    self.hiddenDeleteView = YES;
}

- (void)setupUI {
    [self addSubview:self.collectionView];
}

//cell的宽度
- (CGFloat)cellWidth {
    return floor((self.bounds.size.width - self.cellSpacing * (self.perLineNum - 1))/self.perLineNum);
}

//最后一个cell是否显示“+”
- (BOOL)showAddViewOnLastCell {
    return !self.hiddenAddView && self.pictureNames.count < self.maxPictureNum;
}

//cell是最后一个并且是"+"
- (BOOL)isAddViewLastCellIndexPath:(NSIndexPath *)indexPath {
    return [self showAddViewOnLastCell] && indexPath.row == self.dataList.count - 1;
}

//完成对cell的操作后，布局自身的高度
- (void)finishLayoutSelfHeight {
    CGFloat height = self.collectionView.contentSize.height;
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
    if (self && self.didFinishLayoutHeight) {
        self.didFinishLayoutHeight(height);
    }
}

#pragma mark - LJCollectionViewMovedFlowLayoutDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LJPictureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ViewController_cell" forIndexPath:indexPath];
    
    if ([self isAddViewLastCellIndexPath:indexPath]) {
        cell.cellImage = self.dataList[indexPath.section * indexPath.row + indexPath.row];
        cell.hiddenDeleteView = NO;
    } else {
        id imageData= self.dataList[indexPath.section * indexPath.row + indexPath.row];
        //选择类型
        if ([imageData isKindOfClass:[NSString class]]) {
            cell.cellImageName = imageData;
        } else if ([imageData isKindOfClass:[UIImage class]]) {
            cell.cellImage = imageData;
        } else if ([imageData isKindOfClass:[NSURL class]]) {
            if (self.placeholderImage) {
                cell.placeholderImage = self.placeholderImage;
            }
            cell.cellImageURL = imageData;
        }
        //删除视图
        cell.hiddenDeleteView = self.hiddenDeleteView;
        if (!self.hiddenDeleteView) {
            cell.delegate = self;
            if (self.deleteViewImage) {
                cell.deleteImage = self.deleteViewImage;
            }
        }
    }
    
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self isAddViewLastCellIndexPath:indexPath]) {
        return NO;
    }
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    
    if ([self isAddViewLastCellIndexPath:toIndexPath]) {
        return NO;
    }
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView willMoveItemAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    id tempData = self.dataList[fromIndexPath.item];
    [self.dataList removeObjectAtIndex:fromIndexPath.item];
    [self.dataList insertObject:tempData atIndex:toIndexPath.item];

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
    if ([self isAddViewLastCellIndexPath:indexPath]) {
        if ([self.delegate respondsToSelector:@selector(pictureViewDidSelectAddCell:)]) {
            [self.delegate pictureViewDidSelectAddCell:self];
        }
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(pictureView:collectionView:didSelectIndexPath:)]) {
        [self.delegate pictureView:self collectionView:collectionView didSelectIndexPath:indexPath];
    }
    
}

#pragma mark - LJPictureCellDelegate

- (void)pictureCellClickDeleteView:(LJPictureCell *)pictureCell {
    if (self.finishDeleteCell) return;
    self.finishDeleteCell = YES;
    
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:pictureCell];
    [self.dataList removeObjectAtIndex:indexPath.row];
    @autoreleasepool {
        if ([self showAddViewOnLastCell]) {
            NSMutableArray *tempMArray = [self.dataList.copy mutableCopy];
            [tempMArray removeLastObject];
            _pictureNames = tempMArray.copy;
        }
    }
    
    __weak typeof(self) weakSelf = self;
    [self.collectionView performBatchUpdates:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        if (finished) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf finishLayoutSelfHeight];
            strongSelf.finishDeleteCell = NO;
        }
    }];
    
}

#pragma mark - Setters

- (void)setPictureNames:(NSArray *)pictureNames {
    _pictureNames = pictureNames;
    self.dataList = pictureNames.mutableCopy;
    if ([self showAddViewOnLastCell]) {
        [self.dataList addObject:self.addViewImage];
    }
    [self.collectionView reloadData];
    
    //布局
    __weak typeof(self) weakSelf = self;
    [self.collectionView performBatchUpdates:nil completion:^(BOOL finished) {
        if (finished) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf finishLayoutSelfHeight];
        }
    }];
}

#pragma mark - Getters

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.movedFlowLayout];
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

- (LJCollectionViewMovedFlowLayout *)movedFlowLayout {
    if (!_movedFlowLayout) {
        _movedFlowLayout = [[LJCollectionViewMovedFlowLayout alloc] init];
    }
    return _movedFlowLayout;
}

@end
