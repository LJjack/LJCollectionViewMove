//
//  LJCollectionViewCell.m
//  LJCollectionViewMove
//
//  Created by 刘俊杰 on 16/9/5.
//  Copyright © 2016年 不囧. All rights reserved.
//

#import "LJCollectionViewCell.h"

@interface LJCollectionViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation LJCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.titleLabel];
        self.titleLabel.frame = self.contentView.bounds;
        self.contentView.backgroundColor = [UIColor lightGrayColor];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor orangeColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end
