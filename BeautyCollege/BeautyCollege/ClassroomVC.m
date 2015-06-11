//
//  ClassroomVC.m
//  BeautyCollege
//
//  Created by 于洲 on 15/4/15.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "ClassroomVC.h"
#import "MJRefresh.h"
#import "MoreLessonVC.h"
#import "LocationVC.h"
#import "CreateLessonVC.h"
#import "LessonsVC.h"
#import "PublicSearchVC.h"

@interface ClassroomVC ()
{
    NSString        *_studentCount;
    NSString        *_lessonCount;
    NSString        *_homgworkCount;
}


@property (nonatomic, strong) NSMutableArray    *labelArr;
@property (nonatomic, strong) UIButton          *currentBtn;    //选中课堂的类型
@property (nonatomic, strong) UIButton          *currentBtn2;
@property (nonatomic, strong) UIImageView       *remarkView;

@property (nonatomic, strong) UILabel           *studentCountLab;
@property (nonatomic, strong) UILabel           *classCountLab;
@property (nonatomic, strong) UILabel           *workCountLab;

    //显示创建的课堂数
@property (nonatomic, strong) UILabel           *leftClassLab;
@property (nonatomic, strong) NSString          *myLessonCount;
    //显示参加的课堂数
@property (nonatomic, strong) UILabel           *rightClassLab;
@property (nonatomic, strong) NSString          *addLessonCount;

@property (nonatomic, strong) UIView            *lineView;

@property (nonatomic, strong) NSMutableArray    *recommendArr;
@property (nonatomic, assign) NSInteger         currentPage;
@property (nonatomic, strong) NSMutableArray    *allDataArr;

@property (nonatomic, strong) UIButton          *loctionBtn;

@property (nonatomic, strong) NSMutableArray    *myLessonArr;

@property (nonatomic, strong) UIView            *coverView;

@property (nonatomic, strong) UIImageView       *headIntervalImg;
@end

@implementation ClassroomVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationItem.title = @"课程";
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"课堂搜索.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(search)];
    self.navigationItem.rightBarButtonItem = item;
}
    //搜索
- (void)search
{
    if ([MyTool isLogin]) {
        
        PublicSearchVC *vc = [[PublicSearchVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.searchtype = 1;
        [self.navigationController pushViewController:vc animated:YES];

    }else {
        LoginVC *vc = [[LoginVC alloc] init];
        vc.type = 1;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];

    }
}

- (void)viewDidAppear:(BOOL)animated
{

    [super viewDidAppear:YES];
    
    [self loadDataCount];
    [self loadClassCount];
    [self getAllLessons];
}

    //加载学生数
- (void)loadDataCount
{
    NSString *locationId;
    if (_currentBtn.tag == 14) {
        
        locationId = _currentLocationId;
    }

    NSString *str1 = [NSString stringWithFormat:@"mobi/class/getClass?classId=%ld&cityId=%@",[self getClassIDWith],locationId];
    
    [[HttpManager shareManger] getWithStr:str1 ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
        if ([[json objectForKey:@"code"] integerValue] == 0) {
            NSDictionary *dic = [json objectForKey:@"result"];
            NSNumber *student = nilOrJSONObjectForKey(dic, @"studentCount");
            _studentCount = [student stringValue];
            _studentCountLab.text = _studentCount;
            NSNumber *lesson = nilOrJSONObjectForKey(dic, @"lessonCount");
            _lessonCount = [lesson stringValue];
            NSLog(@"----%@",_lessonCount);
            _classCountLab.text = _lessonCount;
            NSNumber *homeWork = nilOrJSONObjectForKey(dic, @"homgworkCount");
            _homgworkCount = [homeWork stringValue];
            _workCountLab.text = _homgworkCount;
            
            NSArray *array = [dic objectForKey:@"recLessons"];
            [_recommendArr removeAllObjects];
            if (_currentBtn.tag != 14) {

            if ([array count] > 0) {
                for (NSDictionary *classDic in array) {
                    BaseCellModel *model = [[BaseCellModel alloc] init];
                    model.logo = nilOrJSONObjectForKey(classDic, @"image");
                    model.modelId = nilOrJSONObjectForKey(classDic, @"id");
                    model.title = nilOrJSONObjectForKey(classDic, @"title");
                    NSNumber *studentNumber = nilOrJSONObjectForKey(classDic, @"studentCount");
                    model.studentCount = [studentNumber stringValue];
                    NSNumber *homeworkNumber = nilOrJSONObjectForKey(classDic, @"todayHomeworkCount");
                    model.homeworkCount = [homeworkNumber stringValue];
                    [_recommendArr addObject:model];
                    if ([_recommendArr count] >= 4) {
                        break;
                    }
                }
            }
            }
            [_tableView reloadData];

        }
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}
    //加载课堂数
- (void)loadClassCount
{
    
    if ([User shareUser].userId == nil) {
        return;
    }
    NSInteger type;
    if (_currentBtn2.tag - 20 == 0) {
        type = 0;
    }else {
        type = 1;
    }

    NSString *str1 = [NSString stringWithFormat:@"mobi/class/getMyLesson?classId=%ld&memberId=%@&type=%ld&pageNo=1&pageSize=4",[self getClassIDWith],[User shareUser].userId,type];
    
    [[HttpManager shareManger] getWithStr:str1 ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
        if ([[json objectForKey:@"code"] integerValue] == 0) {
            [_myLessonArr removeAllObjects];
            NSDictionary *dic = [json objectForKey:@"result"];
            NSNumber *mylesson = nilOrJSONObjectForKey(dic, @"myLessonCount");
            _myLessonCount = [mylesson stringValue];
            _leftClassLab.text = _myLessonCount;
            NSLog(@"%@",_myLessonCount);
            NSNumber *addlesson = nilOrJSONObjectForKey(dic, @"addLessonCount");
            _addLessonCount = [addlesson stringValue];
            _rightClassLab.text = _addLessonCount;
            
            NSDictionary *dataDic = nilOrJSONObjectForKey(dic, @"date");
//            NSArray *array = [dataDic objectForKey:@"data"];
            NSArray *array = nilOrJSONObjectForKey(dataDic, @"data");
            if (_currentBtn.tag != 14) {
                
                for (NSDictionary *dict in array) {
                    BaseCellModel *model = [[BaseCellModel alloc] init];
                    model.logo = nilOrJSONObjectForKey(dict, @"image");
                    model.title = nilOrJSONObjectForKey(dict, @"title");
                    model.modelId = nilOrJSONObjectForKey(dict, @"id");
                    NSNumber *studentNumber = nilOrJSONObjectForKey(dict, @"studentCount");
                    model.studentCount = [studentNumber stringValue];
                    NSNumber *homeworkNumber = nilOrJSONObjectForKey(dict, @"todayHomeworkCount");
                    model.homeworkCount = [homeworkNumber stringValue];
                    [_myLessonArr addObject:model];
                }
 
            }
            
            [_tableView reloadData];
        }
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}
    //加载全部课堂
- (void)getAllLessons
{
    NSString *locationId;
    if (_currentBtn.tag == 14) {

        locationId = _currentLocationId;
    }
    NSString *str1 = [NSString stringWithFormat:@"mobi/class/getLessons?classId=%ld&pageNo=%ld&pageSize=10&isRecommend=0&cityId=%@",[self getClassIDWith],_currentPage,locationId];
    [[HttpManager shareManger] getWithStr:str1 ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
        if ([[json objectForKey:@"code"] integerValue] == 0) {
            if (_currentPage == 1) {
                [_allDataArr removeAllObjects];
            }
            NSArray *array = nilOrJSONObjectForKey(json, @"result");
            if ([array count] != 0) {
                
                for (NSDictionary *dataDic in array) {
                    BaseCellModel *model = [[BaseCellModel alloc] init];
                    model.logo = nilOrJSONObjectForKey(dataDic, @"image");
                    model.title = nilOrJSONObjectForKey(dataDic, @"title");
                    model.modelId = nilOrJSONObjectForKey(dataDic, @"id");
                    NSNumber *studentNumber = nilOrJSONObjectForKey(dataDic, @"studentCount");
                    model.studentCount = [studentNumber stringValue];
                    NSNumber *homeworkNumber = nilOrJSONObjectForKey(dataDic, @"todayHomeworkCount");
                    model.homeworkCount = [homeworkNumber stringValue];
                    [_allDataArr addObject:model];
                }
            }else {
                _currentPage -= 1;
            }
            
            [_tableView reloadData];
        }else {
            _currentPage -= 1;
        }
        
        if ([_tableView.header isRefreshing]) {
            [_tableView.header endRefreshing];
        }else {
            [_tableView.footer endRefreshing];
        }
        
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ([_tableView.header isRefreshing]) {
            [_tableView.header endRefreshing];
        }else {
            [_tableView.footer endRefreshing];
        }
    }];

}

- (NSInteger)getClassIDWith
{
    switch (_currentBtn.tag - 10) {
        case 0:
        {
            return 1;
        }
            break;
        case 1:
        {
            return 11;
        }
            break;
        case 2:
        {
            return 14;
        }
            break;
        case 3:
        {
            return 15;
        }
            break;
        case 4:
        {
            return 16;
        }
            break;
        case 5:
        {
            return 17;
        }
            break;

            
        default:
            break;
    }
    return 0;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _labelArr = [[NSMutableArray alloc] init];
    _recommendArr = [[NSMutableArray alloc] init];
    _allDataArr = [[NSMutableArray alloc] init];
    _myLessonArr = [[NSMutableArray alloc] init];
    _studentCount = @"0";
    _lessonCount = @"0";
    _homgworkCount = @"0";
    _myLessonCount = @"0";
    _addLessonCount = @"0";
    _currentPage = 1;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 64 - 45) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = ColorWithRGBA(218.0, 225.0, 227.0, 1);
    [self initHeaderView];
    [self.view addSubview:_tableView];
    
    __weak typeof(self) weakSelf = self;
    [_tableView addLegendHeaderWithRefreshingBlock:^{
        weakSelf.currentPage = 1;
        [weakSelf getAllLessons];
    }];
    
    [_tableView addLegendFooterWithRefreshingBlock:^{
        weakSelf.currentPage += 1;
        [weakSelf getAllLessons];
    }];
}

- (void)initHeaderView
{
    CGFloat width = (UI_SCREEN_WIDTH - (20 * 7)) / 6;
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 80 + 60 + 10 * UI_scaleY + 20 + 10 + width + 20 + 20)];
    bgView.backgroundColor = [UIColor whiteColor];
    
    NSArray *imgArr = @[@"q1.png",@"q2.png",@"q3.png",@"q4.png",@"q5.png",@"q6.png"];
    NSArray *titleArr = @[@"情",@"爱",@"性",@"趣",@"约",@"觅"];
    for (NSInteger i = 0; i < 6; i ++) {
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(20 + (20 + width) * i, 10, width, width)];
        [img setImage:[UIImage imageNamed:imgArr[i]]];
        [bgView addSubview:img];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20 + (20 + width) * i, 10 + width, width, 20)];
        label.text = titleArr[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:15];
        [_labelArr addObject:label];
        [bgView addSubview:label];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(20 + (20 + width) * i, 10, width, width + 20);
        btn.tag = 10 + i;
        if (i == 0) {
            [self changeOption:btn];
        }
        [btn addTarget:self action:@selector(changeOption:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:btn];
    }
    
    _remarkView = [[UIImageView alloc] initWithFrame:CGRectMake(20 + (20 + width) * 0 + (width - 20) / 2.0, width + 30, 20, 20)];
    _remarkView.image = [UIImage imageNamed:@"三角.png"];
    [bgView addSubview:_remarkView];
    UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, width + 30 + 20, UI_SCREEN_WIDTH, 80 + 60 + 10 * UI_scaleY + 20)];
    grayView.backgroundColor = ColorWithRGBA(218.0, 225.0, 227.0, 1);
    [bgView addSubview:grayView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 40, 20)];
    label.text = @"学生";
    label.font = [UIFont systemFontOfSize:20];
    [grayView addSubview:label];
    
    _loctionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _loctionBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    _loctionBtn.hidden = YES;
    [_loctionBtn setImage:[UIImage imageNamed:@"yue_09.png"] forState:UIControlStateNormal];
    [grayView addSubview:_loctionBtn];
    
    _studentCountLab = [[UILabel alloc] initWithFrame:CGRectMake(label.right + 10, 10, UI_SCREEN_WIDTH - label.right - 20, 20)];
    _studentCountLab.textColor = BaseColor;
    _studentCountLab.text = _studentCount;
    [grayView addSubview:_studentCountLab];
    
    
    CGFloat labelWidth = (UI_SCREEN_WIDTH - 130) / 2.0;
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(10, label.bottom + 10, 30, 30)];
    label2.text = @"课程";
    label2.font = [UIFont systemFontOfSize:15];
    label2.textColor = [UIColor grayColor];
    [grayView addSubview:label2];
    
    _classCountLab = [[UILabel alloc] initWithFrame:CGRectMake(label2.right + 5, label2.top, labelWidth - 30, 30)];
    _classCountLab.text = _lessonCount;
    _classCountLab.textColor = BaseColor;
    _classCountLab.font = [UIFont systemFontOfSize:15];
    [grayView addSubview:_classCountLab];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(_classCountLab.right, label2.top, 30, 30)];
    label3.text = @"作业";
    label3.font = [UIFont systemFontOfSize:15];
    label3.textColor = [UIColor grayColor];
    [grayView addSubview:label3];
    

    _workCountLab = [[UILabel alloc] initWithFrame:CGRectMake(label3.right + 5, label2.top, labelWidth - 30, 30)];
    _workCountLab.text = _homgworkCount;
    _workCountLab.textColor = BaseColor;
    _workCountLab.font = [UIFont systemFontOfSize:15];
    [grayView addSubview:_workCountLab];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(UI_SCREEN_WIDTH - 100, label2.top, 90, 30);
    [btn setTitle:@"创建课堂" forState:UIControlStateNormal];
    btn.backgroundColor = BaseColor;
    [btn addTarget:self action:@selector(createLessons) forControlEvents:UIControlEventTouchUpInside];
    [grayView addSubview:btn];
    
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, btn.bottom + 10 * UI_scaleY, UI_SCREEN_WIDTH, 60 + 10 * UI_scaleY)];
    img.image = [UIImage imageNamed:@"bg_class_top.png"];
    [grayView addSubview:img];
    
    _leftClassLab = [[UILabel alloc] initWithFrame:CGRectMake(0, img.top + 10 * UI_scaleY, UI_SCREEN_WIDTH / 2.0, 30)];
    _leftClassLab.text = _myLessonCount;
    _leftClassLab.textColor = BaseColor;
    _leftClassLab.font = [UIFont systemFontOfSize:20];
    _leftClassLab.textAlignment = NSTextAlignmentCenter;
    [grayView addSubview:_leftClassLab];
    
    _rightClassLab = [[UILabel alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH / 2.0, _leftClassLab.top, UI_SCREEN_WIDTH / 2.0, 30)];
    _rightClassLab.textColor = BaseColor;
    _rightClassLab.text = _addLessonCount;
    _rightClassLab.font = [UIFont systemFontOfSize:20];
    _rightClassLab.textAlignment = NSTextAlignmentCenter;
    [grayView addSubview:_rightClassLab];
    
    NSArray *titleArray = @[@"我创建的课堂",@"我参加的课堂"];
    for (NSInteger i = 0; i < 2; i ++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH / 2.0 * i, _rightClassLab.bottom, UI_SCREEN_WIDTH / 2.0, 30)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:20];
        label.text = titleArray[i];
        [grayView addSubview:label];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(UI_SCREEN_WIDTH / 2.0 * i, _leftClassLab.top, UI_SCREEN_WIDTH / 2.0, 60);
        btn.tag = 20 + i;
        if (i == 0) {
            [self changeOption2:btn];
        }
        [btn addTarget:self action:@selector(changeOption2:) forControlEvents:UIControlEventTouchUpInside];
        [grayView addSubview:btn];
    }
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, img.bottom - 3, UI_SCREEN_WIDTH / 2.0, 3)];
    _lineView.backgroundColor = BaseColor;
    [grayView addSubview:_lineView];
    
    _coverView = [[UIView alloc] initWithFrame:CGRectMake(0, btn.bottom + 10 * UI_scaleY, UI_SCREEN_WIDTH, 60 + 10 * UI_scaleY)];
    _coverView.backgroundColor = _tableView.backgroundColor;
    [grayView addSubview:_coverView];
    bgView.layer.masksToBounds = YES;
    _coverView.hidden = YES;
    _tableView.tableHeaderView = bgView;
    
}

    //创建课堂
- (void)createLessons
{
    CreateLessonVC *vc = [[CreateLessonVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    NSArray *titleArr = @[@"情",@"爱",@"性",@"趣",@"约",@"觅"];
    vc.mark = titleArr[_currentBtn.tag - 10];
    vc.cateId = [self getClassIDWith];
    [self.navigationController pushViewController:vc animated:YES];
}

    //选择课堂类型
- (void)changeOption:(UIButton *)btn
{
    if (btn.selected) {
        return;
    }
    UIView *headerview = _tableView.tableHeaderView;
    CGFloat width1 = (UI_SCREEN_WIDTH - (20 * 7)) / 6;
    if (btn.tag - 10 == 4) {
        _coverView.hidden = NO;
        headerview.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, 80 + 60 + 10 * UI_scaleY + 20 + 10 + width1 + 20 + 20 - (60 + 30 * UI_scaleY));
        _tableView.tableHeaderView = headerview;
    }else {
        _coverView.hidden = YES;
        headerview.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, 80 + 60 + 10 * UI_scaleY + 20 + 10 + width1 + 20 + 20);
        _tableView.tableHeaderView = headerview;
    }
    
    _currentBtn.selected = NO;
    NSInteger index = _currentBtn == nil ? 0 : _currentBtn.tag - 10;
    UILabel *label1 = (UILabel *)[_labelArr objectAtIndex:index];
    label1.textColor = [UIColor blackColor];
    btn.selected = YES;
    _currentBtn = btn;
    UILabel *label2 = (UILabel *)[_labelArr objectAtIndex:btn.tag - 10];
    label2.textColor = BaseColor;
        //改变小三角位置
    CGFloat width = (UI_SCREEN_WIDTH - (20 * 7)) / 6;
    CGRect rect = _remarkView.frame;
    rect.origin.x = 20 + (20 + width) * (btn.tag - 10) + (width - 20) / 2.0;
    _remarkView.frame = rect;
    _loctionBtn.hidden = YES;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    if (btn.tag == 14) {
        _loctionBtn.hidden = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = ColorWithRGBA(218.0, 225.0, 227.0, 1);
        NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"MNlocation"];
        NSString *string;
        if (str == nil || [str isKindOfClass:[NSNull class]]) {
            string = @"宁波 切换";
            [[NSUserDefaults standardUserDefaults] setObject:@"宁波" forKey:@"MNlocation"];
            [[NSUserDefaults standardUserDefaults] setObject:@"388" forKey:@"MNlocationId"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }else {
            string = [NSString stringWithFormat:@"%@ 切换",str];
        }
        _currentLocationId = [[NSUserDefaults standardUserDefaults] objectForKey:@"MNlocationId"];
        CGFloat width = [string boundingRectWithSize:CGSizeMake(10000, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.width;
        _loctionBtn.frame = CGRectMake(UI_SCREEN_WIDTH - 10 - width - 40, 10, width + 40, 20);
        [_loctionBtn setTitle:string forState:UIControlStateNormal];
        [_loctionBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_loctionBtn addTarget:self action:@selector(changeLocation:) forControlEvents:UIControlEventTouchUpInside];
        _studentCountLab.frame = CGRectMake(60, 10, _loctionBtn.left - 70, 20);
    }
    
    [self loadDataCount];
    [self loadClassCount];
    [_tableView.header beginRefreshing];

    
}

    //切换位置
- (void)changeLocation:(UIButton *)btn
{
    LocationVC *location = [[LocationVC alloc] init];
    location.type = 2;
    __weak typeof(self) weakSelf = self;
    [location setBlock:^(NSString *str){
        weakSelf.currentLocationId = [[NSUserDefaults standardUserDefaults] objectForKey:@"MNlocationId"];
        NSString *string = [[NSUserDefaults standardUserDefaults] objectForKey:@"MNlocation"];
        NSString *string2 = [NSString stringWithFormat:@"%@ 切换",string];
        CGFloat width = [string2 boundingRectWithSize:CGSizeMake(10000, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.width;
        _loctionBtn.frame = CGRectMake(UI_SCREEN_WIDTH - 10 - width - 40, 10, width + 40, 20);
        [_loctionBtn setTitle:string2 forState:UIControlStateNormal];
    }];
    [self.navigationController pushViewController:location animated:YES];

}

- (void)changeOption2:(UIButton *)btn
{
    if (btn.selected) {
        return;
    }
    _currentBtn2.selected = NO;
    btn.selected = YES;
    _currentBtn2 = btn;
    CGRect rect = _lineView.frame;
    rect.origin.x = UI_SCREEN_WIDTH / 2.0 * (btn.tag - 20);
    _lineView.frame = rect;
    [self loadClassCount];
}

- (void)login
{
    LoginVC *vc = [[LoginVC alloc] init];
    vc.type = 1;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        if (_currentBtn.tag == 14) {
            return nil;
        }
        if ([User shareUser].userId == nil) {
            UIView *bgView = [[UIView alloc] init];

            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 30)];
            img.image = [UIImage imageNamed:@"coursebg_16.png"];
            [bgView addSubview:img];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
            btn.frame = img.frame;
            [btn setTitle:@"你尚未登录,点此登录可创建课堂哦~" forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [bgView addSubview:btn];
            return bgView;
        }else {
            if ([_myLessonArr count] != 0) {
                
                UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 20)];
                img.image = [UIImage imageNamed:@"bg_class_top"];
                return img;
            }
            return nil;
        }
    }
    
    if (section == 1) {
        if (_currentBtn.tag == 14) {
            return nil;
        }

        UIView *view = [[UIView alloc] init];
        
        view.backgroundColor = ColorWithRGBA(218.0, 225.0, 227.0, 1);
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 30, UI_SCREEN_WIDTH, 30)];
        [img setImage:[UIImage imageNamed:@"bg_class_top"]];
        [view addSubview:img];
        
        UIImageView *headerImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 35, 35)];
        [headerImg setImage:[UIImage imageNamed:@"美娘首页3"]];
        [view addSubview:headerImg];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(headerImg.right + 10, 30, 80, 30)];
        nameLabel.text = @"推荐课堂";
        [view addSubview:nameLabel];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = section;
        btn.frame = CGRectMake(UI_SCREEN_WIDTH - 40, 30, 30, 30);
        [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:[UIImage imageNamed:@"dd.png"] forState:UIControlStateNormal];
        [view addSubview:btn];
        
        
        return view;

    }
    
    if (section == 2) {
        
        UIView *view = [[UIView alloc] init];
        
        if (_currentBtn.tag == 14) {
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 30)];
//            bg_class_top
            [img setImage:[UIImage imageNamed:@"coursebg_16"]];
            [view addSubview:img];
            view.layer.masksToBounds = YES;
            return view;
        }
        
        
        view.backgroundColor = ColorWithRGBA(218.0, 225.0, 227.0, 1);
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 30, UI_SCREEN_WIDTH, 30)];
        [img setImage:[UIImage imageNamed:@"bg_class_top"]];
        [view addSubview:img];
        
        UIImageView *headerImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 35, 35)];
        [headerImg setImage:[UIImage imageNamed:@"美娘首页3"]];
        [view addSubview:headerImg];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(headerImg.right + 10, 30, 80, 30)];
        nameLabel.text = @"全部课堂";
        [view addSubview:nameLabel];
        return view;
        
    }

    
    return nil;
}

- (void)btnClick
{
    MoreLessonVC *vc = [[MoreLessonVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];

}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        if (_currentBtn.tag == 14) {
            return nil;
        }
        
        if ([User shareUser].userId == nil) {
            return nil;
        }
        if ([_myLessonArr count] != 0) {
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 30)];
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 30)];
            [img setImage:[UIImage imageNamed:@"bg_down1"]];
            [view addSubview:img];

                //更多
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(UI_SCREEN_WIDTH - 43, 5, 33, 20);
            [btn setImage:[UIImage imageNamed:@"more.png"] forState:UIControlStateNormal];
            [view addSubview:btn];

            return view;
        }
        
    }
    
    if (section == 1 || section == 2) {
            if (_currentBtn.tag == 14) {
                return nil;

        }
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 15)];
        [img setImage:[UIImage imageNamed:@"bg_down1"]];
        return img;
    }

    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0 || section == 1) {
        if (_currentBtn.tag == 14) {
            return 0.1;
        }
    }
    
    if (section == 0) {
        if ([User shareUser].userId != nil && [_myLessonArr count] != 0) {
            return 30;
        }
    }
    if (section == 1 || section == 2) {
        return 15;
    }
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0 || section == 1) {
        if (_currentBtn.tag == 14) {
            return 0.1;
        }
    }

    if (section == 0) {
        if ([User shareUser].userId == nil) {
            return 30;
        }else {
            if ([_myLessonArr count] != 0) {
                
                return 20;
            }
            return 0.1;
        }
    }
    if (section == 2) {
        if (_currentBtn.tag == 14) {
            return 30;
        }

    }
    
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 || indexPath.section == 1) {
        if (_currentBtn.tag == 14) {
            return 0;
        }
    }
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[BaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.backgroundColor = [UIColor whiteColor];
    if (indexPath.section == 0) {
        cell.model = _myLessonArr[indexPath.row];
        cell.type = 13;
    }
    
    if (indexPath.section == 1) {
        cell.model = _recommendArr[indexPath.row];
        cell.type = 13;
    }
    if (indexPath.section == 2) {
        cell.model = _allDataArr[indexPath.row];
        cell.type = 13;
        if (_currentBtn.tag == 14) {
            cell.type = 27;
        }
        
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_currentBtn.tag == 14) {
        if (section == 2) {
            return [_allDataArr count];
        }else {
            return 0;
        }
    }
    
    if (section == 0) {
        return [_myLessonArr count];
    }
    if (section == 1) {
        return [_recommendArr count];
    }
    if (section == 2) {
        return [_allDataArr count];
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (![MyTool isLogin]) {
        LoginVC *vc = [[LoginVC alloc] init];
        vc.type = 1;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];

    }else {
        BaseCellModel *model;
        switch (indexPath.section) {
            case 0:
            {
                model = _myLessonArr[indexPath.row];
            }
                break;
            case 1:
            {
                model = _recommendArr[indexPath.row];
            }
                break;
            case 2:
            {
                model = _allDataArr[indexPath.row];
            }
                break;
                
            default:
                break;
        }
        LessonsVC *vc = [[LessonsVC alloc] init];
        vc.lessonsId = model.modelId;
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
