//
//  YDProgressImgae.h
//  加载进度条
//
//  Created by iOS on 2018/4/4.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YDProgressImgae : UIImageView

// 动画图片数组
@property (nonatomic, strong) NSArray *imgArray;
// 动画时长
@property (nonatomic, assign) NSTimeInterval duration;

// 开始动画
- (void)loadStartAnimating;
// 结束动画
- (void)loadStopAnimating;
// 结束动画
- (void)loadStopWithImg:(NSString *)imgName;

@end
