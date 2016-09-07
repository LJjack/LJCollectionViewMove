//
//  LJPictureCell.m
//  LJCollectionViewMove
//
//  Created by 刘俊杰 on 16/9/7.
//  Copyright © 2016年 不囧. All rights reserved.
//

#import "LJPictureCell.h"

@interface LJPictureCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation LJPictureCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.imageView];
        self.imageView.frame = self.contentView.bounds;
        self.contentView.backgroundColor = [UIColor lightGrayColor];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

- (void)setImageName:(NSString *)imageName {
    _imageName = imageName;
    self.imageView.image = [UIImage imageNamed:imageName];
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

@end
