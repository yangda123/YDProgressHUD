//
//  YDProgressHUD.m
//  加载进度条
//
//  Created by iOS on 2018/4/4.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "YDProgressHUD.h"
#import "UIView+YDProExtension.h"
#import "YDProgressImgae.h"

/** 屏幕的高 */
#define YD_KScreenHeight ([[UIScreen mainScreen] bounds].size.height)
/** 屏幕的宽 */
#define YD_KScreenWidth  ([[UIScreen mainScreen] bounds].size.width)

#define YDStopErrorAssert()  NSAssert(loadingView != nil, @"父试图传入错误/结束动画方法调用错误")
#define YDMainThreadAssert() NSAssert([NSThread isMainThread], @"需要在主线程 开始/结束 加载动画")
#define YDReloadAssert() NSAssert(self.reloadBlock, @"请实现reloadHUD:回调方法")

@interface YDProgressHUD ()

// 提示语的label
@property (nonatomic, strong) UILabel *warnningLbl;
// 加载菊花控件
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
// 加载图片动画
@property (nonatomic, strong) YDProgressImgae *loadImgView;
// 重新刷新的回调
@property (nonatomic, copy  ) YDReloadBlock reloadBlock;

@end

@implementation YDProgressHUD

#pragma mark - 获取当前的视图
+ (instancetype)progressHUDForView:(UIView *)view {
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:self]) {
            return (YDProgressHUD *)subview;
        }
    }
    return nil;
}

#pragma mark - 开始/结束 加载
+ (void)loadingAnimation:(YDProgressHUD *)loadView
{
    // YDShowModeNetwork 不需要动画效果
    if (loadView.showMode == YDShowModeNetwork) {
        return;
    }
    
    loadView.backBezelView.transform = CGAffineTransformMakeScale(0.4, 0.4);
    
    [UIView animateWithDuration:.2 animations:^{
        loadView.backBezelView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }];
}

- (void)reloadHUD:(YDReloadBlock)reloadBlock
{
    self.reloadBlock = reloadBlock;
}

+ (instancetype)startLoadingBlock:(LoadingBlock)loadBlock
{
    YDMainThreadAssert();
    
    YDProgressHUD *loadingView = [[YDProgressHUD alloc] initWithBlock:loadBlock];
    [loadingView.supView addSubview:loadingView];
    
    if (loadingView.isAnimation) {
        [self loadingAnimation:loadingView];
    }
    
    return loadingView;
}

+ (void)stopLoadingKeyWindow
{
    UIView *window = [UIApplication sharedApplication].keyWindow;
    [self stopLoading:window];
}

+ (void)stopNetLoading:(UIView *)supView status:(YDStopLoadStatus)status
{
    YDMainThreadAssert();
    
    YDProgressHUD *loadingView = [self progressHUDForView:supView];
    
    switch (status) {
        case YDStopLoadSuccess: {
            [self stopLoading:supView];
        }
            break;
        case YDStopLoadEmtyp: {
            [loadingView.loadImgView loadStopWithImg:loadingView.emptyImgName];
            [loadingView layoutViewFrame:loadingView.emptyLoadTitle stop:YES];
            loadingView.backBezelView.userInteractionEnabled = YES;
        }
            break;
        case YDStopLoadFaiure: {
            [loadingView.loadImgView loadStopWithImg:loadingView.errorImgName];
            [loadingView layoutViewFrame:loadingView.errorLoadTitle stop:YES];
            loadingView.backBezelView.userInteractionEnabled = YES;
        }
            break;
    }
}

+ (void)stopLoading:(UIView *)supView
{
    YDMainThreadAssert();
    
    YDProgressHUD *loadingView = [self progressHUDForView:supView];
    
    YDStopErrorAssert();
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(loadingView.hideDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (loadingView.loadMode == YDProgressModeDefault) {
            [loadingView.indicatorView stopAnimating];
        }else if (loadingView.loadMode == YDProgressModeImages) {
            [loadingView.loadImgView loadStopAnimating];
        }
        
        [loadingView removeFromSuperview];
    });
}

#pragma mark - 初始化
- (instancetype)initWithBlock:(LoadingBlock)block
{
    if (self = [super init]) {
        // 1. 先初始化默认数据
        [self initDefaultData];
        // 2. 回调block，刷新数据
        if (block) { block(self); }
        // 3. 布局，计算rect
        [self layoutViewFrame:self.warnningTitle stop:NO];
        // 4. 根据显示模式，判断是否添加点击手势
        [self bezelAddGesture];
    }
    return self;
}

#pragma mark - 默认的初始化数据
- (void)initDefaultData
{
    self.supView = [UIApplication sharedApplication].keyWindow;
    
    self.loadMode = YDProgressModeDefault;
    self.showMode = YDShowModeBackBezel;
    
    self.hideDelay = 0.0;
    
    self.msgMode = YDMessageModeShow;
    
    self.labelSpace = 5.0;
    self.duration = 1.0;
    self.isAnimation = YES;
    self.indicatorWH = 45;
    
    self.warnningTitle = @"正在加载...";
    self.titleFont = [UIFont systemFontOfSize:16.0];
    self.titleColor = [UIColor whiteColor];
    
    self.errorImgName = @"network_error";
    self.emptyImgName = @"network_empty";
    self.errorLoadTitle = @"网络加载失败，点击重新加载";
    self.emptyLoadTitle = @"不好意思，当前没有数据";
}

#pragma mark - 给背景档板添加点击手势
- (void)bezelAddGesture
{
    /**
     * YDShowModeNetwork模式：档板隐藏（设置透明色）, 添加点击手势
     *
     * 注: 外部可以访问 backBezelView 会调用对应的getter方法
     *    外部调用backBezelView比设置showMode早，在getter方法中判断是否添加手势会出现问题
     *    单独设置一个方法在调用Blok重置数据后进行设置
     *
     */
    if (self.showMode == YDShowModeNetwork) {
        
        self.backBezelView.userInteractionEnabled = NO;
        
        self.backBezelView.backgroundColor = [UIColor clearColor];
        
        UITapGestureRecognizer *bezelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reloadTap:)];
        [self.backBezelView addGestureRecognizer:bezelTap];
    }
}

#pragma mark - 计算子视图的Frame
- (CGSize)rectWithString:(NSString *)string size:(CGSize)maxSize font:(UIFont *)font
{
    return [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
}

/**
 * isStop: 判断是开始加载，还是结束加载。
 */
- (void)layoutViewFrame:(NSString *)warnningTitle stop:(BOOL)isStop
{
    self.frame = self.supView.bounds;
    
    CGFloat lastH, lastW;

    if (self.msgMode == YDMessageModeShow ||
        (self.msgMode == YDMessageModeShowWhenStop && isStop)) {
        
        CGSize lblSize = [self rectWithString:warnningTitle size:CGSizeMake(self.yd_width - 50, 200) font:self.warnningLbl.font];
        lastH = lblSize.height + self.indicatorWH + 25 + self.labelSpace;
        lastW = (lblSize.width + 40) < lastH ? lastH : lblSize.width + 40;
        
        self.warnningLbl.hidden = NO;
        self.warnningLbl.frame = CGRectMake(0, lastH - lblSize.height - 13, lastW, lblSize.height);
        self.warnningLbl.text = warnningTitle;
        
    }else {
        self.warnningLbl.hidden = YES;
        lastH = self.indicatorWH + 24;
        lastW = self.indicatorWH + 24;
    }
    
    self.backBezelView.frame = CGRectMake(self.yd_width * 0.5 - lastW * 0.5, self.yd_height * 0.5 - lastH * 0.5 - 10, lastW, lastH);
    
    CGRect loadAnimRect = CGRectMake(lastW * 0.5 - self.indicatorWH * 0.5, 12, self.indicatorWH, self.indicatorWH);
    
    if (self.loadMode == YDProgressModeImages) {
        self.loadImgView.frame = loadAnimRect;
    }else if (self.loadMode == YDProgressModeDefault){
        self.indicatorView.frame = loadAnimRect;
    }else {
        self.customView.frame = loadAnimRect;
        [self.backBezelView addSubview:self.customView];
    }
}

#pragma mark - UI事件
// 点击重现刷新
- (void)reloadTap:(UITapGestureRecognizer *)tap
{
    YDReloadAssert();
    
    // 开始回调处理
    self.reloadBlock(self);
    
    // 重新开始加载动画
    self.backBezelView.userInteractionEnabled = NO;
    
    [self layoutViewFrame:self.warnningTitle stop:NO];
    
    if (self.loadMode == YDProgressModeImages) {
        [self.loadImgView loadStartAnimating];
    }else if (self.loadMode == YDProgressModeDefault) {
        [self.indicatorView startAnimating];
    }
}

#pragma mark - 懒加载
- (UIView *)backBezelView
{
    if (_backBezelView == nil) {
        _backBezelView = [[UIView alloc] init];
        _backBezelView.layer.cornerRadius = 6.0f;
        _backBezelView.layer.masksToBounds = YES;
        _backBezelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        [self addSubview:_backBezelView];
    }
    return _backBezelView;
}

- (UILabel *)warnningLbl
{
    if (_warnningLbl == nil) {
        _warnningLbl = [[UILabel alloc] init];
        _warnningLbl.numberOfLines = 0;
        _warnningLbl.textAlignment = NSTextAlignmentCenter;
        _warnningLbl.textColor = self.titleColor;
        _warnningLbl.font = self.titleFont;
        [self.backBezelView addSubview:_warnningLbl];
    }
    
    return _warnningLbl;
}

- (UIActivityIndicatorView *)indicatorView
{
    if (_indicatorView == nil) {
        _indicatorView = [[UIActivityIndicatorView alloc] init];
        _indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        _indicatorView.backgroundColor = [UIColor clearColor];
        [_indicatorView startAnimating];
        [self.backBezelView addSubview:_indicatorView];
    }
    
    return _indicatorView;
}

- (YDProgressImgae *)loadImgView
{
    if (_loadImgView == nil) {
        _loadImgView = [[YDProgressImgae alloc] init];
        _loadImgView.contentMode = UIViewContentModeScaleAspectFit;
        // 1.设置好相关数据
        _loadImgView.imgArray = self.imgArray;
        _loadImgView.duration = self.duration;
        // 2.再开始动画
        [_loadImgView loadStartAnimating];
        
        [self.backBezelView addSubview:_loadImgView];
    }
    return _loadImgView;
}

@end





















