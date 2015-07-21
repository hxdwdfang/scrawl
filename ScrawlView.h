//
//  ScrawlView.h
//  scrawl
//
//  Created by 王定方 on 15/7/9.
//  Copyright (c) 2015年 王定方. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScrawlViewDelegate;

@interface ScrawlView : UIView
@property (nonatomic, assign) NSInteger panWidth;

///图片缩放比例
@property (nonatomic, assign) CGFloat scale;

///delegate
@property (nonatomic, weak) id<ScrawlViewDelegate> delegate;

- (void)clear;
- (void)back;
- (UIImage *)getImage;
@end

@protocol ScrawlViewDelegate <NSObject>

@optional
- (void) beforeScrawlViewTouched:(ScrawlView *) scrawlView;

- (void) afterScrawlViewCleared:(ScrawlView *) scrawlView;

@end
