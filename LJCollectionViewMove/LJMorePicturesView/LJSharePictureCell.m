//
//  LJSharePictureCell.m
//  LJCollectionViewMove
//
//  Created by 刘俊杰 on 2018/4/26.
//  Copyright © 2018年 不囧. All rights reserved.
//

#import "LJSharePictureCell.h"

@interface LJSharePictureCell()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *selectBtn;

@end

@implementation LJSharePictureCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.selectBtn];
        self.isSelectedBtn = YES;//默认
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect frame = self.contentView.bounds;
    self.imageView.frame = CGRectMake(3, 3, frame.size.width - 6, frame.size.height - 6);
    self.selectBtn.frame = CGRectMake(CGRectGetWidth(frame) - 40, 0, 40, 40);
}

- (void)clickSelectBtn:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.delegate sharePictureCell:self didsSelectedAtIndexPath:self.indexPath image:self.imageView.image];
        
    } else {
        [self.delegate sharePictureCell:self didsSelectedAtIndexPath:self.indexPath image:nil];
    }
}

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

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

- (UIButton *)selectBtn {
    if (!_selectBtn) {
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectBtn setImage:[UIImage imageNamed:@"photo_def_photoPickerVc"] forState:UIControlStateNormal];
        [_selectBtn setImage:[UIImage imageNamed:@"photo_sel_photoPickerVc"] forState:UIControlStateSelected];
        _selectBtn.adjustsImageWhenHighlighted = NO;
        _selectBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _selectBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        _selectBtn.contentEdgeInsets = UIEdgeInsetsMake(5, 0, 0, 5);
        [_selectBtn addTarget:self action:@selector(clickSelectBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _selectBtn;
}

@end
