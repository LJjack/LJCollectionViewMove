//
//  LJMorePicturesCell.h
//  LJCollectionViewMove
//
//  Created by 刘俊杰 on 16/9/7.
//  Copyright © 2016年 不囧. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LJMorePicturesCell;

@protocol LJMorePicturesCellDelegate <NSObject>

@optional

- (void)morePicturesCellClickDeleteView:(LJMorePicturesCell *)pictureCell;

@end

@interface LJMorePicturesCell : UICollectionViewCell

@property (nonatomic,   copy) NSString *cellImageName;

@property (nonatomic, strong) UIImage *cellImage;

@property (nonatomic, assign) BOOL hiddenDeleteView;//隐藏删除视图, 默认是 YES

@property (nonatomic, strong) UIImage *deleteImage;

@property (nonatomic, weak) id<LJMorePicturesCellDelegate> delegate;

@end
