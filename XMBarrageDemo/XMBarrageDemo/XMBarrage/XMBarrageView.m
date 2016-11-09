//
//  XMBarrageView.m
//  XMBarrageDemo
//
//  Created by TwtMac on 16/11/9.
//  Copyright © 2016年 Mazy. All rights reserved.
//

#import "XMBarrageView.h"
#import "XMCommentModel.h"

#define padding 10
#define iconHeight 50
#define screenWidth [UIScreen mainScreen].bounds.size.width

@interface XMBarrageView ()

/** 评论label */
@property(nonatomic,strong)UILabel *commentLabel;

/** 图像 */
@property(nonatomic,strong)UIImageView *iconImageView;

@end

@implementation XMBarrageView

// 评论label
- (UILabel *)commentLabel {
    if (!_commentLabel) {
        _commentLabel = [[UILabel alloc] init];
        _commentLabel.font = [UIFont systemFontOfSize:14];
        _commentLabel.textColor = [UIColor whiteColor];
        _commentLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_commentLabel];
    }
    return _commentLabel;
}

// 图像
- (UIImageView *)iconImageView {
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.layer.cornerRadius = 25;
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.layer.borderWidth = 1.0;
        _iconImageView.layer.borderColor = [UIColor greenColor].CGColor;
        [self addSubview:_iconImageView];
    }
    return _iconImageView;
}

// 初始化弹幕
- (instancetype)initWithComment:(XMCommentModel *)commentModel
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        
        NSDictionary *attri = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
        CGFloat width = [commentModel.comment sizeWithAttributes:attri].width;
        self.bounds = CGRectMake(0, 0, width+2*padding+iconHeight, 30);
        
        self.commentLabel.text = commentModel.comment;
        self.commentLabel.frame = CGRectMake(padding+iconHeight, 0, width, 30);
        
        self.iconImageView.frame = CGRectMake(0, -padding, iconHeight, iconHeight);
        
        // 异步下载图片
        NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:commentModel.iconImageURL] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            UIImage *image = [UIImage imageWithData:data];
            // 回到主线程添加图片到ImageView上
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                self.iconImageView.image = image;
            }];
        }];
        [dataTask resume];
        
        
        // 设置自己的圆角
        self.layer.cornerRadius = 15;
    }
    return self;
}

// 开始动画
- (void)startAnimation {
    
    self.frame = CGRectMake(screenWidth, 100 + self.trajectory*60, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    
    // 根据弹幕长度执行动画效果
    // 根据 v = s/t, 时间相同情况下,距离越长,速度越快
    
    CGFloat duration = 5.0;
    CGFloat wholeWidth = screenWidth + CGRectGetWidth(self.bounds);
    
    // 弹幕开始
    if (self.barrageStatusBlock) {
        self.barrageStatusBlock(Start);
    }
    
    CGFloat speed = wholeWidth/duration;
    // 计算弹幕完全进入屏幕所需时间
    CGFloat enterDuration = CGRectGetWidth(self.bounds)/speed;
    [self performSelector:@selector(enterScreenAction) withObject:nil afterDelay:enterDuration+0.2];
    
    // UIView动画
    __block CGRect frame = self.frame;
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        frame.origin.x -= wholeWidth;
        self.frame = frame;
    } completion:^(BOOL finished) {
        // 离开屏幕
        [self removeFromSuperview];
        if (self.barrageStatusBlock) {
            self.barrageStatusBlock(End);
        }
    }];
}

// 完全进入屏幕
- (void)enterScreenAction {
    if (self.barrageStatusBlock) {
        self.barrageStatusBlock(Enter);
    }
}

// 结束动画
- (void)stopAnimation {
    // 取消 performSelector: withObject: afterDelay:
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    // 移除所有动画
    [self.layer removeAllAnimations];
    [self removeFromSuperview];
}


@end
