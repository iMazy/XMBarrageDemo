//
//  ViewController.m
//  XMBarrageDemo
//
//  Created by TwtMac on 16/11/9.
//  Copyright © 2016年 Mazy. All rights reserved.
//

#import "ViewController.h"
#import "XMBarrageView.h"
#import "XMBarrageManager.h"
#import "XMCommentModel.h"

@interface ViewController ()
/** 弹幕管理者 */
@property(nonatomic,strong)XMBarrageManager *barrageManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // 初始化弹幕管理者
    self.barrageManager = [[XMBarrageManager alloc] init];
    
    NSArray *tempDataArray = @[@{@"comment":@"love我",@"icon":@"http://img.ivsky.com/img/tupian/slides/201608/15/maitian_jingse.jpg"},
                               @{@"comment":@"一个人,下午茶吃起,玩起~~~",@"icon":@"http://imgsrc.baidu.com/forum/w%3D580/sign=25bd4588ebc4b7453494b71efffd1e78/0a7b02087bf40ad14d310442572c11dfa8eccebe.jpg"},
                               @{@"comment":@"幸福来得太突然~~~~~~",@"icon":@"http://img2.3lian.com/2014/f2/179/d/94.jpg"},
                               @{@"comment":@"哈哈~~~~~",@"icon":@"http://img4.duitang.com/uploads/item/201204/19/20120419090905_VNtV5.jpeg"},
                               @{@"comment":@"不错,有弹幕,好玩",@"icon":@"http://img2.3lian.com/2014/f2/179/d/95.jpg"},
                               @{@"comment":@"有人吗~~~~~~~~~",@"icon":@"http://imgsrc.baidu.com/forum/w%3D580/sign=903a17eadab44aed594ebeec831d876a/a8425acf3bc79f3deefef090baa1cd11738b29f5.jpg"},
                               @{@"comment":@"哇塞",@"icon":@"http://img5.duitang.com/uploads/item/201406/26/20140626094111_ireAS.png"},
                               @{@"comment":@"嘿嘿嘿~~~",@"icon":@"http://diy.qqjay.com/u/files/2012/0615/e08611ace0b1b6e310b4ab451aa83926.jpg"},
                               @{@"comment":@"能不能不这么卡~~~~~~~~~~",@"icon":@"http://img2.3lian.com/2014/f2/179/d/93.jpg"},
                               @{@"comment":@"我来了~~~~~~",@"icon":@"http://www.qqzhuangban.com/uploadfile/2014/12/2/20141222072053635.jpg"},
                               @{@"comment":@"能不能安静点~~~",@"icon":@"http://img2.3lian.com/2014/f2/179/d/100.jpg"},
                               @{@"comment":@"好帅~~~~~~~~~",@"icon":@"http://img2.duitang.com/uploads/item/201211/12/20121112163131_Ek4Ce.jpeg"}
                               ];
    
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

}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
