//
//  LJMorePicturesCell.m
//  LJCollectionViewMove
//
//  Created by 刘俊杰 on 16/9/7.
//  Copyright © 2016年 不囧. All rights reserved.
//

#import "LJMorePicturesCell.h"

@interface LJMorePicturesCell ()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIImageView *deleImgView;//右上角删除按钮

@end

@implementation LJMorePicturesCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.deleImgView];
        self.hiddenDeleteView = YES;//默认
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect frame = self.contentView.bounds;
    self.imageView.frame = frame;
    self.deleImgView.frame = CGRectMake(CGRectGetWidth(frame) - 33., 0, 33., 33.);
}

#pragma mark - Actions

- (void)clickDeleteView {
    [self.delegate morePicturesCellClickDeleteView:self];
}

#pragma mark - Setters

- (void)setCellImageName:(NSString *)cellImageName {
    _cellImageName = cellImageName;
    UIImage *image = [UIImage imageNamed:cellImageName];
    if (!image) {
        image = [UIImage imageWithContentsOfFile:cellImageName];
    }
    self.cellImage = image;
    
}

- (void)setCellImage:(UIImage *)cellImage {
    _cellImage = cellImage;
    self.imageView.image = cellImage;
}

- (void)setHiddenDeleteView:(BOOL)hiddenDeleteView {
    _hiddenDeleteView = hiddenDeleteView;
    self.deleImgView.hidden = hiddenDeleteView;
}


- (void)setDeleteImage:(UIImage *)deleteImage {
    _deleteImage = deleteImage;
    self.deleImgView.image = deleteImage;
}

#pragma mark - Getters
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

- (UIImageView *)deleImgView {
    if (!_deleImgView) {
        _deleImgView = [[UIImageView alloc] init];
        _deleImgView.backgroundColor = [UIColor clearColor];
        _deleImgView.contentMode = UIViewContentModeTopRight;
        _deleImgView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [tap addTarget:self action:@selector(clickDeleteView)];
        [_deleImgView addGestureRecognizer:tap];
    }
    return _deleImgView;
}

@end
