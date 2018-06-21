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

@end

@implementation LJMorePicturesCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect frame = self.contentView.bounds;
    self.imageView.frame = frame;
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

#pragma mark - Getters

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

@end
