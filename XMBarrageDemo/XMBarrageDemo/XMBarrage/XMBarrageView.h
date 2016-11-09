//
//  XMBarrageView.h
//  XMBarrageDemo
//
//  Created by TwtMac on 16/11/9.
//  Copyright © 2016年 Mazy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XMCommentModel;

// 弹幕状态枚举
typedef NS_ENUM(NSInteger, barrageStatus) {
    Start, // 开始进入屏幕
    Enter, // 完全进入屏幕
    End    // 离开屏幕
};

@interface XMBarrageView : UIView
/** 弹道 */
@property(nonatomic,assign)NSInteger trajectory;
/** 弹幕状态回调 */
@property(nonatomic,copy)void(^barrageStatusBlock)(barrageStatus status);

// 初始化弹幕
- (instancetype)initWithComment:(XMCommentModel *)commentModel;
// 开始动画
- (void)startAnimation;
// 结束动画
- (void)stopAnimation;

@end
