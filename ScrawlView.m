//
//  ScrawlView.m
//  scrawl
//
//  Created by 王定方 on 15/7/9.
//  Copyright (c) 2015年 王定方. All rights reserved.
//

#import "ScrawlView.h"

@interface ScrawlView ()
@property (nonatomic, strong) NSMutableArray *totalArray;

///涂鸦的位置
@property (nonatomic, assign) CGPoint startPoint;

@property (nonatomic, assign) CGPoint endPoint;

@end

@implementation ScrawlView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self loadNormalProperty];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self loadNormalProperty];
    }
    
    return self;
}

///默认变量
- (void) loadNormalProperty {
    _panWidth = 4;
    _scale = 1;
    self.backgroundColor = [UIColor clearColor];
}

- (NSMutableArray *)totalArray
{
    if (_totalArray == nil) {
        _totalArray = [NSMutableArray array];
    }
    return _totalArray;
}

- (void)addPointToArrayWithTouch:(NSSet *)touches
{
    UITouch *touch = [touches anyObject];
    
    NSMutableArray *tmpArray = [self.totalArray lastObject];
    
    [tmpArray addObject:[NSValue  valueWithCGPoint:[touch locationInView:self]]];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(beforeScrawlViewTouched:)]) {
        [self.delegate beforeScrawlViewTouched:self];
    }
    
    UITouch *touch = [touches anyObject];
    
    NSMutableArray *tmpArray = [NSMutableArray array];
    
    [tmpArray addObject:[NSValue  valueWithCGPoint:[touch locationInView:self]]];
    
    [self.totalArray addObject:tmpArray];
    
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self addPointToArrayWithTouch:touches];
    
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self addPointToArrayWithTouch:touches];
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    int count = 0;
    for (NSArray *tmpArray in self.totalArray) {
        for (int i = 0;i < tmpArray.count;i++)
        {
            CGPoint point = [tmpArray[i] CGPointValue];
            ///起始位置
            if (0 == count && 0 == i) {
                _startPoint = point;
                _endPoint = point;
            }else {
                if (point.x < _startPoint.x) {
                    _startPoint.x = point.x;
                }else if (point.x > _endPoint.x) {
                    _endPoint.x = point.x;
                }
                
                if (point.y < _startPoint.y) {
                    _startPoint.y = point.y;
                }else if(point.y > _endPoint.y) {
                    _endPoint.y = point.y;
                }
            }
            
            if (i == 0) {
                CGContextMoveToPoint(context, point.x, point.y);
            }
            else
            {
                CGContextAddLineToPoint(context, point.x, point.y);
            }
        }
        count++;
    }
    
    CGContextSetLineWidth(context, _panWidth);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextStrokePath(context);
    
}

- (void)clear
{
    [self.totalArray removeAllObjects];
    [self setNeedsDisplay];
    
    if ([self.delegate respondsToSelector:@selector(afterScrawlViewCleared:)]) {
        [self.delegate afterScrawlViewCleared:self];
    }
}
- (void)back
{
    [self.totalArray removeLastObject];
    [self setNeedsDisplay];
}


- (UIImage *)getImage {
    
    NSLog(@"图片位置：startPoint = (%f, %f), endPoint = (%f, %f)", _startPoint.x, _startPoint.y, _endPoint.x, _endPoint.y);
    
    CGRect imageFrame = CGRectMake(_startPoint.x - _panWidth, 0, _endPoint.x - _startPoint.x + _panWidth * 2, self.bounds.size.height);
    
    // 开启上下文
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    ///只裁剪用户有涂鸦的部分
    CGContextBeginPath(context);
    CGContextAddRect(context, imageFrame);
    CGContextClip(context);
    
    // 将控制器view的layer渲染到上下文
    [self.layer renderInContext:context];
    
    // 取出图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 结束上下文
    UIGraphicsEndImageContext();
    
    ///这个时候出来的image是跟self的frame一样大的view, 但图片数据是真实涂鸦那和大，旁边都是透明的，所以要进行剪切
    UIImage *realImage = [self cropImage:newImage withCropRect:imageFrame];
    
    return realImage;
}


///裁剪成目标大小的图片(旁边没有留白)
- (UIImage *)cropImage:(UIImage *)image withCropRect:(CGRect)cropRect {
    CGPoint origin;
    
    origin = CGPointMake(-cropRect.origin.x, - cropRect.origin.y);
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(cropRect.size.width * _scale, cropRect.size.height * _scale) , NO, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextConcatCTM(context, CGAffineTransformMakeScale(_scale, _scale));
    [image drawAtPoint:origin];
    
    //获取缩放后剪切的image图片
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}


@end
