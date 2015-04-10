//
//  QYColumnView.m
//  DrawColumnView
//
//  Created by qingyun on 15-4-2.
//  Copyright (c) 2015年 hnqingyun.com. All rights reserved.
//

#import "QYColumnView.h"

@implementation QYColumnView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 绘制竖线
    [self drawVeriticalLinesWithContext:ctx];
    
    // 绘制横线
    [self drawHorizontalLinesWithContext:ctx];
    
    // 绘制柱形
    [self drawBarsWithContext:ctx];
}



- (void)drawVeriticalLinesWithContext:(CGContextRef)ctx
{
    int numOfVertLines = (kWidth - 2 * kOffSetX) / kXStep + 1;
    
    for (int i = 0; i < numOfVertLines; i++) {
        CGPoint fromP = CGPointMake(kOffSetX + i * kXStep, kOffSetY);
        CGPoint toP = CGPointMake(kOffSetX + i * kXStep, kHeight - kOffSetY);
        [self drawLineFromPoint:fromP ToPoint:toP WithContext:ctx];
    }
}

- (void)drawHorizontalLinesWithContext:(CGContextRef)ctx
{
    int numOfHorLines = (kHeight - 2 * kOffSetY) / kYStep + 1;
    
    for (int i = 0; i < numOfHorLines; i++) {
        CGPoint fromP = CGPointMake(kOffSetX, kHeight - kOffSetY - i * kYStep);
        CGPoint toP = CGPointMake(kWidth - kOffSetX, kHeight - kOffSetY - i * kYStep);
        [self drawLineFromPoint:fromP ToPoint:toP WithContext:ctx];
    }
}

- (void)drawLineFromPoint:(CGPoint)p1 ToPoint:(CGPoint)p2 WithContext:(CGContextRef)ctx
{
    CGContextSetStrokeColorWithColor(ctx, [UIColor lightGrayColor].CGColor);
    
    const CGFloat dash[] = {2, 3};
    CGContextSetLineDash(ctx, 0, dash, 2);
    
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, p1.x, p1.y);
    CGContextAddLineToPoint(ctx, p2.x, p2.y);
    CGContextClosePath(ctx);
    
    CGContextStrokePath(ctx);
}

- (void)drawBarsWithContext:(CGContextRef)ctx
{
    CGFloat datas[] = {0.65, 0.37, 0.99, 0.18, 0.55, 0.83, 0.29, 0.4};
    
    int numOfDatas = sizeof(datas) / sizeof(CGFloat);
    
    for (int i = 0; i < numOfDatas; i++) {
        CGFloat y = kOffSetY+(1-datas[i])*kBarHeith;
        CGRect rect = CGRectMake(kOffSetX+(i+1)*kXStep-kBarWidth/2, y, kBarWidth, datas[i] * kBarHeith);
        [self drawBarWithContext:ctx InRect:rect];
    }
}

- (void)drawBarWithContext:(CGContextRef)ctx InRect:(CGRect)rect
{
    CGContextSetFillColorWithColor(ctx, [UIColor greenColor].CGColor);
    
    CGContextFillRect(ctx, rect);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    const CGFloat components[] = {0.6, 0.8, 0.7, 1, 0.2, 0.6, 0.3, 1, 0.6, 0.8, 0.7, 1};

    CGFloat locations[] = {0, 0.618, 1};
    
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, 3);
    CGPoint startPoint = CGPointMake(rect.origin.x, rect.origin.y);
    CGPoint endPoint = CGPointMake(rect.origin.x+kBarWidth, rect.origin.y);
    
    CGContextSaveGState(ctx);
    CGContextClipToRect(ctx, rect);
    
    CGContextDrawLinearGradient(ctx, gradient, startPoint, endPoint, 0);
    
    CGContextRestoreGState(ctx);
    
    CGColorSpaceRelease(colorSpace);
}

@end
