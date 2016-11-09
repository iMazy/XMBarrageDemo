# XMBarrageDemo
A demo for barrage on screen.
一个关于弹幕的简单demo,封装了部分代码,传入指定评论模型即可完成弹幕效果.

备注:这里的图片下载,为了实现代码的低耦合,没有使用第三方SDWebImage,可自行修改为用SDWebImage下载图片资源.

***

###GIF示例:
![image](https://github.com/Mazy-ma/XMBarrageDemo/blob/master/XMBarrageDemo/XMBarrageDemo/demo.gif)

***
###具体使用


```
// 弹幕视图
#import "XMBarrageView.h"
// 弹幕管理者
#import "XMBarrageManager.h"
// 评论模型
#import "XMCommentModel.h"

```

```
    // 初始化弹幕管理者
    self.barrageManager = [[XMBarrageManager alloc] init];

    // 模拟添加数据源数组
    for (NSDictionary *dict in tempDataArray) {
        XMCommentModel *model = [[XMCommentModel alloc] init];
        model.comment = dict[@"comment"];
        model.iconImageURL = dict[@"icon"];
        [self.barrageManager.dataSource addObject:model];
    }
    
    // 设置一共显示多少行弹幕
    self.barrageManager.barragesCount = 5;
    
    // 生成弹幕view时回调,将弹幕view添加到视图上
    __weak typeof(self) weakSelf = self;
    self.barrageManager.generateViewBlock = ^(XMBarrageView *view) {
        [weakSelf.view addSubview:view];
    };
    
    // 开启弹幕 
    [self.barrageManager start];
    
    // 取消弹幕 
    [self.barrageManager stop];
    
```
