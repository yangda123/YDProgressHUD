//
//  YDMessageHUD.h
//  加载进度条
//
//  Created by iOS on 2018/4/4.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YDMessageHUD;

typedef void(^MessageBlock)(YDMessageHUD *msgHUD);

// 显示提示语的位置，可以自己重新设置
typedef NS_ENUM(NSInteger, YDMessagePosition) {
    // 显示在主窗口的顶部, 显示的信息不要太长
    YDMessagePositionTop,
    // 显示在父视图的中间
    YDMessagePositionCenter,
    // 显示在父视图的底部
    YDMessagePositionBottom
};

@interface YDMessageHUD : UIView

#pragma mark - 方法
// 默认样式。 顶部显示 -- 在主窗口上
+ (void)showMessageTop:(NSString *)message;
// 默认样式。 中间显示
+ (void)showMessageCenter:(NSString *)message;
// 默认样式。 底部显示
+ (void)showMessageBottom:(NSString *)message;
// 在block中挑战属性，默认在顶部
+ (void)showMessage:(NSString *)message block:(MessageBlock)msgBlock;

#pragma mark - 属性，在block中进行自定义
// 距离父视图底部的间距: 默认 20
@property (nonatomic, assign) CGFloat bottomSpace;
// 显示的时间 默认 2.0秒
@property (nonatomic, assign) NSTimeInterval showDelay;
// 挡板背景的颜色
@property (nonatomic, strong) UIColor *backColor;
// 字体的大小
@property (nonatomic, strong) UIFont *textFont;
// 字体的颜色
@property (nonatomic, strong) UIColor *textColor;
// 字体的位置
@property (nonatomic, assign) YDMessagePosition msgPosition;
// 需要添加到的父视图，默认在主窗口上
@property (nonatomic, weak) UIView *supView;

@end




















