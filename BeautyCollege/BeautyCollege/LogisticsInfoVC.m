//
//  LogisticsInfoVC.m
//  BeautyCollege
//
//  Created by 于洲 on 15/6/4.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "LogisticsInfoVC.h"

@interface LogisticsInfoVC ()

@end

@implementation LogisticsInfoVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationItem.title = @"物流信息";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(15, 64 + 15, UI_SCREEN_WIDTH - 30, 150)];
    [img setImage:[UIImage imageNamed:@"blank_num.png"]];
    [self.view addSubview:img];

    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(img.left + 10, img.top + 10, img.width - 20, 30)];
    label1.text = [NSString stringWithFormat:@"订单号:%@",_logisticsInfo.orderNo];
    [self.view addSubview:label1];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(img.left, label1.bottom + 10, img.width, 0.5)];
    lineView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:lineView];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(label1.left, lineView.bottom + 10, label1.width, 30)];
    label2.text = [NSString stringWithFormat:@"快递公司:%@",_logisticsInfo.express];
    [self.view addSubview:label2];

    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(lineView.left, label2.bottom + 10, lineView.width, 0.5)];
    lineView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:lineView2];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(label1.left, lineView2.bottom + 10, label1.width, 30)];
    label3.text = [NSString stringWithFormat:@"订单号:%@",_logisticsInfo.expressNo];
    [self.view addSubview:label3];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
