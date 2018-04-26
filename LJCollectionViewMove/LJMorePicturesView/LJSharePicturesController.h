//
//  LJSharePicturesController.h
//  LJCollectionViewMove
//
//  Created by 刘俊杰 on 2018/4/26.
//  Copyright © 2018年 不囧. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LJSharePicturesController;

@protocol LJMorePicturesControllerDelegate <NSObject>

@optional

- (void)morePicturesController:(LJSharePicturesController *)controller imageList:(NSArray<UIImage *> *)imageList;

@end

@interface LJSharePicturesController : UICollectionViewController

@property (nonatomic, weak) id<LJMorePicturesControllerDelegate> delegate;
/**
 * 需要显示的数据
 * 如果是网络地址，请使用NSURL
 */
@property (nonatomic, copy) NSArray *pictureArray;

@end
