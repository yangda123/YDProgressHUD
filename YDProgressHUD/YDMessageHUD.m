//
//  YDMessageHUD.m
//  加载进度条
//
//  Created by iOS on 2018/4/4.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "YDMessageHUD.h"
#import "UIView+YDProExtension.h"

/** 状态栏的高度 */
#define YD_StatusBarH [UIApplication sharedApplication].statusBarFrame.size.height
/** 导航栏和状态栏的高度 */
#define YD_NavigationBarH (44.0 + YD_StatusBarH)

/** 屏幕的高 */
#define YD_KScreenHeight ([[UIScreen mainScreen] bounds].size.height)
/** 屏幕的宽 */
#define YD_KScreenWidth  ([[UIScreen mainScreen] bounds].size.width)

#define YDMainThreadAssert() NSAssert([NSThread isMainThread], @"需要在主线程中显示提示语")

static NSString *lastMessage;

@interface YDMessageHUD ()

// 需要提示的信息
@property (nonatomic, strong) NSString *message;
// 提示语的label
@property (nonatomic, strong) UILabel *messageLbl;

@end

@implementation YDMessageHUD

#pragma mark - 判断是否是空字符串
+ (BOOL)isEmptyStr:(NSObject *)obj
{
    if (obj == NULL || obj == nil) { return YES; }
    
    if([obj isKindOfClass:[NSNull class]]) { return YES; }
    
    if ([obj isEqual:[NSNull null]]) { return YES; }
    
    if ([obj isKindOfClass:[NSString class]]) {
        NSString *str = (NSString *)obj;
        if(![[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - 弹出提示语
+ (void)showMessageTop:(NSString *)message
{
    [self showMessage:message block:nil];
}

+ (void)showMessageCenter:(NSString *)message
{
    [self showMessage:message block:^(YDMessageHUD *msgHUD) {
        msgHUD.msgPosition = YDMessagePositionCenter;
    }];
}

+ (void)showMessageBottom:(NSString *)message
{
    [self showMessage:message block:^(YDMessageHUD *msgHUD) {
        msgHUD.msgPosition = YDMessagePositionBottom;
    }];
}

+ (void)showMessage:(NSString *)message block:(MessageBlock)msgBlock
{
    YDMainThreadAssert();
    
    // 当message为空 ／ 和上次提示语一样 之间return
    if ([self isEmptyStr:message] || [message isEqualToString:lastMessage]) {
        return;
    }
    
    lastMessage = message;
    
    YDMessageHUD *msgHUD = [[YDMessageHUD alloc] initWithBlock:msgBlock title:message];
    [msgHUD.supView addSubview:msgHUD];
    
    if (msgHUD.msgPosition == YDMessagePositionTop) {
        
        [UIView animateWithDuration:.2 animations:^{
            msgHUD.yd_y = 0.0;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:.2 delay:msgHUD.showDelay options:UIViewAnimationOptionTransitionNone animations:^{
                msgHUD.yd_y = -YD_NavigationBarH;
            } completion:^(BOOL finished) {
                [msgHUD removeFromSuperview];
                lastMessage = nil;
            }];
        }];
    }else {
    
        msgHUD.alpha = 0.0;
        
        [UIView animateWithDuration:.2 animations:^{
            msgHUD.alpha = 1.0;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:.2 delay:msgHUD.showDelay options:UIViewAnimationOptionCurveEaseIn animations:^{
                msgHUD.alpha = 0;
            } completion:^(BOOL finished) {
                [msgHUD removeFromSuperview];
                lastMessage = nil;
            }];
        }];
    }
}

- (instancetype)initWithBlock:(MessageBlock)block title:(NSString *)message
{
    if (self = [super init]) {
        // 1. 先初始化默认数据
        [self initDefaultData];
        // 2. 设置message
        self.message = message;
        // 3. 回调block，刷新数据
        if (block) { block(self); }
        // 4. 布局
        [self layoutViewFrame];
    }
    
    return self;
}

#pragma mark - 设置默认的数据
- (void)initDefaultData
{
    self.supView = [UIApplication sharedApplication].keyWindow;
    
    self.msgPosition = YDMessagePositionTop;
    self.showDelay = 2.0;
    self.bottomSpace = 20.0;
    
    self.textColor = [UIColor whiteColor];
    self.textFont  = [UIFont systemFontOfSize:16.0];
}

#pragma mark - 计算视图的Frame
- (CGSize)rectWithString:(NSString *)string size:(CGSize)maxSize font:(UIFont *)font
{
    return [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
}

- (void)layoutViewFrame
{
    if (self.msgPosition == YDMessagePositionTop) {
        
        // 显示在顶部的时候：添加在主窗口上
        self.supView = [UIApplication sharedApplication].keyWindow;
        
        self.frame = CGRectMake(0, -YD_NavigationBarH, YD_KScreenWidth, YD_NavigationBarH);
        self.backgroundColor = self.backColor ? self.backColor : [UIColor orangeColor];
        
         self.messageLbl.frame = CGRectMake(20, YD_StatusBarH, YD_KScreenWidth - 40, 44.0);
    }else {
        
        CGSize msgSize = [self rectWithString:self.message size:CGSizeMake(self.supView.yd_width - 60, self.supView.yd_height - 40) font:self.textFont];
        CGFloat viewW = msgSize.width  + 20;
        CGFloat viewH = msgSize.height + 20;
        
        CGFloat viewY = self.msgPosition == YDMessagePositionCenter ? self.supView.yd_height * 0.5 - viewH * 0.5 : self.supView.yd_height - self.bottomSpace - viewH;
        
        self.frame = CGRectMake(self.supView.yd_width * 0.5 - viewW * 0.5, viewY, viewW, viewH);
        self.layer.cornerRadius = 6.0;
        self.layer.masksToBounds = YES;
        self.backgroundColor = self.backColor ? self.backColor : [[UIColor blackColor] colorWithAlphaComponent:0.8];
        
        self.messageLbl.frame = CGRectMake(10, 10, msgSize.width, msgSize.height);
    }
}

#pragma mark - 懒加载
- (UILabel *)messageLbl
{
    if (_messageLbl == nil) {
        _messageLbl = [[UILabel alloc] init];
        _messageLbl.numberOfLines = 0;
        _messageLbl.textColor = self.textColor;
        _messageLbl.font = self.textFont;
        _messageLbl.text = self.message;
        _messageLbl.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_messageLbl];
    }
    
    return _messageLbl;
}

@end

















































