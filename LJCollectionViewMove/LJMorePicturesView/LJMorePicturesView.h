//
//  LJMorePicturesView.h
//  LJCollectionViewMove
//
//  Created by 刘俊杰 on 16/9/7.
//  Copyright © 2016年 不囧. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LJMorePicturesView;

typedef void(^LJMorePicturesViewBlock)(CGRect frame);

@protocol LJMorePicturesViewDelegate <NSObject>

@optional
//<! 选中 Add
- (void)pictureViewDidSelectAddCell:(LJMorePicturesView *)pictureView;
//<! 选中 indexPath
- (void)pictureView:(LJMorePicturesView *)pictureView collectionView:(UICollectionView *)collectionView didSelectIndexPath:(NSIndexPath *)indexPath;
//<! 删除 indexPath
- (void)pictureView:(LJMorePicturesView *)pictureView didDeleteIndexPath:(NSIndexPath *)indexPath;

@end

@interface LJMorePicturesView : UIView

// ====== LJMorePicturesView 的配置 ======

@property (nonatomic, assign) NSUInteger perLineNum; //<! 每行个数, 默认是 3

@property (nonatomic, assign) NSUInteger maxPictureNum; //<! 最多显示图片, 默认是 9

@property (nonatomic, assign) CGFloat cellSpacing; //<! cell间距, 默认是 4

@property (nonatomic, assign) CGFloat lineSpacing; //<! 行间距, 默认是 4

@property (nonatomic, weak) id<LJMorePicturesViewDelegate> delegate;

@property (nonatomic, assign) BOOL hiddenAddView; //<! 隐藏添加视图, 默认是 YES

@property (nonatomic, strong) UIImage *addViewImage; //<! 添加视图的图片

@property (nonatomic, assign) BOOL onlyAddViewShow; //<! 只有“+”是否显示，默认 NO

@property (nonatomic, assign) BOOL hiddenDeleteView; //<! 隐藏删除视图, 默认是 YES

@property (nonatomic, strong) UIImage *deleteViewImage; //<! 删除视图的图片

@property (nonatomic, strong) UIImage *placeholderImage; //<! 加载网络图片的占位图

// ====== 以上是 LJMorePicturesView 的配置 ======

/** 
 * 需要显示的数据  
 * 如果是网络地址，请使用NSURL
 */
@property (nonatomic, copy) NSArray *pictureArray;

/** 布局完成后的回调block，可以在这里获取到view的真实高度  */
@property (nonatomic, copy) void(^didFinishLayoutHeight)(CGFloat height) ;

@end
