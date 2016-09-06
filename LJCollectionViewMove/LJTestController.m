//
//  LJTestController.m
//  LJCollectionViewMove
//
//  Created by 刘俊杰 on 16/9/6.
//  Copyright © 2016年 不囧. All rights reserved.
//

#import "LJTestController.h"
#import "LJCollectionViewCell.h"
#import "LJCollectionViewMovedFlowLayout.h"

@interface LJTestController ()<LJCollectionViewMovedFlowLayoutDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<NSString *> *dataList;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;

@end

@implementation LJTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataList = @[@"红包", @"转账", @"手机充值",
                   @"芝麻信用",@"天猫", @"生活缴费",
                   @"蚂蚁呗", @"世界那么大"].mutableCopy;
    [self.view addSubview:self.collectionView];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LJCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ViewController_cell" forIndexPath:indexPath];
    
    cell.title = self.dataList[indexPath.section * indexPath.row + indexPath.row];
    
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.dataList.count - 1) {
        return NO;
    }
    
    return YES;
}

//- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
//    if (toIndexPath.row == self.dataList.count - 1) {
//        return NO;
//    }
//    return YES;
//}

- (void)collectionView:(UICollectionView *)collectionView willMoveItemAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    [self.dataList exchangeObjectAtIndex:fromIndexPath.item withObjectAtIndex:toIndexPath.item];
}

- (void)lonePressMoving:(UIGestureRecognizer *)longPress {
    
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan: {
            NSIndexPath *selectIndexPath = [self.collectionView indexPathForItemAtPoint:[_longPress locationInView:self.collectionView]];
             [self.collectionView lj_beginInteractiveMovementForItemAtIndexPath:selectIndexPath];
        } break;
        case UIGestureRecognizerStateChanged: {
            [self.collectionView lj_updateInteractiveMovementTargetPosition:[longPress locationInView:longPress.view]];
        } break;
        case UIGestureRecognizerStateEnded: {
            [self.collectionView lj_endInteractiveMovement];
            
        } break;
        default: [self.collectionView lj_cancelInteractiveMovement];
            break;
    }
}


- (UICollectionView *)collectionView {
    if (!_collectionView) {
        LJCollectionViewMovedFlowLayout *flowLayout = [[LJCollectionViewMovedFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 5;
        flowLayout.minimumInteritemSpacing = 1;
        flowLayout.itemSize = CGSizeMake(100, 100);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor colorWithRed:0.8568 green:0.8568 blue:0.8568 alpha:1.0];
        [_collectionView registerClass:[LJCollectionViewCell class] forCellWithReuseIdentifier:@"ViewController_cell"];
        _longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(lonePressMoving:)];
        // 兼容系统手势
        for (UIGestureRecognizer *gestureRecognizer in _collectionView.gestureRecognizers) {
            if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
                [gestureRecognizer requireGestureRecognizerToFail:_longPress];
            }
        }
        
        [_collectionView addGestureRecognizer:_longPress];
        
        
    }
    return _collectionView;
}

@end
