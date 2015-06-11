//
//  MyMoneyVC.m
//  BeautyCollege
//
//  Created by 于洲 on 15/6/4.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "MyMoneyVC.h"
#import "MNhelperVC.h"

@interface MyMoneyVC ()
{
    UIImageView         *_logo;
    UIScrollView        *_scrollView;

    NSMutableArray      *_labelArr;
    NSMutableArray      *_countArr;
    
    UILabel             *_myPointsLabel;
    NSString            *_myPoints;
    
    UILabel             *_myMoney;
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
    [self initGUI];
//    [self buildFootView];
    
    [self loadData];
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
    NSString *str = [NSString stringWithFormat:@"mobi/user/getPoints?memberId=%@",[User shareUser].userId];
    [[tools shared] HUDShowText:@"正在加载..."];
    [[HttpManager shareManger] getWithStr:str ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
        [[tools shared] HUDHide];
        if ([[json  objectForKey:@"code"] integerValue] == 0) {
            
            NSDictionary *dic = nilOrJSONObjectForKey(json, @"result");
            NSDictionary *ScoreDetail = nilOrJSONObjectForKey(dic, @"ScoreDetail");
            _myPoints = [MyTool getValuesFor:ScoreDetail key:@"totalScore"];
            _myMoney.text = [MyTool getValuesFor:dic key:@"nowMB"];
                //创建课堂积分
            NSString *createLessonScore = [MyTool getValuesFor:ScoreDetail key:@"createLessonScore"];
                //创建作业积分
            NSString *createBlogScore = [MyTool getValuesFor:ScoreDetail key:@"createBlogScore"];
                //点赞
            NSString *doGoodScore = [MyTool getValuesFor:ScoreDetail key:@"doGoodScore"];
                //置顶
            NSString *blogRecommendScore = [MyTool getValuesFor:ScoreDetail key:@"blogRecommendScore"];
                //
            NSString *lessonUpdateScore = [MyTool getValuesFor:ScoreDetail key:@"lessonUpdateScore"];
            _countArr = [[NSMutableArray alloc] initWithObjects:createLessonScore,createBlogScore,doGoodScore,blogRecommendScore,lessonUpdateScore, nil];
            [self updateGUI];
        }else {
            [[tools shared] HUDShowHideText:@"加载失败" delay:1.0];
        }
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

- (void)updateGUI
{
    _myPointsLabel.text = _myPoints;
    
    for (UILabel *Label in _labelArr) {
        NSInteger i = [_labelArr indexOfObject:Label];
        Label.text = [NSString stringWithFormat:@"%@积分",_countArr[i]];
    }
}

- (void)initGUI
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
        label1.text = @"0";
        label1.textColor = BaseColor;
        label1.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:label1];
        if (i == 0) {
            
            _myPointsLabel = label1;
        }
        
        if (i == 1) {
            _myMoney = label1;
        }
        
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
    [MyTool setImgWithURLStr:[User shareUser].logo withplaceholderImage:[UIImage imageNamed:@"default_avatar.png"] withImgView:_logo];
    [self.view addSubview:_logo];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, img.bottom + 20 + 48, UI_SCREEN_WIDTH, 2)];
    lineView.backgroundColor = BaseColor;
    [self.view addSubview:lineView];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, lineView.bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - lineView.bottom)];
    _scrollView.backgroundColor = ColorWithRGBA(218.0, 225.0, 227.0, 1);
    [self.view addSubview:_scrollView];
    
    UIImageView *img1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, UI_SCREEN_WIDTH, 220)];
    [img1 setImage:[[UIImage imageNamed:@"coursebg_16.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)]];
    [_scrollView addSubview:img1];
    
    _labelArr = [[NSMutableArray alloc] initWithCapacity:5];
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
        [_labelArr addObject:integralLabel];
    }
    
    UIImageView *img2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, img1.bottom + 20, UI_SCREEN_WIDTH, 40)];
    [img2 setImage:[UIImage imageNamed:@"coursebg_16.png"]];
    [_scrollView addSubview:img2];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(10, img2.top + 10, 100, 20)];
    label2.textColor = [UIColor grayColor];
    label2.text = @"其他奖励";
    label2.font = [UIFont systemFontOfSize:15];
    [_scrollView addSubview:label2];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    btn.frame = CGRectMake(UI_SCREEN_WIDTH - 200, img2.bottom + 10, 190, 20);
    [btn setTitle:@"如何获取积分" forState:UIControlStateNormal];
    [btn setTitleColor:BaseColor forState:UIControlStateNormal];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:btn];
    
    _scrollView.contentSize = CGSizeMake(UI_SCREEN_WIDTH, btn.bottom + 30);
}

- (void)btnClick
{
    MNhelperVC *vc = [[MNhelperVC alloc] init];
//    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
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
