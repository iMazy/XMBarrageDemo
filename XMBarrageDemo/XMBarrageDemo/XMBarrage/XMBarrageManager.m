//
//  XMBarrageManager.m
//  XMBarrageDemo
//
//  Created by TwtMac on 16/11/9.
//  Copyright © 2016年 Mazy. All rights reserved.
//

#import "XMBarrageManager.h"
#import "XMBarrageView.h"

@interface XMBarrageManager ()

/** 弹幕使用过程中的数组变量 */
@property(nonatomic,strong)NSMutableArray *barrageComments;

/** 存储弹幕View的数组变量 */
@property(nonatomic,strong)NSMutableArray *barrageViews;

/** 存储弹幕弹道 */
@property(nonatomic,strong)NSMutableArray *trajectorys;

/** 监控状态 */
@property(nonatomic,assign)BOOL stopAnimation;

@end

@implementation XMBarrageManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.stopAnimation = YES;
    }
    return self;
}

-(NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

-(NSMutableArray *)barrageViews {
    if (_barrageViews == nil) {
        _barrageViews = [NSMutableArray array];
    }
    return _barrageViews;
}

-(NSMutableArray *)barrageComments {
    if (_barrageComments == nil) {
        _barrageComments = [NSMutableArray array];
    }
    return _barrageComments;
}

// 弹幕开始执行
- (void)start {
    
    if (self.stopAnimation) {
        self.stopAnimation = NO;
        [self.barrageComments removeAllObjects];
        [self.barrageComments addObjectsFromArray:self.dataSource];
        
        [self initBarrageComments];
    }
}

// 初始化弹幕,随机分配弹幕轨迹
- (void)initBarrageComments {
    
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 0; i < self.barragesCount; i++) {
        [tempArray addObject:@(i)];
    }
    self.trajectorys = tempArray;
    
    for (int i = 0; i < self.barragesCount; i++) {
        
        if (self.barrageComments.count > 0) {
            
            // 通过随机数取出弹道的轨迹
            NSInteger index = arc4random()%self.trajectorys.count;
            
            NSInteger trajectory = [[self.trajectorys objectAtIndex:index] integerValue];
            
            [self.trajectorys removeObjectAtIndex:index];
            
            // 从弹幕数组中,逐一取出弹幕数据
            XMCommentModel *commentModel = [self.barrageComments firstObject];
            [self.barrageComments removeObjectAtIndex:0];
            
            // 创建弹幕VIEW
            [self createBarrageView:commentModel trajectory:trajectory];
        }
        
    }
}

- (void)createBarrageView:(XMCommentModel *)commentModel trajectory:(NSInteger)trajectory {
    
    if (self.stopAnimation) {
        return;
    }
    
    XMBarrageView *barrageView = [[XMBarrageView alloc] initWithComment:commentModel];
    barrageView.trajectory = trajectory;
    [self.barrageViews addObject:barrageView];
    
    [barrageView startAnimation];
    
    __weak typeof(barrageView) weakBarrageView = barrageView;
    __weak typeof(self) weakSelf = self;
    barrageView.barrageStatusBlock = ^(barrageStatus status){
        if (self.stopAnimation) {
            return ;
        }
        switch (status) {
            case Start:{
                // 弹幕开始进入屏幕,将View添加到弹幕管理的变量中barragesViews
                [weakSelf.barrageViews addObject:weakBarrageView];
                break;
            }
            case Enter: {
                // 弹幕完全进入屏幕中,判断是否还有其他内容,如果有,则再改弹道轨迹中创建一个弹幕
                XMCommentModel *nextCommentModel = [self nextCommentModel];
                if (nextCommentModel) {
                    [weakSelf createBarrageView:nextCommentModel trajectory:trajectory];
                }
                break;
            }
            case End:{
                // 当弹幕飞出屏幕后,从barragesView中删除,释放资源
                if ([weakSelf.barrageViews containsObject:weakBarrageView]) {
                    [weakBarrageView stopAnimation];
                    [weakSelf.barrageViews removeObject:weakBarrageView];
                }
                
                if (weakSelf.barrageViews.count==0) {
                    // 说明屏幕上已经没有弹幕了,开始循环滚动
                    self.stopAnimation = YES;
                    
                    [weakSelf start];
                }
                break;
            }
            default:
                break;
        }
    };
    
    if (self.generateViewBlock) {
        self.generateViewBlock(barrageView);
    }
}

- (XMCommentModel *)nextCommentModel {
    if (self.barrageComments.count == 0) {
        return nil;
    }
    XMCommentModel *model = self.barrageComments.firstObject;
    if (model) {
        [self.barrageComments removeObject:model];
    }
    return model;
}

// 弹幕停止执行
- (void)stop {
    if (self.stopAnimation) {
        return;
    }
    self.stopAnimation = YES;
    [self.barrageViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        XMBarrageView *view = obj;
        [view stopAnimation];
        view = nil;
    }];
    [self.barrageViews removeAllObjects];
}


@end
