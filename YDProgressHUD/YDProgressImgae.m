//
//  YDProgressImgae.m
//  加载进度条
//
//  Created by iOS on 2018/4/4.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "YDProgressImgae.h"

@interface YDProgressImgae ()

// 定时器
@property (nonatomic, strong) NSTimer *timer;
// 切换图片的下标
@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation YDProgressImgae

- (void)loadStartAnimating
{
    NSAssert(self.imgArray.count, @"图片数组不能为空");
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.duration / self.imgArray.count target:self selector:@selector(startTimer) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
    [self.timer fire];
}

- (void)loadStopAnimating
{
    if (self.timer) {
        self.currentIndex = 0;
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)loadStopWithImg:(NSString *)imgName
{
    [self loadStopAnimating];
    
    self.image = [UIImage imageNamed:imgName];
}

- (void)startTimer
{
    self.image = [UIImage imageNamed:self.imgArray[self.currentIndex]];
    
    (self.currentIndex == self.imgArray.count - 1) ? self.currentIndex = 0 : self.currentIndex++;
}

#pragma mark - 释放定时器 防止内存泄露
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    if (!newSuperview) {
        [self loadStopAnimating];
    }
}

@end
