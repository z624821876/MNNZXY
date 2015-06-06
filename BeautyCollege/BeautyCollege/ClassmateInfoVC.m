//
//  ClassmateInfoVC.m
//  BeautyCollege
//
//  Created by 于洲 on 15/5/12.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "ClassmateInfoVC.h"
#import "ChatVC.h"
#import "LessonsVC.h"
#import "HomeworkVC.h"
#import "MyCustomView.h"
#import "MyTextView.h"
#import "MyLessonsVC.h"
#import "MyhomewroksVC.h"
#import "IQKeyboardManager.h"

@interface ClassmateInfoVC ()

@property (nonatomic, strong) UIImageView       *logoImg;
@property (nonatomic, strong) UIButton          *nameBtn;
@property (nonatomic, strong) UIButton          *cityBtn;
@property (nonatomic, strong) UIImageView       *levelImg;
@property (nonatomic, strong) UIButton          *likeCountBtn;
@property (nonatomic, strong) UIButton          *deleteBtn;
@property (nonatomic, strong) UIButton          *sendMessage;
@property (nonatomic, strong) UILabel           *signatureLabel;
@property (nonatomic, strong) NSArray           *titleArray;
@property (nonatomic, strong) User              *classUserInfo;
@property (nonatomic, strong) UILabel           *nameLable;
@property (nonatomic, strong) UIImageView       *sexImg;
@property (nonatomic, strong) NSMutableArray    *myLessonArr;
@property (nonatomic, strong) NSMutableArray    *joinLessonArr;
@property (nonatomic, strong) NSMutableArray    *myHomeorkArr;

@property (nonatomic, strong) NSString          *myLessonCount;
@property (nonatomic, strong) NSString          *joinLessonCount;
@property (nonatomic, strong) NSString          *myHomeorkCount;
@property (nonatomic, strong) NSString          *likeCount;

@property (nonatomic, strong) MyCustomView      *topBgView;
@property (nonatomic, strong) NSString          *applyStatus;

@property (nonatomic, strong) MyTextView        *messageTV;

@end

@implementation ClassmateInfoVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [IQKeyboardManager sharedManager].enable = YES;
    self.navigationController.navigationBarHidden = YES;
    [UIApplication sharedApplication].statusBarHidden = YES;
    self.view.backgroundColor = ColorWithRGBA(218.0, 225.0, 227.0, 1);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBarHidden = NO;
    [UIApplication sharedApplication].statusBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _myLessonArr = [NSMutableArray array];
    _joinLessonArr = [NSMutableArray array];
    _myHomeorkArr = [NSMutableArray array];
    _myLessonCount = @"0";
    _joinLessonCount = @"0";
    _myHomeorkCount = @"0";
    _likeCount = @"0";
    _classUserInfo = [[User alloc] init];
    _titleArray = @[@"创建的课堂",@"加入的课堂",@"发表的作业"];
    [self initGUI];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self loadData];
}

- (void)loadData
{
    [[tools shared] HUDShowText:@"正在加载..."];
    NSString *str = [NSString stringWithFormat:@"mobi/user/getUserDetail?memberId=%@&selfId=%@",self.ClassmateId,[User shareUser].userId];
    [[HttpManager shareManger] getWithStr:str ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
        [[tools shared] HUDHide];
        if ([[json objectForKey:@"code"] integerValue] == 0) {
            
            [_myLessonArr removeAllObjects];
            [_joinLessonArr removeAllObjects];
            [_myHomeorkArr removeAllObjects];
            NSDictionary *resultDic = nilOrJSONObjectForKey(json, @"result");
            NSDictionary *memberDic = nilOrJSONObjectForKey(resultDic, @"member");

            _classUserInfo.userId = nilOrJSONObjectForKey(memberDic, @"id");
            _classUserInfo.nickname = nilOrJSONObjectForKey(memberDic, @"nickname");
            _classUserInfo.logo = nilOrJSONObjectForKey(memberDic, @"logo");
            NSNumber *sexNum = nilOrJSONObjectForKey(memberDic, @"sex");
            _classUserInfo.sex = [sexNum stringValue];
            NSNumber *levelNum = nilOrJSONObjectForKey(memberDic, @"level");
            _classUserInfo.level = [levelNum stringValue];
            _classUserInfo.cityName = nilOrJSONObjectForKey(memberDic, @"cityName");
            _classUserInfo.signature = nilOrJSONObjectForKey(memberDic, @"signature");
            
            NSNumber *numer1 = nilOrJSONObjectForKey(resultDic, @"myLessonCount");
            _myLessonCount = [numer1 stringValue];
            NSNumber *numer2 = nilOrJSONObjectForKey(resultDic, @"joinLessonCount");
            _joinLessonCount = [numer2 stringValue];
            NSNumber *numer3 = nilOrJSONObjectForKey(resultDic, @"myHomeorkCount");
            _myHomeorkCount = [numer3 stringValue];
            NSNumber *number5 = nilOrJSONObjectForKey(resultDic, @"likeCount");
            _likeCount = [number5 stringValue];
            NSNumber *statusNum = nilOrJSONObjectForKey(resultDic, @"applyStatus");
            _applyStatus = [statusNum stringValue];
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
                    if ([_myLessonArr count] >= 2) {
                        break;
                    }
                }
                
            }
            
            if (joinLessonListArr) {
                for (NSDictionary *dic in joinLessonListArr) {
                    BaseCellModel *model = [[BaseCellModel alloc] init];
                    model.title = nilOrJSONObjectForKey(dic, @"title");
                    model.logo = nilOrJSONObjectForKey(dic, @"image");
                    model.name = nilOrJSONObjectForKey(dic, @"createName");
                    NSString *time = nilOrJSONObjectForKey(dic, @"createTime");
                    model.modelId = nilOrJSONObjectForKey(dic, @"id");
                    model.date = [[time componentsSeparatedByString:@" "] firstObject];
                    [_joinLessonArr addObject:model];
                    if ([_joinLessonArr count] >= 2) {
                        break;
                    }

                }
                
                
            }
            
            if (myHomeworkListArr) {
                for (NSDictionary *dic in myHomeworkListArr) {
                    NSDictionary *blogDic = [dic objectForKey:@"blog"];
                    BaseCellModel *model = [[BaseCellModel alloc] init];
                    model.title = nilOrJSONObjectForKey(blogDic, @"title");
                    model.logo = nilOrJSONObjectForKey(dic, @"image");
                    model.name = nilOrJSONObjectForKey(dic, @"createName");
                    NSNumber *time = nilOrJSONObjectForKey(blogDic, @"ct");
                    model.modelId = nilOrJSONObjectForKey(blogDic, @"id");
                    model.likeId = [MyTool getValuesFor:dic key:@"likeId"];
                    model.collectId = [MyTool getValuesFor:dic key:@"favouriteId"];
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[time doubleValue] / 1000.0];
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"yyyy-MM-dd"];
                    model.date = [formatter stringFromDate:date];
                    [_myHomeorkArr addObject:model];
                    if ([_myHomeorkArr count] >= 3) {
                        break;
                    }
                }
            }
            
            [self updateGUI];
        }else {
            [[tools shared] HUDShowHideText:@"加载失败" delay:1.0];
        }
        
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
}

- (void)updateGUI
{
    [_logoImg sd_setImageWithURL:[NSURL URLWithString:_classUserInfo.logo] placeholderImage:[UIImage imageNamed:@"default_avatar.png"]];
    
    _nameLable.text = _classUserInfo.nickname;
    CGRect labelRect = _nameLable.frame;
    CGFloat width = [_nameLable.text boundingRectWithSize:CGSizeMake(100000, 20) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.width;
    if (width < UI_SCREEN_WIDTH - _logoImg.right - 25 - 20) {
        labelRect.size.width = width + 10;
    }else {
        labelRect.size.width = UI_SCREEN_WIDTH - _logoImg.right - 25 - 20;
    }
    _nameLable.frame = labelRect;
    [_sexImg setImage:[Util sexImageWithNSString2:_classUserInfo.sex]];
    CGRect imgRect = _sexImg.frame;
    imgRect.origin.x = _nameLable.right;
    _sexImg.frame = imgRect;
    
    NSString *city;
    if (_classUserInfo.cityName) {
        city = _classUserInfo.cityName;
    }else {
        city = @"暂未确定";
    }
    [_cityBtn setTitle:city forState:UIControlStateNormal];
    
    [_levelImg setImage:[Util studentImageWithLevel:_classUserInfo.level]];
    [_likeCountBtn setTitle:_likeCount forState:UIControlStateNormal];
    if ([_applyStatus isEqualToString:@"1"]) {
        //是好友
        _deleteBtn.hidden = NO;
        [_sendMessage setTitle:@"发站内信" forState:UIControlStateNormal];
    }else {
        _deleteBtn.hidden = YES;
        [_sendMessage setTitle:@"添加好友" forState:UIControlStateNormal];
    }
    
    _signatureLabel.text = _classUserInfo.signature;
    
    [_tableView reloadData];
}

- (void)initGUI
{
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 122)];
    [img setImage:[UIImage imageNamed:@"a.png"]];
    [self.view addSubview:img];

    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake((UI_SCREEN_WIDTH - 150) / 2.0, 20, 150, 44);
    label.text = @"同学资料";
    label.font = [UIFont boldSystemFontOfSize:22];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(10, 26, 30, 30);
    [backBtn setImage:[UIImage imageNamed:@"back_03.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    _logoImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, img.bottom - 35, 70, 70)];
    [_logoImg setImage:[UIImage imageNamed:@"default_avatar.png"]];
    _logoImg.layer.cornerRadius = 35;
    _logoImg.layer.masksToBounds = YES;
    [self.view addSubview:_logoImg];
    
    _nameLable = [[UILabel alloc] init];
    _nameLable.text = @"姓名";
    _nameLable.textColor = [UIColor whiteColor];
    _nameLable.font = [UIFont systemFontOfSize:15];
    CGFloat width = [_nameLable.text boundingRectWithSize:CGSizeMake(100000, 20) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.width;
    if (width < UI_SCREEN_WIDTH - _logoImg.right - 25 - 20) {
        _nameLable.frame = CGRectMake(_logoImg.right + 15, img.bottom - 30, width + 10, 20);
    }else {
        _nameLable.frame = CGRectMake(_logoImg.right + 15, img.bottom - 30, UI_SCREEN_WIDTH - _logoImg.right - 25 - 20, 20);
    }
    [self.view addSubview:_nameLable];
    _sexImg = [[UIImageView alloc] initWithFrame:CGRectMake(_nameLable.right, _nameLable.top, 20, 20)];
    _sexImg.contentMode = UIViewContentModeScaleAspectFit;
    [_sexImg setImage:[Util sexImageWithNSString2:@"0"]];
    [self.view addSubview:_sexImg];
    
    _cityBtn = [[UIButton alloc] initWithFrame:CGRectMake(_logoImg.right + 15, img.bottom + 10, 200, 20)];
    _cityBtn.userInteractionEnabled = NO;
    [_cityBtn setTitle:@"暂未确定" forState:UIControlStateNormal];
    [_cityBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_cityBtn setImage:[UIImage imageNamed:@"yue_09.png"] forState:UIControlStateNormal];
    _cityBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _cityBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_cityBtn];
    
    _levelImg = [[UIImageView alloc] initWithFrame:CGRectMake(_cityBtn.left, _cityBtn.bottom + 5, 20, 20)];
    _levelImg.contentMode = UIViewContentModeScaleAspectFit;
    [_levelImg setImage:[Util studentImageWithLevel:@"1"]];
    [self.view addSubview:_levelImg];
    
    _likeCountBtn = [[UIButton alloc] initWithFrame:CGRectMake(_levelImg.right + 10, _levelImg.top, 50 * UI_scaleX, 20)];
    [_likeCountBtn setTitle:@"0" forState:UIControlStateNormal];
    _likeCountBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_likeCountBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_likeCountBtn setImage:[UIImage imageNamed:@"baobei_a.png"] forState:UIControlStateNormal];
    [self.view addSubview:_likeCountBtn];
    
    _deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(_likeCountBtn.right + 10, _likeCountBtn.top, (UI_SCREEN_WIDTH - _likeCountBtn.right - 10 - 10 - 10) / 2.0, 20)];
    _deleteBtn.backgroundColor = BaseColor;
    [_deleteBtn setTitle:@"删除好友" forState:UIControlStateNormal];
    _deleteBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_deleteBtn addTarget:self action:@selector(deleteFriend) forControlEvents:UIControlEventTouchUpInside];
    _deleteBtn.hidden = YES;
    [self.view addSubview:_deleteBtn];
    
    _sendMessage = [[UIButton alloc] initWithFrame:CGRectMake(_deleteBtn.right + 10, _deleteBtn.top, _deleteBtn.width, 20)];
    _sendMessage.backgroundColor = BaseColor;
    [_sendMessage setTitle:@"添加好友" forState:UIControlStateNormal];
    _sendMessage.titleLabel.font = [UIFont systemFontOfSize:13];
    [_sendMessage addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_sendMessage];
    
    UIImageView *tfBgImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, _sendMessage.bottom + 10, UI_SCREEN_WIDTH - 20, 30)];
    tfBgImg.image = [UIImage imageNamed:@"st_2_09.png"];
    [self.view addSubview:tfBgImg];
    
    _signatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 + 30 * UI_scaleX, tfBgImg.top, tfBgImg.width - 30 * UI_scaleX, 30)];
    _signatureLabel.text = @"这是个性签名";
    [self.view addSubview:_signatureLabel];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _signatureLabel.bottom + 10, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - _signatureLabel.bottom - 10) style:UITableViewStyleGrouped];
    UIView *footView = [UIView new];
    _tableView.tableFooterView = footView;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = ColorWithRGBA(218.0, 225.0, 227.0, 1);
    [self.view addSubview:_tableView];
}

    //删除好友
- (void)deleteFriend
{
    NSString *str = [NSString stringWithFormat:@"mobi/user/delete?memberId=%@&friendId=%@",[User shareUser].userId,_ClassmateId];
    [[HttpManager shareManger] getWithStr:str ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
        if ([[json objectForKey:@"code"] integerValue] == 0) {
            if ([[json objectForKey:@"result"] integerValue] == 1) {
                [[tools shared] HUDShowText:@"删除成功"];
                [self loadData];
            }
        }
    
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

    //添加好友 、 发站内信
- (void)sendMessage:(UIButton *)btn
{
    if ([[btn currentTitle] isEqualToString:@"添加好友"]) {
        //添加好友
        _topBgView = [[MyCustomView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)];
        _topBgView.backgroundColor = ColorWithRGBA(30.0, 32.0, 40.0, 0.5);
//        [[AppDelegate shareApp].window addSubview:_topBgView];
        [self.view addSubview:_topBgView];
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(10, 100, UI_SCREEN_WIDTH - 20, 200)];
        [img setImage:[[UIImage imageNamed:@"blank_num"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)]];
        [_topBgView addSubview:img];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(img.left + 10, img.top + 10, 100, 30)];
        label.text = @"附加信息:";
        [_topBgView addSubview:label];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(img.left, img.top + 50, img.width, 0.5)];
        lineView.backgroundColor = [UIColor grayColor];
        [_topBgView addSubview:lineView];
        
        _messageTV = [[MyTextView alloc] initWithFrame:CGRectMake(img.left + 10, lineView.bottom + 10, img.width - 20, 80)];
        _messageTV.font = [UIFont systemFontOfSize:15];
        _messageTV.placeholder = @"在此输入";
        _messageTV.delegate = self;
        _messageTV.backgroundColor = [UIColor clearColor];
        [_topBgView addSubview:_messageTV];
        
        UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(lineView.left, _messageTV.bottom + 10, lineView.width, 0.5)];
        lineView2.backgroundColor = [UIColor grayColor];
        [_topBgView addSubview:lineView2];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(img.right - 60, lineView2.bottom + 10, 50, 30);
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_finish.png"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(addFriend) forControlEvents:UIControlEventTouchUpInside];
        [_topBgView addSubview:btn];
        
    }else {
        //发站内信
        ChatVC *vc = [[ChatVC alloc] init];
        vc.userId = self.ClassmateId;
        vc.name = _classUserInfo.nickname;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
    CGFloat offY = UI_scaleY;
    CGRect rect = _topBgView.frame;
    rect.origin.y -= (90.0 / offY);
    _topBgView.frame = rect;
    return YES;
}

- (void)addFriend
{
//    if (_messageTV.text.length <= 0) {
//        [_topBgView removeFromSuperview];
//        return;
//    }
    [_topBgView removeFromSuperview];
    NSString *str = _messageTV.text;
    [_topBgView removeFromSuperview];

    NSString *url = [NSString stringWithFormat:@"mobi/user/add?memberId=%@&friendId=%@&content=%@",[User shareUser].userId,self.ClassmateId,str];
    [[HttpManager shareManger] getWithStr:url ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
        if ([[json objectForKey:@"code"] integerValue] == 0) {
            
            [[tools shared] HUDShowHideText:[json objectForKey:@"message"] delay:1.5];
        }else {
            [[tools shared] HUDShowHideText:@"添加失败" delay:1.5];
        }
        
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ssssss"];
    if (!cell) {
        cell = [[BaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = tableView.backgroundColor;
    }
    
    cell.title = _titleArray[indexPath.section];

    switch (indexPath.section) {
        case 0:
        {
            cell.name = _myLessonCount;
            cell.modelArray = _myLessonArr;
            cell.type = 30;
            __weak typeof(self) weakSelf = self;
            [cell setBlock:^(NSInteger i){
                LessonsVC *vc = [[LessonsVC alloc] init];
                BaseCellModel *model = _myLessonArr[i];
                vc.lessonsId = model.modelId;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }];
            cell.btn1.tag = 1;
            [cell.btn1 addTarget:self action:@selector(cellBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        case 1:
        {
            cell.name = _joinLessonCount;
            cell.modelArray = _joinLessonArr;
            cell.type = 30;
            __weak typeof(self) weakSelf = self;
            [cell setBlock:^(NSInteger i){
                LessonsVC *vc = [[LessonsVC alloc] init];
                BaseCellModel *model = _joinLessonArr[i];
                vc.lessonsId = model.modelId;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }];
            cell.btn1.tag = 0;
            [cell.btn1 addTarget:self action:@selector(cellBtnClick:) forControlEvents:UIControlEventTouchUpInside];

        }
            break;
        case 2:
        {
            cell.name = _myHomeorkCount;
            cell.modelArray = _myHomeorkArr;
            cell.type = 31;
            cell.btn1.tag = 2;
            [cell.btn1 addTarget:self action:@selector(cellBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            __weak typeof(self) weakSelf = self;
            [cell setBlock:^(NSInteger i){
                HomeworkVC *vc = [[HomeworkVC alloc] init];
                BaseCellModel *model = _myHomeorkArr[i];
                vc.homeworkId = model.modelId;
                vc.homworkModel = model;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }];

        }
            break;

            
        default:
            break;
    }
    
    return cell;
}

- (void)cellBtnClick:(UIButton *)btn
{
    if (btn.tag < 2) {
        MyLessonsVC *vc = [[MyLessonsVC alloc] init];
        vc.type = btn.tag;
        vc.userId = self.ClassmateId;
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        MyhomewroksVC *vc = [[MyhomewroksVC alloc] init];
        vc.userId = self.ClassmateId;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        if ([_myHomeorkCount integerValue] < 3) {
            return 100;
        }else {
            return 120;
        }
    }else {
        NSArray *array = @[_myLessonCount,_joinLessonCount];
        NSString *str = array[indexPath.section];
        if ([str integerValue] < 2) {
            return 100;
        }else {
            return 140;
        }
    }
    
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
