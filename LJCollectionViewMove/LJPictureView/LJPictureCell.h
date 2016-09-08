//
//  LJPictureCell.h
//  LJCollectionViewMove
//
//  Created by 刘俊杰 on 16/9/7.
//  Copyright © 2016年 不囧. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LJPictureCell;

@protocol LJPictureCellDelegate <NSObject>

@optional

- (void)pictureCellClickDeleteView:(LJPictureCell *)pictureCell;

@end

@interface LJPictureCell : UICollectionViewCell

@property (nonatomic,   copy) NSString *cellImageName;

@property (nonatomic, strong) UIImage *cellImage;

@property (nonatomic, strong) NSString *cellImageURLString;

@property (nonatomic, assign) BOOL hiddenDeleteView;//隐藏删除视图, 默认是 YES

@property (nonatomic, strong) UIImage *deleteImage;

@property (nonatomic, weak) id<LJPictureCellDelegate> delegate;

@end
