//
//  LJTestController.m
//  LJCollectionViewMove
//
//  Created by 刘俊杰 on 16/9/6.
//  Copyright © 2016年 不囧. All rights reserved.
//

#import "LJTestController.h"
#import "LJPictureView.h"

#import "SDPhotoBrowser.h"//放大图片

@interface LJTestController ()<LJPictureViewDelegate, SDPhotoBrowserDelegate>

@property (nonatomic, strong) NSMutableArray *dataList;

//@property (nonatomic, strong) LJPictureView *pictureView;
@property (weak, nonatomic) IBOutlet LJPictureView *pictureView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pictureViewHeight;

@end

@implementation LJTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataList = @[@"WechatIMG1", @"WechatIMG2", @"WechatIMG3",
                   @"WechatIMG4"].mutableCopy;
//    CGRect frame = CGRectMake(12, 20, self.view.bounds.size.width - 12*2., 200);
//    
//    [self.view addSubview:self.pictureView];
//    self.pictureView.frame = frame;
    [self setupPictureView];
    
    self.pictureView.pictureArray = self.dataList.copy;
    
}

- (void)setupPictureView {
    self.pictureView.delegate = self;
    self.pictureView.hiddenDeleteView = NO;
    self.pictureView.hiddenAddView = NO;
    self.pictureView.onlyAddViewShow = YES;
    self.pictureView.deleteViewImage = [UIImage imageNamed:@"icon-off"];
    self.pictureView.addViewImage = [UIImage imageNamed:@"icon-addpicture"];
    self.pictureView.didFinishLayoutHeight = ^(CGFloat height) {
    self.pictureViewHeight.constant = height;
    };
}

#pragma mark - LJPictureViewDelegate

- (void)pictureViewDidSelectAddCell:(LJPictureView *)pictureView {
    [self.dataList addObject:@"WechatIMG5"];
    //必须使用copy
    self.pictureView.pictureArray = self.dataList.copy;
}

- (void)pictureView:(LJPictureView *)pictureView collectionView:(UICollectionView *)collectionView didSelectIndexPath:(NSIndexPath *)indexPath {
    @autoreleasepool {
        SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
        browser.sourceImagesContainerView = collectionView;
        browser.currentImageIndex = indexPath.row;
        browser.imageCount = pictureView.pictureArray.count;
        browser.delegate = self;
        [browser show];
    }
}

- (void)pictureView:(LJPictureView *)pictureView didDeleteIndexPath:(NSIndexPath *)indexPath {
    [self.dataList removeObjectAtIndex:indexPath.row];
}

#pragma mark - SDPhotoBrowserDelegate

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
    return [UIImage imageNamed:self.dataList[index]];
}

//- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index {
//    
//}


//- (LJPictureView *)pictureView {
//    if (!_pictureView) {
//        _pictureView = [[LJPictureView alloc] init];
//        
//        _pictureView.delegate = self;
//    }
//    return _pictureView;
//}

@end
