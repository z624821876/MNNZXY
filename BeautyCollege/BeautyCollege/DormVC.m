//
//  DormVC.m
//  BeautyCollege
//
//  Created by 于洲 on 15/4/15.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "DormVC.h"
#import "SetVC.h"
#import "MNhelperVC.h"
#import "UserInfoVC.h"
#import "AddressList.h"
#import "ShareVC.h"
#import "OrderLIstVC.h"
#import "ShoppingcartVC.h"
#import "CollectionVC.h"
#import "LessonsVC.h"
#import "HomeworkVC.h"
#import "ChatVC.h"
#import "InvitefriendsVC.h"
#import "MyLessonsVC.h"
#import "MyhomewroksVC.h"
#import "MyMessagesVC.h"

@interface DormVC ()
@property (nonatomic, strong) BaseCellModel     *userInfo;

@property (nonatomic, strong) NSString          *myLessonCount;
@property (nonatomic, strong) NSString          *joinLessonCount;
@property (nonatomic, strong) NSString          *myHomeorkCount;
@property (nonatomic, strong) NSString          *RepCount;
@property (nonatomic, strong) NSString          *likeCount;

@property (nonatomic, strong) NSMutableArray    *myLessonArr;
@property (nonatomic, strong) NSMutableArray    *joinLessonArr;
@property (nonatomic, strong) NSMutableArray    *myHomeorkArr;
@property (nonatomic, strong) NSMutableArray    *RepArr;
@property (nonatomic, strong) UIButton          *currentBtn;

@property (nonatomic, strong) UIView            *lineView;

@property (nonatomic, strong) NSArray           *titleArray1;
@property (nonatomic, strong) NSArray           *titleArray2;

@end

@implementation DormVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    if (![MyTool isLogin] && ([AppDelegate shareApp].mainTabBar.selectedIndex == 4)) {
        LoginVC *vc = [[LoginVC alloc] init];
        vc.type = 1;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        [self getUserDetail];

    }
}

- (void)getUserDetail
{
    NSString *str = [NSString stringWithFormat:@"mobi/user/getUserDetail?memberId=%@&selfId=",[User shareUser].userId];
    [[HttpManager shareManger] getWithStr:str ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
        if ([[json objectForKey:@"code"] integerValue] == 0) {
            
            [_myLessonArr removeAllObjects];
            [_joinLessonArr removeAllObjects];
            [_myHomeorkArr removeAllObjects];
            NSDictionary *resultDic = [json objectForKey:@"result"];
            NSNumber *numer1 = nilOrJSONObjectForKey(resultDic, @"myLessonCount");
            _myLessonCount = [numer1 stringValue];
            NSNumber *numer2 = nilOrJSONObjectForKey(resultDic, @"joinLessonCount");
            _joinLessonCount = [numer2 stringValue];
            NSNumber *numer3 = nilOrJSONObjectForKey(resultDic, @"myHomeorkCount");
            _myHomeorkCount = [numer3 stringValue];
            NSNumber *numer4 = nilOrJSONObjectForKey(resultDic, @"newRepCount");
            _RepCount = [numer4 stringValue];
            NSNumber *number5 = nilOrJSONObjectForKey(resultDic, @"likeCount");
            _likeCount = [number5 stringValue];
//            NSDictionary *memberDic = nilOrJSONObjectForKey(resultDic, @"member");
            NSArray *myLessonListArr = nilOrJSONObjectForKey(resultDic, @"myLessonList");
            NSArray *joinLessonListArr = nilOrJSONObjectForKey(resultDic, @"joinLessonList");
            NSArray *myHomeworkListArr = nilOrJSONObjectForKey(resultDic, @"myHomeworkList");
            if (myLessonListArr) {
                for (NSDictionary *dic in myLessonListArr) {
                    BaseCellModel *model = [[BaseCellModel alloc] init];
                    model.title = nilOrJSONObjectForKey(dic, @"title");
                    model.logo = nilOrJSONObjectForKey(dic, @"image");
                    model.name = nilOrJSONObjectForKey(dic, @"createName");
                    model.modelId = nilOrJSONObjectForKey(dic, @"id");
                    NSString *time = nilOrJSONObjectForKey(dic, @"createTime");
                    model.date = [[time componentsSeparatedByString:@" "] firstObject];
                    [_myLessonArr addObject:model];
                }
                
            }
            
            if (joinLessonListArr) {
                for (NSDictionary *dic in joinLessonListArr) {
                    BaseCellModel *model = [[BaseCellModel alloc] init];
                    model.title = nilOrJSONObjectForKey(dic, @"title");
                    model.logo = nilOrJSONObjectForKey(dic, @"image");
                    model.name = nilOrJSONObjectForKey(dic, @"createName");
                    model.modelId = nilOrJSONObjectForKey(dic, @"id");
                    NSString *time = nilOrJSONObjectForKey(dic, @"createTime");
                    model.date = [[time componentsSeparatedByString:@" "] firstObject];
                    [_joinLessonArr addObject:model];
                    
                }

                
            }
            
            if (myHomeworkListArr) {
                for (NSDictionary *dic in myHomeworkListArr) {
                    NSDictionary *blogDic = [dic objectForKey:@"blog"];
                    BaseCellModel *model = [[BaseCellModel alloc] init];
                    model.title = nilOrJSONObjectForKey(blogDic, @"title");
                    model.modelId = nilOrJSONObjectForKey(blogDic, @"id");
                    model.logo = nilOrJSONObjectForKey(blogDic, @"image");
                    model.name = nilOrJSONObjectForKey(blogDic, @"createName");
                    NSString *time = nilOrJSONObjectForKey(blogDic, @"createTime");
                    model.likeId = [MyTool getValuesFor:dic key:@"likeId"];
                    model.collectId = [MyTool getValuesFor:dic key:@"favouriteId"];
                    model.date = [[time componentsSeparatedByString:@" "] firstObject];
                    [_myHomeorkArr addObject:model];
                }
            }
            
            [_tableView reloadData];
        }
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    
    NSString *str1 = [NSString stringWithFormat:@"mobi/dialogue/getDialoguePage?memberId=%@&pageNo=1&pageSize=4",[User shareUser].userId];
    [[HttpManager shareManger] getWithStr:str1 ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
        
        if ([[json objectForKey:@"code"] integerValue] == 0) {
            [_RepArr removeAllObjects];
            NSDictionary *dic = nilOrJSONObjectForKey(json, @"result");
            NSArray *array = nilOrJSONObjectForKey(dic, @"data");
            if (array) {
                for (NSDictionary *dict in array) {
                    BaseCellModel *model = [[BaseCellModel alloc] init];
                    model.name = nilOrJSONObjectForKey(dict, @"nickName");
                    model.logo = nilOrJSONObjectForKey(dict, @"img");
                    model.modelId = nilOrJSONObjectForKey(dict, @"id");
                    model.lastMessage = nilOrJSONObjectForKey(dict, @"lastMessage");
                    [_RepArr addObject:model];
                }
            }
        }
        [_tableView reloadData];
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    
}

- (void)initData
{
    _myLessonCount = @"0";
    _joinLessonCount = @"0";
    _myHomeorkCount = @"0";
    _RepCount = @"0";
    _likeCount = @"0";
    _myLessonArr = [NSMutableArray array];
    _joinLessonArr = [NSMutableArray array];
    _myHomeorkArr = [NSMutableArray array];
    _RepArr = [NSMutableArray array];
    _titleArray1 = @[@"完善个人资料",@"我的美币",@"我的购物袋",@"我的订单",@"我的收获地址"];
    _titleArray2 = @[@"美娘小助手",@"我的收藏",@"我的邀请链接",@"我邀请的好友"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 46) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
}

- (NSMutableArray *)getArr
{
    switch (_currentBtn.tag) {
        case 0:
        {
            return _myLessonArr;
        }
            break;
        case 1:
        {
            return _joinLessonArr;
            
        }
            break;
        case 2:
        {
            return _myHomeorkArr;
        }
            break;
        case 3:
        {
            return _RepArr;
        }
            break;
            
            
        default:
            break;
    }
    
    return nil;

}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        if ([[self getArr] count] != 0) {
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 30)];
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 30)];
            [img setImage:[UIImage imageNamed:@"bg_down1"]];
            [view addSubview:img];
            
            //更多
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(UI_SCREEN_WIDTH - 43, 5, 33, 20);
            [btn setImage:[UIImage imageNamed:@"more.png"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(viewMore) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn];
            
            return view;

        }
    }
    return nil;
}

- (void)viewMore
{

    switch (_currentBtn.tag) {
        case 0:
        case 1:
        {
            MyLessonsVC *vc = [[MyLessonsVC alloc] init];
            vc.type = _currentBtn.tag;
            vc.userId = [User shareUser].userId;

            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            MyhomewroksVC *vc = [[MyhomewroksVC alloc] init];
            vc.userId = [User shareUser].userId;

            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];

        }
            break;
        case 3:
        {
            MyMessagesVC *vc = [[MyMessagesVC alloc] init];
            vc.userId = [User shareUser].userId;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;

        default:
            break;
    }

}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0 && [[self getArr] count] != 0) {
        return 30;
    }
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 122)];
        [img setImage:[UIImage imageNamed:@"a.png"]];
        [view addSubview:img];
        
        UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake((UI_SCREEN_WIDTH - 80) / 2.0, img.bottom - 40, 80, 80)];
         [MyTool setImgWithURLStr:[User shareUser].logo withplaceholderImage:[UIImage imageNamed:@"default_avatar.png"] withImgView:logo];
        logo.layer.cornerRadius = 40;
        logo.layer.masksToBounds = YES;
        [view addSubview:logo];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, logo.bottom + 5, UI_SCREEN_WIDTH, 20)];
        nameLabel.textColor = BaseColor;
            nameLabel.text = [User shareUser].nickname;
        nameLabel.textAlignment = NSTextAlignmentCenter;
        [view addSubview:nameLabel];
        
        UIButton *signatureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        signatureBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [signatureBtn setTitle:[User shareUser].signature forState:UIControlStateNormal];
        [signatureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        signatureBtn.frame = CGRectMake(0, nameLabel.bottom + 5, UI_SCREEN_WIDTH, 20);
//        if (![User shareUser].signature) {
//            signatureBtn.hidden = YES;
//        }
        [signatureBtn setImage:[UIImage imageNamed:@"c.png"] forState:UIControlStateNormal];
        [view addSubview:signatureBtn];

        
        UIImageView *levelImg = [[UIImageView alloc] initWithFrame:CGRectMake(logo.left + 5, signatureBtn.bottom + 10 * UI_scaleY, 20, 20)];
        levelImg.contentMode = UIViewContentModeScaleAspectFit;
        NSString *level;
        if ([User shareUser].level) {
            level = [User shareUser].level;
        }else {
            level = @"1";
        }
        levelImg.image = [Util studentImageWithLevel:level];
        [view addSubview:levelImg];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(levelImg.right, levelImg.top, 50, 20);
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setImage:[UIImage imageNamed:@"work_06.png"] forState:UIControlStateNormal];
        NSString *like;
        if (_likeCount) {
            like = _likeCount;
        }else {
            like = @"0";
        }
        [btn setTitle:like forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [view addSubview:btn];
        
        NSArray *countArray = @[_myLessonCount,_joinLessonCount,_myHomeorkCount,_RepCount];
        NSArray *titleAr = @[@"创建的课堂",@"加入的课堂",@"发表的作业",@"站内消息"];
        CGFloat width = UI_SCREEN_WIDTH / 4.0;
        for (NSInteger i = 0; i < 4; i ++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(width * i + (width - 50) / 2.0, btn.bottom + 10, 50, 50);
            button.layer.cornerRadius = 25;
            button.layer.masksToBounds = YES;
            button.layer.borderColor = [UIColor grayColor].CGColor;
            button.layer.borderWidth = 1;
            button.tag = i;
            button.backgroundColor = [UIColor whiteColor];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [view addSubview:button];
            [button setTitle:countArray[i] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(changeOption:) forControlEvents:UIControlEventTouchUpInside];
            if (_currentBtn) {
                if (_currentBtn.tag == button.tag) {
                    button.selected = YES;
                    button.backgroundColor = BaseColor;
                    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    _currentBtn = button;
                }
            }else {
                if (i == 0) {
                    button.selected = YES;
                    button.backgroundColor = BaseColor;
                    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    _currentBtn = button;
                }
            }
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(width * i, button.bottom + 10, width, 20)];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = titleAr[i];
            label.font = [UIFont systemFontOfSize:15];
            label.textColor = [UIColor grayColor];
            [view addSubview:label];
        }
        
        NSInteger index;
        if (_currentBtn) {
            index = _currentBtn.tag;
        }else {
            index = 0;
        }
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH / 4.0 * index, 122 + 40 + 25 + 10 * UI_scaleY + 20 + 60 + 30 + 10 + 35 - 3, UI_SCREEN_WIDTH / 4.0, 3)];
        _lineView.backgroundColor = BaseColor;
        [view addSubview:_lineView];
        return view;

    }
    return nil;
}

- (void)changeOption:(UIButton *)btn
{
    if (btn.selected) {
        return;
    }
    _currentBtn.selected = NO;
    _currentBtn.backgroundColor = [UIColor whiteColor];
    [_currentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.selected = YES;
    btn.backgroundColor = BaseColor;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _currentBtn = btn;
    
    CGRect rect = _lineView.frame;
    rect.origin.x = UI_SCREEN_WIDTH / 4.0 * btn.tag;
    _lineView.frame = rect;
    
    [_tableView reloadData];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (section == 0) {
        return 122 + 40 + 25 + 10 * UI_scaleY + 20 + 60 + 30 + 10 + 35;
    }
    return 15;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        switch (_currentBtn.tag) {
            case 0:
            {
                return [_myLessonArr count];
            }
                break;
            case 1:
            {
                return [_joinLessonArr count];
            }
                break;
            case 2:
            {
                return [_myHomeorkArr count];
            }
                break;
            case 3:
            {
                return [_RepArr count];
            }
                break;

                
            default:
                break;
        }
        return 0;
    }
    if (section == 1) {
        return [_titleArray1 count];
    }
    if (section == 2) {
        return [_titleArray2 count];
    }
    if (section == 3) {
        return 1;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        
        cell = [[BaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dorm_b.png"]];
    }
    if (indexPath.section == 0) {
        if (_currentBtn.tag == 3) {
            cell.type = 32;
            NSMutableArray *array = [self getArr];
            cell.model = array[indexPath.row];

        }else {
            cell.type = 20;
            NSMutableArray *array = [self getArr];
            cell.model = array[indexPath.row];
        }
    }
    
    if (indexPath.section == 1) {
        cell.title = [_titleArray1 objectAtIndex:indexPath.row];
        cell.type = 21;
    }
    
    if (indexPath.section == 2) {
        cell.title = [_titleArray2 objectAtIndex:indexPath.row];
        cell.type = 21;
    }
    
    if (indexPath.section == 3) {
        cell.title = @"设置";
        cell.type = 23;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    switch (indexPath.section) {
        case 0:
        {
            switch (_currentBtn.tag) {
                case 0:
                {
                    BaseCellModel *model = _myLessonArr[indexPath.row];
                    LessonsVC *vc = [[LessonsVC alloc] init];
                    vc.lessonsId = model.modelId;
                    vc.hidesBottomBarWhenPushed = YES;

                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 1:
                {
                    BaseCellModel *model = _joinLessonArr[indexPath.row];
                    LessonsVC *vc = [[LessonsVC alloc] init];
                    vc.lessonsId = model.modelId;
                    vc.hidesBottomBarWhenPushed = YES;

                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 2:
                {
                    BaseCellModel *model = _myHomeorkArr[indexPath.row];
                    HomeworkVC *vc = [[HomeworkVC alloc] init];
                    vc.homeworkId = model.modelId;
                    vc.homworkModel = model;
                    vc.hidesBottomBarWhenPushed = YES;

                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 3:
                {
                    BaseCellModel *model = _RepArr[indexPath.row];
                    ChatVC *vc = [[ChatVC alloc] init];
                    vc.name = model.name;
                    vc.userId = model.modelId;
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;

                default:
                    break;
            }
            
        
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                        //完善个人资料
                    UserInfoVC *vc = [[UserInfoVC alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 2:
                {
                    //购物车
                    ShoppingcartVC *vc = [[ShoppingcartVC alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;

                case 3:
                {
                    OrderLIstVC *list = [[OrderLIstVC alloc] init];
                    list.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:list animated:YES];
                }
                    break;
                case 4:
                {
                    //完善个人资料
                    AddressList *list = [[AddressList alloc] init];
                    list.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:list animated:YES];
                }
                    break;

                    
                default:
                    break;
            }
        }
            break;
        case 2:
        {
            switch (indexPath.row) {
                case 0:
                {
                    //美娘小助手
                    MNhelperVC *vc = [[MNhelperVC alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 1:
                {
                    //收藏
                    CollectionVC *vc = [[CollectionVC alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 2:
                {
                    //分享
                    ShareVC *vc = [[ShareVC alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 3:
                {
                    InvitefriendsVC *vc = [[InvitefriendsVC alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 3:
        {
                //设置页面
            SetVC *vc = [[SetVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;

            
        default:
            break;
    }
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
