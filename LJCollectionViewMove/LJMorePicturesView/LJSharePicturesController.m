//
//  LJSharePicturesController.m
//  LJCollectionViewMove
//
//  Created by 刘俊杰 on 2018/4/26.
//  Copyright © 2018年 不囧. All rights reserved.
//

#import "LJSharePicturesController.h"
#import "LJSharePictureCell.h"

@interface LJSharePicturesController ()<LJSharePictureCellDelegate>

@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSMutableDictionary *mDict;
@property (nonatomic, strong) UIButton *rightBtn;

@end

@implementation LJSharePicturesController

static NSString * const reuseIdentifier = @"LJMorePicturesCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    // Register cell classes
    [self.collectionView registerClass:[LJSharePictureCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.allowsSelection = NO;
    self.dataList = self.pictureArray.mutableCopy;
    self.mDict = [NSMutableDictionary dictionary];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
    [self.rightBtn setTitle:[NSString stringWithFormat:@"完成0/%zd",self.dataList.count] forState:UIControlStateNormal];
//    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPresGestureRecognizer:)];
//    // 兼容系统手势
//    for (UIGestureRecognizer *gestureRecognizer in self.collectionView.gestureRecognizers) {
//        if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
//            [gestureRecognizer requireGestureRecognizerToFail:longPressGestureRecognizer];
//        }
//    }
//    [self.collectionView addGestureRecognizer:longPressGestureRecognizer];
}

#pragma mark - Actions

//- (void)handleLongPresGestureRecognizer:(UIGestureRecognizer *)gesture {
//
//    switch (gesture.state) {
//        case UIGestureRecognizerStateBegan: {
//            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[gesture locationInView:gesture.view]];
//            [self.collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
//        } break;
//        case UIGestureRecognizerStateChanged: {
//            [self.collectionView updateInteractiveMovementTargetPosition:[gesture locationInView:gesture.view]];
//        } break;
//        case UIGestureRecognizerStateEnded: {
//            [self.collectionView endInteractiveMovement];
//
//        } break;
//        default: [self.collectionView cancelInteractiveMovement];
//            break;
//    }
//}

- (void)clickRigthBtn:(UIButton *)sender {
    NSMutableArray *mList = [NSMutableArray array];
    for (NSInteger index = 0; index < self.dataList.count; index ++) {
        UIImage *image = self.mDict[@(index)];
        if (image) {
            [mList addObject:image];
        }
    }
    
}

#pragma mark - LJCollectionViewMovedFlowLayoutDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LJSharePictureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.indexPath = indexPath;
    cell.delegate = self;
    id imageData= self.dataList[indexPath.row];
    //选择类型
    if ([imageData isKindOfClass:[NSString class]]) {
        cell.cellImageName = imageData;
    } else if ([imageData isKindOfClass:[UIImage class]]) {
        cell.cellImage = imageData;
    }
    
    return cell;
}

//- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
//
//    return YES;
//}

//- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(nonnull NSIndexPath *)sourceIndexPath toIndexPath:(nonnull NSIndexPath *)destinationIndexPath {
//    // 取出源item数据
//    id tempData = self.dataList[sourceIndexPath.item];
//    //从资源数组中移除该数据
//    [self.dataList removeObjectAtIndex:sourceIndexPath.item];
//    //将数据插入到资源数组中的目标位置上
//    [self.dataList insertObject:tempData atIndex:destinationIndexPath.item];
//
//}

- (void)sharePictureCell:(LJSharePictureCell *)pictureCell didsSelectedAtIndexPath:(NSIndexPath *)indexPath image:(UIImage *)image {
    if (image) {
        self.mDict[@(indexPath.item)] = image;
    } else {
        [self.mDict removeObjectForKey:@(indexPath.item)];
    }
    [self.rightBtn setTitle:[NSString stringWithFormat:@"完成%zd/%zd",self.mDict.allKeys.count,self.dataList.count] forState:UIControlStateNormal];
}

- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setBackgroundImage:[UIImage imageNamed:@"yuajiaojvxing"] forState:UIControlStateNormal];
        _rightBtn.frame = CGRectMake(0, 0, 60, 30);
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(clickRigthBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}


@end
