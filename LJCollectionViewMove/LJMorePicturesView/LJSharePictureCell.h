//
//  LJSharePictureCell.h
//  LJCollectionViewMove
//
//  Created by 刘俊杰 on 2018/4/26.
//  Copyright © 2018年 不囧. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LJSharePictureCell;

@protocol LJSharePictureCellDelegate <NSObject>

@optional

- (void)sharePictureCell:(LJSharePictureCell *)pictureCell didsSelectedAtIndexPath:(NSIndexPath *)indexPath image:(UIImage *)image;

@end

@interface LJSharePictureCell : UICollectionViewCell


@property (nonatomic, weak) id<LJSharePictureCellDelegate> delegate;
@property (nonatomic, assign) BOOL isSelectedBtn;// 默认是 YES
@property (nonatomic,   copy) NSString *cellImageName;
@property (nonatomic, strong) UIImage *cellImage;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end
