//
//  MyMoneyVC.m
//  BeautyCollege
//
//  Created by 于洲 on 15/6/4.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "MyMoneyVC.h"

@interface MyMoneyVC ()
{
    UIImageView         *_logo;
    UIScrollView        *_scrollView;
}
@end

@implementation MyMoneyVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self buildFootView];
}

- (void)buildFootView
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, UI_SCREEN_HEIGHT - 35, UI_SCREEN_WIDTH, 35);
    [btn setTitle:@"美币兑换" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.view addSubview:btn];
}

- (void)loadData
{
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 122)];
    [img setImage:[UIImage imageNamed:@"a.png"]];
    [self.view addSubview:img];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake((UI_SCREEN_WIDTH - 150) / 2.0, 20, 150, 44);
    label.text = @"我的美币";
    label.font = [UIFont boldSystemFontOfSize:22];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(10, 26, 30, 30);
    [backBtn setImage:[UIImage imageNamed:@"back_03.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    NSArray *array = @[@"我的积分",@"我的美币"];
    for (NSInteger i = 0; i < 2; i ++) {
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake((UI_SCREEN_WIDTH / 2.0) * i, img.bottom + 20, UI_SCREEN_WIDTH / 2.0, 20)];
        label1.text = @"123123";
        label1.textColor = BaseColor;
        label1.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:label1];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(label1.left, label1.bottom, label1.width, 20)];
        label2.text = array[i];
        label2.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:label2];
    }
    _logo = [[UIImageView alloc] initWithFrame:CGRectMake((UI_SCREEN_WIDTH - 80) / 2.0, img.bottom - 40, 80, 80)];
    [_logo setImage:[UIImage imageNamed:@"default_avatar.png"]];
    _logo.layer.borderColor = [UIColor whiteColor].CGColor;
    _logo.layer.borderWidth = 2.0;
    _logo.layer.cornerRadius = 40;
    _logo.layer.masksToBounds = YES;
    [self.view addSubview:_logo];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, img.bottom + 20 + 48, UI_SCREEN_WIDTH, 2)];
    lineView.backgroundColor = BaseColor;
    [self.view addSubview:lineView];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, lineView.bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - lineView.bottom - 35)];
    _scrollView.backgroundColor = ColorWithRGBA(218.0, 225.0, 227.0, 1);
    [self.view addSubview:_scrollView];
    
    UIImageView *img1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, UI_SCREEN_WIDTH, 220)];
    [img1 setImage:[[UIImage imageNamed:@"coursebg_16.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)]];
    [_scrollView addSubview:img1];
    
    NSArray *titleArr = @[@"创建课堂",@"写作业",@"评论点赞作业",@"作业推荐/置顶",@"课堂推荐"];
    for (NSInteger i = 0; i < 5; i ++) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, img1.top + 20 + 40 * i, 110, 20)];
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.text = titleArr[i];
        [_scrollView addSubview:titleLabel];
        
        UILabel *integralLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.right + 40, titleLabel.top, 80, 20)];
        integralLabel.textColor = BaseColor;
        integralLabel.text = @"1000积分";
        integralLabel.font = [UIFont systemFontOfSize:15];
        [_scrollView addSubview:integralLabel];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, integralLabel.bottom + 9.5, UI_SCREEN_WIDTH, 0.5)];
        view.backgroundColor = [UIColor grayColor];
        [_scrollView addSubview:view];
    }
    
    UIImageView *img2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, img1.bottom + 20, UI_SCREEN_WIDTH, 40)];
    [img2 setImage:[UIImage imageNamed:@"coursebg_16.png"]];
    [_scrollView addSubview:img2];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(10, img2.top + 10, 100, 20)];
    label2.textColor = [UIColor grayColor];
    label2.text = @"其他奖励";
    label2.font = [UIFont systemFontOfSize:15];
    [_scrollView addSubview:label2];
    
    UILabel *Lable3 = [[UILabel alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH - 200, img2.bottom + 10, 190, 20)];
    Lable3.font = [UIFont systemFontOfSize:15];
    Lable3.textColor = BaseColor;
    Lable3.text = @"如何赚取积分？";
    Lable3.textAlignment = NSTextAlignmentRight;
    [_scrollView addSubview:Lable3];
}


- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
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
