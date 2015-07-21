//
//  ScrawlControlView.h
//  scrawl
//
//  Created by 王定方 on 15/7/10.
//  Copyright (c) 2015年 王定方. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrawlControlView : UIView

///获取图片
@property (nonatomic, readonly) UIImage *image;

///清除view
- (void)clearImage;
@end
