//
//  XMBarrageManager.h
//  XMBarrageDemo
//
//  Created by TwtMac on 16/11/9.
//  Copyright © 2016年 Mazy. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XMBarrageView;

@interface XMBarrageManager : NSObject

/** 开始生成弹幕视图block */
@property(nonatomic,copy)void(^generateViewBlock)(XMBarrageView *view);

/** 弹幕的数据源(存放字符型的数组) */
@property(nonatomic,strong)NSMutableArray *dataSource;
/** 弹幕的行数 */
@property(nonatomic,assign)NSInteger barragesCount;

// 弹幕开始执行
- (void)start;

// 弹幕停止执行
- (void)stop;

@end
