//
//  LJTestController.m
//  LJCollectionViewMove
//
//  Created by 刘俊杰 on 16/9/6.
//  Copyright © 2016年 不囧. All rights reserved.
//

#import "LJTestController.h"
#import "LJPictureView.h"
@interface LJTestController ()<LJPictureViewDelegate>

@property (nonatomic, strong) NSMutableArray<NSString *> *dataList;

@property (nonatomic, strong) LJPictureView *pictureView;

@end

@implementation LJTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataList = @[@"WechatIMG1", @"WechatIMG2", @"WechatIMG3",
                   @"WechatIMG4"].mutableCopy;
    CGRect frame = CGRectMake(12, 40, self.view.bounds.size.width - 12*2., 200);
    
    
    [self.view addSubview:self.pictureView];
    self.pictureView.frame = frame;
    self.pictureView.pictureNames = self.dataList;
}

#pragma mark - LJPictureViewDelegate

- (void)pictureViewDidSelectAddCell:(LJPictureView *)pictureView {
    [self.dataList addObject:@"WechatIMG5"];
    self.pictureView.pictureNames = self.dataList;
}

- (void)pictureView:(LJPictureView *)pictureView didSelectCellIndexPath:(NSIndexPath *)indexPath {
    
}

- (LJPictureView *)pictureView {
    if (!_pictureView) {
        _pictureView = [[LJPictureView alloc] init];
        
        _pictureView.delegate = self;
    }
    return _pictureView;
}

@end
