//
//  SchoolmateVC.m
//  BeautyCollege
//
//  Created by 于洲 on 15/4/15.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "SchoolmateVC.h"
#import "MJRefresh.h"
#import "ClassmateInfoVC.h"
#import "PublicSearchVC.h"
#define NUMBERS @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

@interface SchoolmateVC ()

@property (nonatomic, strong) NSMutableArray        *labelArr;
@property (nonatomic, strong) UIView                *lineView;

@property (nonatomic, strong) UIButton              *currentBtn;
@property (nonatomic, strong) UIButton              *currentBtn2;


@property (nonatomic, strong) NSString              *friendsCount;
@property (nonatomic, strong) NSString              *friendsApplyCount;
@property (nonatomic, strong) NSString              *schoolmateCount;
@property (nonatomic, strong) NSMutableArray        *countArray;

@property (nonatomic, strong) NSMutableArray        *dataArray;
@property (nonatomic, strong) NSMutableDictionary   *dataDict;
@property (nonatomic, strong) NSMutableArray        *keyArr;

@property (nonatomic, assign) NSInteger             currentPage;

@property (nonatomic, strong) UIView                *sexBgView;

@property (nonatomic, strong) UIImageView           *markView;


@end

@implementation SchoolmateVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationItem.title = @"同学录";
    self.view.backgroundColor = ColorWithRGBA(218.0, 225.0, 227.0, 1);
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"课堂搜索.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(search)];
    self.navigationItem.rightBarButtonItem = item;

}
//搜索
- (void)search
{
    PublicSearchVC *vc = [[PublicSearchVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.searchtype = 2;
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    _currentPage = 1;
}

- (void)initData
{
    _currentPage = 1;
    _countArray = [[NSMutableArray alloc] init];
    _labelArr = [[NSMutableArray alloc] init];
    _dataArray = [[NSMutableArray alloc] init];
    _keyArr = [[NSMutableArray alloc] init];
    _dataDict = [[NSMutableDictionary alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    _labelArr = [[NSMutableArray alloc] init];
    [self buildTopView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40 + 15 * UI_scaleY + 64, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 45 - 64 - (40 + 15 * UI_scaleY)) style:UITableViewStyleGrouped];
    _tableView.delegate =self;
    _tableView.dataSource =self;
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (_currentBtn.tag == 0) {
        NSArray *array = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#"];
        return array;
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if ([_keyArr containsObject:title]) {
        return [_keyArr indexOfObject:title];
    }
    return 0;
}

- (void)viewDidAppear:(BOOL)animated
{
    if (![MyTool isLogin] && ([AppDelegate shareApp].mainTabBar.selectedIndex == 1)) {
        LoginVC *vc = [[LoginVC alloc] init];
        vc.type = 1;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        [self loadData];
    }
}

- (void)loadData
{
    NSString *string;
    NSString *sex;
    NSString *pagesize;
    NSString *pageNo;
    switch (_currentBtn.tag) {
        case 0:
        {
            string = @"friends";
        }
            break;
        case 1:
        {
            string = @"newfriends";
            pagesize = @"10";
//            pageNo = [NSString stringWithFormat:@"%ld",_currentPage];
        }
            break;
        case 2:
        {
            string = @"schoolmate";
            pagesize = @"10";
            pageNo = [NSString stringWithFormat:@"%ld",_currentPage];
            NSArray *array = @[@"女",@"无",@"男"];
            sex = array[_currentBtn2.tag];
            
        }
            break;
            
            
        default:
            break;
    }
    
    NSString *str = [NSString stringWithFormat:@"mobi/user/getUserList?memberId=%@&lessonId=0&type=%@&sex=%@&pageSize=%@&pageNo=%@",[User shareUser].userId,string,sex,pagesize,pageNo];
    [[tools shared] HUDShowText:@"加载中..."];
    [[HttpManager shareManger] getWithStr:str ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
        [[tools shared] HUDHide];
        if ([[json objectForKey:@"code"] integerValue] == 0) {
            [_countArray removeAllObjects];
            
            NSDictionary *dic = [json objectForKey:@"result"];
            NSNumber *number1 = nilOrJSONObjectForKey(dic, @"friendsCount");
            NSNumber *number2 = nilOrJSONObjectForKey(dic, @"friendsApplyCount");
            NSNumber *number3 = nilOrJSONObjectForKey(dic, @"schoolmateCount");
            _friendsCount = [number1 stringValue];
            _friendsApplyCount = [number2 stringValue];
            _schoolmateCount = [number3 stringValue];
            [_countArray addObject:_friendsCount];
            [_countArray addObject:_friendsApplyCount];
            [_countArray addObject:_schoolmateCount];
            
            for (NSInteger i = 0; i < [_labelArr count]; i ++) {
                UILabel *label = (UILabel *)[_labelArr objectAtIndex:i];
                label.text = [_countArray objectAtIndex:i];
            }
            
            if (_currentPage == 1) {
                [_dataArray removeAllObjects];
                [_keyArr removeAllObjects];
                [_dataDict removeAllObjects];
            }
            
            if (_currentBtn.tag != 2) {
                
                NSArray *array = [dic objectForKey:@"list"];
                if (![array isKindOfClass:[NSNull class]]) {
                    for (NSDictionary *dic in array) {
                        BaseCellModel *model = [[BaseCellModel alloc] init];
                        NSNumber *idNum = nilOrJSONObjectForKey(dic, @"id");
                        model.modelId = [idNum stringValue];
                        model.name = nilOrJSONObjectForKey(dic, @"nickname");
                        model.city = nilOrJSONObjectForKey(dic, @"cityName");
                        model.logo = nilOrJSONObjectForKey(dic, @"logo");
                        model.modelId = nilOrJSONObjectForKey(dic, @"id");
                        model.content = nilOrJSONObjectForKey(dic, @"applyContent");
                        [_dataArray addObject:model];
                    }
                    if (_currentBtn.tag == 0) {
                        
                        [self arraySort];
                    }
                    if ([array count] == 0) {
                        _currentPage -= 1;
                    }
                    
                }else {
                    _currentPage -= 1;
                }

            }else {
                NSDictionary *dict = [dic objectForKey:@"page"];
                NSArray *array = [dict objectForKey:@"data"];
                if (![array isKindOfClass:[NSNull class]]) {
                    for (NSDictionary *dic in array) {
                        BaseCellModel *model = [[BaseCellModel alloc] init];
                        NSNumber *idNum = nilOrJSONObjectForKey(dic, @"id");
                        model.modelId = [idNum stringValue];
                        model.name = nilOrJSONObjectForKey(dic, @"nickname");
                        model.city = nilOrJSONObjectForKey(dic, @"cityName");
                        model.logo = nilOrJSONObjectForKey(dic, @"logo");
                        model.modelId = nilOrJSONObjectForKey(dic, @"id");
                        [_dataArray addObject:model];
                    }
                    if (_currentBtn.tag == 0) {
                        
                        [self arraySort];
                    }
                    if ([array count] == 0) {
                        _currentPage -= 1;
                    }
                    
                }else {
                    _currentPage -= 1;
                }
            }
        }else {
            [[tools shared] HUDShowHideText:@"加载失败" delay:1.0];
        }
        
        if ([_tableView.header isRefreshing]) {
            [_tableView.header endRefreshing];
        }else {
            [_tableView.footer endRefreshing];
        }
        
        [_tableView reloadData];
        
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _currentPage -= 1;
        if ([_tableView.header isRefreshing]) {
            [_tableView.header endRefreshing];
        }else {
            [_tableView.footer endRefreshing];
        }

    }];

}

- (void)arraySort
{
    for (BaseCellModel *model in _dataArray) {

        CFStringRef strRef = (__bridge CFStringRef)model.name;
        CFMutableStringRef string = CFStringCreateMutableCopy(NULL, 0, strRef);
        CFStringTransform(string, NULL, kCFStringTransformToLatin, NO);
        CFStringTransform(string, NULL, kCFStringTransformStripDiacritics, NO);
        NSString *str = (__bridge NSString *)string;
        NSString *firstStr = [str substringWithRange:NSMakeRange(0, 1)];
        
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS]invertedSet];
        NSString *filtered = [[firstStr componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""]; //按cs分离出数组,数组按@""分离出字符串
        
        BOOL canChange = [firstStr isEqualToString:filtered];
        NSString *fristString;
        if (canChange) {
            fristString = [firstStr uppercaseString];
        }else {
            fristString = @"#";
        }
        if ([_dataDict objectForKey:fristString] == nil) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [array addObject:model];
            [_dataDict setObject:array forKey:fristString];
        }else {
            NSMutableArray *array = [_dataDict objectForKey:fristString];
            [array addObject:model];
            [_dataDict setObject:array forKey:fristString];
        }
        
    }
    
    NSArray *array = [_dataDict allKeys];
    NSMutableArray *array2 = [NSMutableArray arrayWithArray:[array sortedArrayUsingSelector:@selector(compare:)]];
    if ([[array2 firstObject] isEqualToString:@"#"]) {
        [array2 removeObjectAtIndex:0];
        [array2 addObject:@"#"];
    }
    
    [_keyArr addObjectsFromArray:array2];

}

- (void)buildTopView
{
    NSArray *title = @[@"好友",@"新朋友",@"校友"];
    UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 64, UI_SCREEN_WIDTH, 40 + 15 * UI_scaleY)];
    bgview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgview];
    CGFloat width = UI_SCREEN_WIDTH / 3.0;
    for (NSInteger i = 0; i < 3; i ++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(width * i, 5 + UI_scaleY, width, 20)];
        label.textColor = BaseColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"0";
        label.font = [UIFont systemFontOfSize:20];
        [bgview addSubview:label];
        [_labelArr addObject:label];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(width * i, label.bottom + 5 * UI_scaleY, width, 20)];
        label2.textAlignment = NSTextAlignmentCenter;
        label2.text = title[i];
        label2.font = [UIFont systemFontOfSize:20];
        [bgview addSubview:label2];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(width * i, 0, width, bgview.height);
        [btn addTarget:self action:@selector(changeOption:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        if (i == 0) {
//            [self changeOption:btn];
            btn.selected = YES;
            _currentBtn = btn;
        }
        [bgview addSubview:btn];
    }
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, bgview.height - 3, width, 3)];
    _lineView.backgroundColor = BaseColor;
    [bgview addSubview:_lineView];
    
    _sexBgView = [[UIView alloc] initWithFrame:CGRectMake(0, bgview.bottom, UI_SCREEN_WIDTH, 90 + 30 * UI_scaleY)];
    _sexBgView.backgroundColor = ColorWithRGBA(218.0, 225.0, 227.0, 1);
    NSArray *imgArr = @[@"s_08_03.png",@"s_08_05.png",@"s_08_07.png"];
    NSArray *titleArr = @[@"女性",@"无性",@"男性"];
    CGFloat btnWidth = (UI_SCREEN_WIDTH - 50 * 3) / 4.0;
    for (NSInteger i = 0; i < 3; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(btnWidth + (btnWidth + 50) * i, 10 * UI_scaleY, 50, 50);
        btn.tag = i;
        if (i == 0) {
            btn.selected = YES;
            _currentBtn2 = btn;
//            [self changeOption2:btn];
        }
        [btn addTarget:self action:@selector(changeOption2:) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:[UIImage imageNamed:imgArr[i]] forState:UIControlStateNormal];
        [_sexBgView addSubview:btn];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(btnWidth + (btnWidth + 50) * i, btn.bottom + 5 * UI_scaleY, 50, 20)];
        label.text = titleArr[i];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor grayColor];
        label.textAlignment = NSTextAlignmentCenter;
        [_sexBgView addSubview:label];
    }
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 70 + 30 * UI_scaleY, UI_SCREEN_WIDTH, 20)];
    [img setImage:[UIImage imageNamed:@"bg_class_top.png"]];
    [_sexBgView addSubview:img];
    
    _markView = [[UIImageView alloc] initWithFrame:CGRectMake(btnWidth + 15, 70 + 20 * UI_scaleY, 20, 10 * UI_scaleY + 5)];
    [_markView setImage:[UIImage imageNamed:@"s_08_18.png"]];
    [_sexBgView addSubview:_markView];
    _sexBgView.hidden = YES;
    [self.view addSubview:_sexBgView];
}

- (void)changeOption:(UIButton *)btn
{
    if (btn.selected == YES) {
        return;
    }
    _currentBtn.selected = NO;
    btn.selected = YES;
    _currentBtn = btn;
    CGFloat width = UI_SCREEN_WIDTH / 3.0;
    CGRect rect = _lineView.frame;
    rect.origin.x = btn.tag * width;
    _lineView.frame = rect;
    
    
    _currentPage = 1;
    
    [_dataDict removeAllObjects];
    [_keyArr removeAllObjects];
    [_dataArray removeAllObjects];
    [_tableView reloadData];
    
    if (_currentBtn.tag == 2) {
        _sexBgView.hidden = NO;
        _tableView.frame = CGRectMake(0, _sexBgView.bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - _sexBgView.bottom - 49);
        
        
    }else {
        _sexBgView.hidden = YES;
        _tableView.frame = CGRectMake(0, 40 + 15 * UI_scaleY + 64, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 49 - 64 - (40 + 15 * UI_scaleY));
    }

    if (btn.tag == 0) {
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView removeHeader];
        [_tableView removeFooter];
    }else if (btn.tag == 1) {
        __weak typeof(self) weakSelf = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView addLegendHeaderWithRefreshingBlock:^{
            weakSelf.currentPage = 1;
            [weakSelf loadData];
        }];
        [_tableView removeFooter];

    }else {
        __weak typeof(self) weakSelf = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView addLegendHeaderWithRefreshingBlock:^{
            weakSelf.currentPage = 1;
            [weakSelf loadData];
        }];
        
        [_tableView addLegendFooterWithRefreshingBlock:^{
            weakSelf.currentPage += 1;
            [weakSelf loadData];
        }];
    }
    
    [self loadData];
    
}

- (void)changeOption2:(UIButton *)btn
{
    if (btn.selected == YES) {
        return;
    }
    _currentBtn2.selected = NO;
    btn.selected = YES;
    _currentBtn2 = btn;
    
    CGFloat btnWidth = (UI_SCREEN_WIDTH - 50 * 3) / 4.0;
    CGRect rect = _markView.frame;
    rect.origin.x = btnWidth + (btnWidth + 50) * btn.tag + 15;
    _markView.frame = rect;
    _currentPage = 1;
    [self loadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[BaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dorm_b.png"]];
    }

    if (_currentBtn.tag == 0) {
        cell.type = 17;
        cell.model = [[_dataDict objectForKey:[_keyArr objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    }
    
    if (_currentBtn.tag == 1) {
        cell.type = 18;
        cell.btn2.tag = indexPath.row;
        [cell.btn2 addTarget:self action:@selector(addFirend:) forControlEvents:UIControlEventTouchUpInside];
        cell.model = [_dataArray objectAtIndex:indexPath.row];
    }
    
    if (_currentBtn.tag == 2) {
        cell.type = 19;
        cell.model = [_dataArray objectAtIndex:indexPath.row];
    }
    
    return cell;
    
}

- (void)addFirend:(UIButton *)btn
{
    BaseCellModel *model = _dataArray[btn.tag];
    //添加好友
    
        NSString *str = [NSString stringWithFormat:@"mobi/user/add?memberId=%@&friendId=%@&content=",[User shareUser].userId,model.modelId];
        [[HttpManager shareManger] getWithStr:str ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
            if ([[json objectForKey:@"code"] integerValue] == 0) {
    
                [[tools shared] HUDShowHideText:@"添加成功" delay:1.0];
                [self loadData];
            }else {
                [[tools shared] HUDShowHideText:@"添加失败" delay:1.0];
    
            }
    
        } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_currentBtn.tag == 0) {
        NSArray *array = [_dataDict objectForKey:[_keyArr objectAtIndex:section]];
        return [array count];
    }
    return [_dataArray count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_currentBtn.tag == 0) {
        UIView *bgView = [[UIView alloc] init];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 30, 30)];
        label.text = [_keyArr objectAtIndex:section];
        label.textColor = BaseColor;
        label.font = [UIFont systemFontOfSize:25];
        [bgView addSubview:label];
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, UI_SCREEN_WIDTH, 20)];
        [img setImage:[UIImage imageNamed:@"bg_class_top.png"]];
        [bgView addSubview:img];
        return bgView;
    }

    
    UIView *view = [UIView new];
    return view;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_currentBtn.tag == 0) {
        return 70;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_currentBtn.tag == 0) {
        return 60;
    }
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (_currentBtn.tag == 0) {
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 15)];
        [img setImage:[UIImage imageNamed:@"bg_down1"]];
        return img;

    }
    UIView *view = [UIView new];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (_currentBtn.tag == 0) {
        return 15;
    }
    return 0.1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_currentBtn.tag == 0) {
        return [_keyArr count];
    }
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_currentBtn.tag == 0) {
        BaseCellModel *model = [[_dataDict objectForKey:_keyArr[indexPath.section]] objectAtIndex:indexPath.row];
        ClassmateInfoVC *vc = [[ClassmateInfoVC alloc] init];
        vc.ClassmateId = model.modelId;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        BaseCellModel *model = _dataArray[indexPath.row];
        ClassmateInfoVC *vc = [[ClassmateInfoVC alloc] init];
        vc.ClassmateId = model.modelId;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
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
