//
//  LJPictureView.h
//  LJCollectionViewMove
//
//  Created by 刘俊杰 on 16/9/7.
//  Copyright © 2016年 不囧. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LJPictureView;

@protocol LJPictureViewDelegate <NSObject>

@optional
//<! 选中 Add
- (void)pictureViewDidSelectAddCell:(LJPictureView *)pictureView;
//<! 选中 cell
- (void)pictureView:(LJPictureView *)pictureView didSelectCellIndexPath:(NSIndexPath *)indexPath;

@end

@interface LJPictureView : UIView

@property (nonatomic, strong) NSArray<NSString *> *pictureNames;

@property (nonatomic, assign) NSUInteger perLineNum; //<! 每行个数, 默认是 3

@property (nonatomic, assign) NSUInteger maxPictureNum; //<! 最多显示图片, 默认是 9

@property (nonatomic, assign) CGFloat cellSpacing; //<! cell间距, 默认是 4

@property (nonatomic, assign) CGFloat lineSpacing; //<! 行间距, 默认是 4

@property (nonatomic, weak) id<LJPictureViewDelegate> delegate;

@end
