//
//  ScrawlControlView.m
//  scrawl
//
//  Created by 王定方 on 15/7/10.
//  Copyright (c) 2015年 王定方. All rights reserved.
//

#import "ScrawlControlView.h"
#import "ScrawlView.h"

@interface ScrawlControlView () <ScrawlViewDelegate>

@property (nonatomic, strong) IBOutlet ScrawlView *scrawlView;

@property (nonatomic, strong) IBOutlet UIView *controlView;

@property (nonatomic, strong) IBOutlet UIImageView *hLineImageView;
@property (nonatomic, strong) IBOutlet UIImageView *vLineImageView;

@end

@implementation ScrawlControlView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [[[NSBundle mainBundle] loadNibNamed:@"ScrawlControlView" owner:Nil options:nil] objectAtIndex:0];
    if (self) {
        self.frame = frame;
        [self loadNormalProperty];
    }
    
    return self;
}



- (void) loadNormalProperty {
    [self drawDashedLine:_hLineImageView isVertical:NO lineColor:[UIColor colorWithWhite: 85.0 / 255.0 alpha:1]];
    
    [self drawDashedLine:_vLineImageView isVertical:YES lineColor:[UIColor colorWithWhite: 85.0 / 255.0 alpha:1]];
    
    _scrawlView.scale = .2;
    _scrawlView.delegate = self;
}

- (UIImage *)image {
    return [_scrawlView getImage];
}

- (void)clearImage {
    [_scrawlView clear];
}

///画虚线,生成image赋值给imageview
-(void)drawDashedLine:(UIImageView *)imageView isVertical:(BOOL) isVertical lineColor:(UIColor *)lineColor {
    if (!imageView) {
        return;
    }
    if (!lineColor) {
        lineColor = [UIColor colorWithWhite:0 alpha:.3];
    }
    
    UIGraphicsBeginImageContext(imageView.frame.size);   //开始画线
    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);  //设置线条终点形状
    
    
    CGFloat lengths[] = {2,1};
    CGContextRef line = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(line, lineColor.CGColor);
    
    
    CGContextSetLineDash(line, 0, lengths, 2);  //画虚线
    CGContextMoveToPoint(line, 0.0, 0.0);    //开始画线
    if (isVertical) {
        CGContextAddLineToPoint(line, 0.0, imageView.bounds.size.height);
    }else {
        CGContextAddLineToPoint(line, imageView.bounds.size.width, 0.0);
    }
    CGContextStrokePath(line);
    
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
}


///显示影藏controlView
- (void) showOrHideControlView:(BOOL) show {
    CGRect frame = _controlView.frame;
    
    CGFloat yPos = self.frame.size.height;
    if (show) {
        yPos = self.frame.size.height - frame.size.height;
    }
    
    if (frame.origin.y == yPos) {
        return;
    }
    
    frame.origin.y = yPos;
    
    [UIView animateWithDuration:0.2 animations:^{
        _controlView.frame = frame;
    }];
}

#pragma mark -- ScrawlViewDelegate
- (void) beforeScrawlViewTouched:(ScrawlView *) scrawlView {
    [self showOrHideControlView:NO];
}

- (void) afterScrawlViewCleared:(ScrawlView *) scrawlView {
    [self showOrHideControlView:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
