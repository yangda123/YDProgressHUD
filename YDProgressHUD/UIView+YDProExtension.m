//
//  UIView+YDProExtension.m
//  加载进度条
//
//  Created by iOS on 2018/4/4.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "UIView+YDProExtension.h"

@implementation UIView (YDProExtension)

- (void)setYd_x:(CGFloat)yd_x
{
    CGRect frame = self.frame;
    frame.origin.x = yd_x;
    self.frame = frame;
}

- (void)setYd_y:(CGFloat)yd_y
{
    CGRect frame = self.frame;
    frame.origin.y = yd_y;
    self.frame = frame;
}

- (void)setYd_width:(CGFloat)yd_width
{
    CGRect frame = self.frame;
    frame.size.width = yd_width;
    self.frame = frame;
}

- (void)setYd_height:(CGFloat)yd_height
{
    CGRect frame = self.frame;
    frame.size.height = yd_height;
    self.frame = frame;
}

- (CGFloat)yd_x
{
    return self.frame.origin.x;
}

- (CGFloat)yd_y
{
    return self.frame.origin.y;
}

- (CGFloat)yd_width
{
    return self.frame.size.width;
}

- (CGFloat)yd_height
{
    return self.frame.size.height;
}

- (CGFloat)yd_centerX
{
    return self.center.x;
}

- (void)setYd_centerX:(CGFloat)yd_centerX
{
    CGPoint center = self.center;
    center.x = yd_centerX;
    self.center = center;
}

- (CGFloat)yd_centerY
{
    return self.center.y;
}

- (void)setYd_centerY:(CGFloat)yd_centerY
{
    CGPoint center = self.center;
    center.y = yd_centerY;
    self.center = center;
}

- (void)setYd_size:(CGSize)yd_size
{
    CGRect frame = self.frame;
    frame.size = yd_size;
    self.frame = frame;
}

- (CGSize)yd_size
{
    return self.frame.size;
}

- (CGFloat)yd_right
{
    return CGRectGetMaxX(self.frame);
}

- (void)setYd_right:(CGFloat)yd_right
{
    self.yd_x = yd_right - self.yd_width;
}

- (CGFloat)yd_bottom
{
    return CGRectGetMaxY(self.frame);
}

- (void)setYd_bottom:(CGFloat)yd_bottom
{
    self.yd_y = yd_bottom - self.yd_height;
}

@end


















