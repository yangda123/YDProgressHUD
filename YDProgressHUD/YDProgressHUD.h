//
//  YDProgressHUD.h
//  加载进度条
//
//  Created by iOS on 2018/4/4.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YDProgressHUD;

typedef void(^LoadingBlock)(YDProgressHUD *loadView);
typedef void(^YDReloadBlock)(YDProgressHUD *loadView);

// 加载动画的几种模式
typedef NS_ENUM(NSInteger, YDProgressMode) {
    // 默认菊花模式
    YDProgressModeDefault,
    // 图片动画模式
    YDProgressModeImages,
    // 自定义动画模式
    YDProgressModeCustom,
//    // 隐藏加载动画，只显示提示语，这个提取出来，放到YDMessageHUD中
//    YDProgressModeHidden,
};

// 显示提示语的模式
typedef NS_ENUM(NSInteger, YDMessageMode) {
    // 一直都显示提示语：默认的
    YDMessageModeShow,
    // 一直隐藏提示语
    YDMessageModeHidden,
    // 加载时候不显示。加载结束状态失败或者没有数据显示提示语
    YDMessageModeShowWhenStop
};

// 加载框显示模式
typedef NS_ENUM(NSInteger, YDShowMode) {
    // 默认：弹出背景档板模式
    YDShowModeBackBezel,
    // 针对网络加载结果显示方式, 隐藏挡板
    // 结束时调用：CCC
    YDShowModeNetwork
};

// 停止动画时候的状态：主要针对网络请求的结果
typedef NS_ENUM(NSInteger, YDStopLoadStatus) {
    // 成功：从父视图移除
    YDStopLoadSuccess,
    // 没数据：不移除，提示空数据
    YDStopLoadEmtyp,
    // 失败：不移除，提示错误信息
    YDStopLoadFaiure
};

@interface YDProgressHUD : UIView

#pragma mark - 方法
// 开始加载动画
+ (instancetype)startLoadingBlock:(LoadingBlock)loadBlock;
// AAA: 结束加载动画
+ (void)stopLoading:(UIView *)supView;
// BBB: 结束加载动画: 在主窗口移除
+ (void)stopLoadingKeyWindow;
// CCC: 结束加载动画: 针对网络请求 ：在block中设置YDStopLoadStatus和supview
+ (void)stopNetLoading:(UIView *)supView status:(YDStopLoadStatus)status;
// 点击重新加载的回调处理：针对网络请求失败刷新
- (void)reloadHUD:(YDReloadBlock)reloadBlock;

#pragma mark - 属性 -- 在block中重新设置需要调整的属性
/**
 * 加载框的样式
 *
 */
@property (nonatomic, assign) YDProgressMode loadMode;
/**
 * 显示加载框的模式
 *
 */
@property (nonatomic, assign) YDShowMode showMode;
/**
 * 提示语的模式
 *
 */
@property (nonatomic, assign) YDMessageMode msgMode;
/**
 * 停止动画时的状态：在YDShowModeNetwork显示模式下需要
 *
 */
@property (nonatomic, assign) YDStopLoadStatus stopStatus;
/**
 * 弹出时候是否需要动画效果：默认 YES
 *
 */
@property (nonatomic, assign) BOOL isAnimation;

/**
 * 自定义的动画视图
 *
 */
@property (nonatomic, strong) UIView *customView;
/**
 * 需要添加到的父视图
 *
 * 默认是主窗口 :如果没有修改 结束动画调用：AAA； 没有修改：调用BBB
 *
 */
@property (nonatomic, weak) UIView *supView;
/**
 * 背景挡板的View
 *
 */
@property (nonatomic, strong) UIView *backBezelView;

/**
 * 结束动画: 延长结束的时间 默认：0 延迟
 *
 *
 */
@property (nonatomic, assign) NSTimeInterval hideDelay;

/**
 * 提示语 和 加载动画控件 之间的间距: 默认为5.0
 *
 */
@property (nonatomic, assign) CGFloat labelSpace;
/**
 * 提示语的字体大小
 *
 */
@property (nonatomic, strong) UIFont *titleFont;
/**
 * 提示语的字体颜色
 *
 */
@property (nonatomic, strong) UIColor *titleColor;
/**
 * 加载提示语
 *
 */
@property (nonatomic, copy) NSString *warnningTitle;
/**
 * 加载结果为空提示语：主要针对网络请求没有数据的提示
 *
 */
@property (nonatomic, copy) NSString *emptyLoadTitle;
/**
 * 加载结果错误提示语：主要针对网络请求失败的提示
 *
 */
@property (nonatomic, copy) NSString *errorLoadTitle;
/**
 * 加载动画控件的 宽/高
 *
 */
@property (nonatomic, assign) CGFloat indicatorWH;




/**
 * 动画图片的数组
 *
 */
@property (nonatomic, strong) NSArray *imgArray;
/**
 * 请求结果为空的图片：主要针对网络请求没有数据时候的提示图片
 *
 */
@property (nonatomic, copy  ) NSString *errorImgName;
/**
 * 请求结果错误的图片：主要针对网络请求失败时候的提示图片
 *
 */
@property (nonatomic, copy  ) NSString *emptyImgName;
/**
 * 动画对应的时长: 根据实际需求进行调整, duration默认: 1.0s
 *
 * 定时器执行速度: duration / imgArray.count
 *
 */
@property (nonatomic, assign) NSTimeInterval duration;

@end






























