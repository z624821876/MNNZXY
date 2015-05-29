//
//  SchoolVC.m
//  BeautyCollege
//
//  Created by 于洲 on 15/4/15.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "SchoolVC.h"
#import "HeaderView.h"
#import "MyWebVC.h"
#import "MoreUserVC.h"
#import "MoreNoticeVC.h"
#import "MoreworkVC.h"
#import "MoreLessonVC.h"
#import "MoreCommodityVC.h"
#import "LessonsVC.h"
#import "ClassmateInfoVC.h"
#import "GoodsVC.h"
#import "HomeworkVC.h"
#import "GroupVC.h"

@interface SchoolVC ()
{
    UITableView         *_tableView;
    
    
    UIView              *_topBgView;
    UIView              *_topBgView2;
    UIScrollView        *_topScroll;
    UIScrollView        *_topScroll2;
    
    NSMutableArray      *_topImgArr;
    NSMutableArray      *_topImgArr2;
    NSTimer             *_timer;
    UIPageControl       *_pageControl;
    
        //区头标题和图片
    NSArray             *_imgArray;
    NSArray             *_titleArr;
    
    NSMutableArray      *_cellImgArr;
    
        //通告数组
    NSMutableArray      *_noticeArr;
        //作业数组
    NSMutableArray      *_homeworkArr;
        //课程数组
    NSMutableArray      *_courseArr;
        //商品数组
    NSMutableArray      *_goodsArr;
    
    NSInteger           _currentPage;
    
    
    NSDate              *_groupDate;
    NSDate              *_currentDate;
    
}

@end

@implementation SchoolVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationItem.title = @"美娘女子学院";
}

- (void)loadData
{
    //加载轮播图
    NSString *str1 = @"mobi/index/getAdv?type=1";
    [[HttpManager shareManger] getWithStr:str1 ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
        if ([[json objectForKey:@"code"] integerValue] == 0) {
            [_topImgArr removeAllObjects];
            [_cellImgArr removeAllObjects];

            NSArray *topArray = [[json objectForKey:@"result"] objectForKey:@"top"];
            for (NSDictionary *dic in topArray) {
                BaseCellModel *model = [[BaseCellModel alloc] init];
                model.name = nilOrJSONObjectForKey(dic, @"orgName");
                model.modelId = nilOrJSONObjectForKey(dic, @"clickurl");
                model.content = nilOrJSONObjectForKey(dic, @"orgName");
                model.logo = nilOrJSONObjectForKey(dic, @"filePath");
                [_topImgArr addObject:model];
            }
            [self updateBgScroll];
            
            BaseCellModel *leftmodel = [[BaseCellModel alloc] init];
            NSDictionary *leftDic = [[[json objectForKey:@"result"] objectForKey:@"left"] firstObject];
            leftmodel.name = nilOrJSONObjectForKey(leftDic, @"orgName");
            leftmodel.modelId = nilOrJSONObjectForKey(leftDic, @"clickurl");
            leftmodel.logo = nilOrJSONObjectForKey(leftDic, @"filePath");
            [_cellImgArr addObject:leftmodel];
            NSArray *rightArr = [[json objectForKey:@"result"] objectForKey:@"right"];
            for (NSDictionary *rightDic in rightArr) {
                BaseCellModel *model = [[BaseCellModel alloc] init];
                model.name = nilOrJSONObjectForKey(rightDic, @"orgName");
                model.modelId = nilOrJSONObjectForKey(rightDic, @"clickurl");
                model.logo = nilOrJSONObjectForKey(rightDic, @"filePath");
                [_cellImgArr addObject:model];
            }
            [_tableView reloadData];
        }
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    //加载推荐用户
    NSString *str2 = @"mobi/index/getRecUser?pageNo=1";
    [[HttpManager shareManger] getWithStr:str2 ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
        if ([[json objectForKey:@"code"] integerValue] == 0) {
            [_topImgArr2 removeAllObjects];

            NSDictionary *dic = [json objectForKey:@"result"];
            if ([dic isKindOfClass:[NSDictionary class]]) {
                NSArray *array = [dic objectForKey:@"data"];
                for (NSDictionary *dic in array) {
                    BaseCellModel *model = [[BaseCellModel alloc] init];
                    model.modelId = nilOrJSONObjectForKey(dic, @"id");
                    model.name = nilOrJSONObjectForKey(dic, @"nickname");
                    model.city = nilOrJSONObjectForKey(dic, @"cityName");
                    model.logo = nilOrJSONObjectForKey(dic, @"logo");
                    [_topImgArr2 addObject:model];
                }
                [self updateScroll];
            }

        }
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

    //加载首页公告
    NSString *str3 = @"mobi/index/getBord?pageNo=1";
    [[HttpManager shareManger] getWithStr:str3 ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
        if ([[json objectForKey:@"code"] integerValue] == 0) {
            [_noticeArr removeAllObjects];

            NSDictionary *dict = [json objectForKey:@"result"];
            NSArray *array = [NSArray array];
            if ([dict isKindOfClass:[NSDictionary class]]) {
                array = [dict objectForKey:@"data"];
            }
            
            for (NSDictionary *dic in array) {
                if ([_noticeArr count] >= 2) {
                    break;
                }
                BaseCellModel *model = [[BaseCellModel alloc] init];
                model.name = nilOrJSONObjectForKey(dic, @"title");
                model.title = nilOrJSONObjectForKey(dic, @"subtitle");
                model.logo = nilOrJSONObjectForKey(dic, @"image");
                model.url = nilOrJSONObjectForKey(dic, @"url");
                model.date = nilOrJSONObjectForKey(dic, @"createTime");
                [_noticeArr addObject:model];
            }
            [_tableView reloadData];
        }
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    //加载首页推荐作业
    NSString *str4 = @"mobi/index/getHomework?pageNo=0";
    [[HttpManager shareManger] getWithStr:str4 ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
        if ([[json objectForKey:@"code"] integerValue] == 0) {
            [_homeworkArr removeAllObjects];

            NSArray *array = [json objectForKey:@"result"];
            for (NSDictionary *dic in array) {
                if ([_homeworkArr count] >= 2) {
                    break;
                }
                NSDictionary *memberDic = [dic objectForKey:@"member"];
                NSDictionary *blogDic = [dic objectForKey:@"blog"];
                BaseCellModel *model = [[BaseCellModel alloc] init];
                model.modelId = nilOrJSONObjectForKey(blogDic, @"id");
                model.title = nilOrJSONObjectForKey(blogDic, @"title");
                model.name = nilOrJSONObjectForKey(blogDic, @"createName");
                model.url = nilOrJSONObjectForKey(memberDic, @"level");
                    //评论
                NSNumber *commentNumber = nilOrJSONObjectForKey(blogDic, @"comment");
                model.comment = commentNumber == nil ? @"0" : [commentNumber stringValue];
                model.job = nilOrJSONObjectForKey(memberDic, @"levelName");
                NSNumber *number = nilOrJSONObjectForKey(blogDic, @"ct");
                model.date = [number stringValue];
                model.likeId = [MyTool getValuesFor:dic key:@"likeId"];
                model.collectId = [MyTool getValuesFor:dic key:@"favouriteId"];
                [_homeworkArr addObject:model];
            }
            [_tableView reloadData];
        }
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DDLog(@"%@",error);
    }];
    
    //加载首页推荐课堂
    NSString *str5 = @"mobi/index/getLesson?pageNo=0";
    [[HttpManager shareManger] getWithStr:str5 ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
        if ([[json objectForKey:@"code"] integerValue] == 0) {
            [_courseArr removeAllObjects];

            NSArray *array = [json objectForKey:@"result"];
            for (NSDictionary *dic in array) {
                if ([_courseArr count] >= 2) {
                    break;
                }
                if ([dic isKindOfClass:[NSDictionary class]]) {
                    BaseCellModel *model = [[BaseCellModel alloc] init];

                    model.modelId = nilOrJSONObjectForKey(dic, @"id");
                    model.title = nilOrJSONObjectForKey(dic, @"title");
                    model.logo = nilOrJSONObjectForKey(dic, @"image");
                    NSNumber *student = nilOrJSONObjectForKey(dic, @"studentCount");
                    model.studentCount = student == nil ? @"0" : [student stringValue];
                    NSNumber *homework = nilOrJSONObjectForKey(dic, @"todayHomeworkCount");
                    model.homeworkCount = homework == nil ? @"0" : [homework stringValue];
                    [_courseArr addObject:model];

                }
            }
            [_tableView reloadData];
        }
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DDLog(@"%@",error);
    }];

    //加载首页推荐商品
    NSString *str6 = @"mobi/pro/getProductList?type=recommend&page=1&rows=2";
    [[HttpManager shareManger] getWithStr:str6 ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
        if ([[json objectForKey:@"code"] integerValue] == 0) {
            [_goodsArr removeAllObjects];

            NSArray *array = [[json objectForKey:@"result"] objectForKey:@"result"];
            for (NSDictionary *dic in array) {
                if ([_goodsArr count] >= 2) {
                    break;
                }
                BaseCellModel *model = [[BaseCellModel alloc] init];
                model.modelId = nilOrJSONObjectForKey(dic, @"id");
                model.catId = nilOrJSONObjectForKey(dic, @"catId");
                model.title = nilOrJSONObjectForKey(dic, @"name");
                model.logo = nilOrJSONObjectForKey(dic, @"detailImage");
                NSNumber *price = nilOrJSONObjectForKey(dic, @"price");
                model.price = price == nil ? @"0" : [price stringValue];
                NSNumber *count = nilOrJSONObjectForKey(dic, @"likeCount");
                model.count = count == nil ? @"0" : [count stringValue];
                [_goodsArr addObject:model];
            }
            [_tableView reloadData];
        }
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DDLog(@"%@",error);
    }];

    
    //获取团购图片
    NSString *str10 = @"mobi/index/getAdv?type=3";
    [[HttpManager shareManger] getWithStr:str10 ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
        if ([[json objectForKey:@"code"] integerValue] == 0) {
            NSDictionary *dic = [json objectForKey:@"result"];
            NSArray *topArray = [dic objectForKey:@"top"];
            NSString *time = [MyTool getValuesFor:dic key:@"startTime"];
            _groupDate = [NSDate dateWithTimeIntervalSince1970:[time doubleValue] / 1000.0];
            [self updateTime];
        }
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];

    
}

- (void)updateTime
{
    
    NSURL *url=[NSURL URLWithString:@"http://www.baidu.com"];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    NSURLConnection *connection=[[NSURLConnection alloc]initWithRequest:request delegate:self startImmediately:YES];
    [connection start];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *httpResponse=(NSHTTPURLResponse *)response;
    if ([response respondsToSelector:@selector(allHeaderFields)]) {
        NSDictionary *dic=[httpResponse allHeaderFields];
        NSString *time=[dic objectForKey:@"Date"];
        
        NSString* string = [time substringToIndex:25];
        NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
        [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        [inputFormatter setDateFormat:@"EEE, d MMM yyyy HH:mm:ss"];
        NSDate *inputDate = [inputFormatter dateFromString:string];
        _currentDate = inputDate;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ColorWithRGBA(215.0, 225.0, 227.0, 1);
    [self initData];
    [self initGUI];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self loadData];
}

- (void)initData
{
    _imgArray = @[[UIImage imageNamed:@"美娘首页1"],[UIImage imageNamed:@"美娘首页2"],[UIImage imageNamed:@"美娘首页1"],[UIImage imageNamed:@"美娘首页3"],[UIImage imageNamed:@"美娘首页4"]];
    _titleArr = @[@"美娘公告",@"推荐作业",@"",@"推荐课堂",@"推荐商品"];
    _topImgArr = [NSMutableArray array];
    _topImgArr2 = [NSMutableArray array];
    _cellImgArr = [NSMutableArray array];
    _noticeArr = [NSMutableArray array];
    _courseArr = [NSMutableArray array];
    _homeworkArr = [NSMutableArray array];
    _goodsArr = [NSMutableArray array];
}

- (void)initGUI
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 45) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *view = [UIView new];
    _tableView.tableFooterView = view;
    _tableView.backgroundColor = ColorWithRGBA(215.0, 225.0, 227.0, 1);
    [self.view addSubview:_tableView];
    
    _tableView.delaysContentTouches = NO;
    for (id view in _tableView.subviews)
    {
        if ([NSStringFromClass([view class]) isEqualToString:@"UITableViewWrapperView"])
        {
            if([view isKindOfClass:[UIScrollView class]])
            {
                UIScrollView *scroll = (UIScrollView *) view;
                scroll.delaysContentTouches = NO;
            }
            break;
        }
    }
    
    //区头背景图
    _topBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 408)];

        //轮播图
    _topScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 408)];
    _topScroll.backgroundColor = [UIColor whiteColor];
    _topScroll.pagingEnabled = YES;
    [_topBgView addSubview:_topScroll];
    
    [self updateBgScroll];
    
        //区头覆盖层
    _topBgView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 408 - 180, UI_SCREEN_WIDTH, 180)];
    _topBgView2.backgroundColor = [UIColor blackColor];
    _topBgView2.alpha = 0.8;
    [_topBgView addSubview:_topBgView2];

    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, _topBgView2.top - 30, UI_SCREEN_WIDTH, 30)];
    _pageControl.numberOfPages = [_topImgArr count];
    _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    UIColor *color = [Util uiColorFromString:@"#e1008c" alpha:1];
    _pageControl.currentPageIndicatorTintColor = color;
    [_topBgView addSubview:_pageControl];

        //标签
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 150, 20)];
    label.text = @"找美女,上美娘";
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor whiteColor];
    [_topBgView2 addSubview:label];
    
        //NextBtn
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(UI_SCREEN_WIDTH - 70, 10, 50, 12);
    [btn setImage:[UIImage imageNamed:@"圆.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(searchMoreUser) forControlEvents:UIControlEventTouchUpInside];
    [_topBgView2 addSubview:btn];
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake( 20, _topBgView2.height - 30, 20, 20)];
    [img setImage:[UIImage imageNamed:@"search.png"]];
    [_topBgView2 addSubview:img];
    
    UITextField *searchTF = [[UITextField alloc] initWithFrame:CGRectMake(img.right + 5, _topBgView2.height - 32.5, UI_SCREEN_WIDTH - img.right - 20, 25)];
    [searchTF setBackground:[UIImage imageNamed:@"blank_home_search.png"]];
    searchTF.delegate = self;
    searchTF.textColor = [UIColor whiteColor];
    searchTF.returnKeyType = UIReturnKeySearch;
    [_topBgView2 addSubview:searchTF];
    
    _topScroll2 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, label.bottom + 5, UI_SCREEN_WIDTH, searchTF.top - label.bottom - 20)];
    [_topBgView2 addSubview:_topScroll2];
    [self updateScroll];
    _tableView.tableHeaderView = _topBgView;
}

#pragma mark - textfield Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    NSString *str = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (str.length > 0) {
        MoreUserVC *vc = [[MoreUserVC alloc] init];
        vc.type = 2;
        vc.keyword = textField.text;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
    return YES;
}

    //查看更多用户
- (void)searchMoreUser
{
    MoreUserVC *vc = [[MoreUserVC alloc] init];
    vc.type = 1;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

    //加载大轮播图
- (void)updateBgScroll
{
    for (UIView *view in _topScroll.subviews) {
        [view removeFromSuperview];
    }
    if ([_topImgArr count] == 0) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, _topScroll.height);
        [btn setImage:[UIImage imageNamed:@"course_titbg.png"] forState:UIControlStateNormal];
        [_topScroll addSubview:btn];
    }else {
        for (NSInteger i = 0; i < [_topImgArr count]; i ++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(UI_SCREEN_WIDTH * i, 0, UI_SCREEN_WIDTH, _topScroll.height);
            btn.tag = i;
            BaseCellModel *model = [_topImgArr objectAtIndex:i];
            [btn addTarget:self action:@selector(bgScrollClick:) forControlEvents:UIControlEventTouchUpInside];
            [btn sd_setImageWithURL:[NSURL URLWithString:model.logo] forState:UIControlStateNormal];
            [_topScroll addSubview:btn];
        }
    }
    
    _pageControl.numberOfPages = [_topImgArr count];
    [_topScroll setContentSize:CGSizeMake(UI_SCREEN_WIDTH * [_topImgArr count], _topScroll.height)];
    [_timer invalidate];
    _timer = nil;
    _timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(rotate:) userInfo:nil repeats:YES];
    _currentPage = 0;
}

    //点击轮播图
- (void)bgScrollClick:(UIButton *)btn
{
    BaseCellModel *model = _topImgArr[btn.tag];
    if ([model.content isEqualToString:@"帖子广告"]) {
        [[tools shared] HUDShowText:@"请稍候..."];
        NSString *str = [NSString stringWithFormat:@"mobi/class/tempGetHomeWorkForADV?memberId=%@&blogId=%@",[User shareUser].userId,model.modelId];
        [[HttpManager shareManger] getWithStr:str ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
            if ([[json objectForKey:@"code"] integerValue] == 0) {
                [[tools shared] HUDHide];
                NSDictionary *resultDic = nilOrJSONObjectForKey(json, @"result");
                model.likeId = [MyTool getValuesFor:resultDic key:@"likeId"];
                model.collectId = [MyTool getValuesFor:resultDic key:@"favouriteId"];
                
                HomeworkVC *vc = [[HomeworkVC alloc] init];
                vc.homeworkId = model.modelId;
                vc.homworkModel = model;
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
                
            }else {
                [[tools shared] HUDShowHideText:@"加载失败" delay:1.5];
            }
            
        } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        }];
        
    }else {
        GoodsVC *vc = [[GoodsVC alloc] init];
        vc.goodsId = model.modelId;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)rotate:(NSTimer *)timer
{
    _currentPage += 1;
    if (_currentPage >= [_topImgArr count]) {
        _currentPage = 0;
    }
    
    [_topScroll setContentOffset:CGPointMake(UI_SCREEN_WIDTH * _currentPage, 0) animated:YES];
    
    _pageControl.currentPage = _currentPage;
}

    //
- (void)updateScroll
{
    
    for (UIView *view in _topScroll2.subviews) {
        [view removeFromSuperview];
    }
    for (NSInteger i = 0; i < [_topImgArr2 count]; i ++) {
        HeaderView *img = [[HeaderView alloc] initWithFrame:CGRectMake(20 + 80 * i, 0, 60, _topScroll2.height) dataDic:_topImgArr2[i]];
        img.button.tag = i;
        [img.button addTarget:self action:@selector(userDetails:) forControlEvents:UIControlEventTouchUpInside];
        [_topScroll2 addSubview:img];
    }
    
    _topScroll2.contentSize = CGSizeMake(20 + 80 * [_topImgArr2 count] + 20, _topScroll2.height);
}

- (void)userDetails:(UIButton *)btn
{
    BaseCellModel *model = _topImgArr2[btn.tag];
    ClassmateInfoVC *vc = [[ClassmateInfoVC alloc] init];
    vc.ClassmateId = model.modelId;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)searchMore:(UIButton *)btn
{
    switch (btn.tag) {
        case 0:
        {
            MoreNoticeVC *vc = [[MoreNoticeVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            MoreworkVC *vc = [[MoreworkVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];

        }
            break;
        case 3:
        {
            MoreLessonVC *vc = [[MoreLessonVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 4:
        {
            MoreCommodityVC *vc = [[MoreCommodityVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];

        }
            break;

            
            
        default:
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    if (section != 2) {
        UIView *view = [[UIView alloc] init];

        view.backgroundColor = ColorWithRGBA(215.0, 225.0, 227.0, 1);
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 30, UI_SCREEN_WIDTH, 30)];
        [img setImage:[UIImage imageNamed:@"bg_class_top"]];
        [view addSubview:img];
        
        UIImageView *headerImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 35, 35)];
        [headerImg setImage:_imgArray[section]];
        [view addSubview:headerImg];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(headerImg.right + 10, 30, 80, 30)];
        nameLabel.text = _titleArr[section];
        [view addSubview:nameLabel];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = section;
        [btn addTarget:self action:@selector(searchMore:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(UI_SCREEN_WIDTH - 40, 30, 30, 30);
        [btn setImage:[UIImage imageNamed:@"dd.png"] forState:UIControlStateNormal];
        [view addSubview:btn];
        
        return view;
    }else {
        if ([_cellImgArr count] != 0) {
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 180)];
            
            UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            leftBtn.frame = CGRectMake(20, 15, (UI_SCREEN_WIDTH - 60) / 2.0 , 150);
            BaseCellModel *model = _cellImgArr[0];
            [leftBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:model.logo] forState:UIControlStateNormal];
            [leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:leftBtn];
            UIButton *topBtn = [UIButton buttonWithType:UIButtonTypeCustom];

            if ([_cellImgArr count] >= 2) {
                
                topBtn.frame = CGRectMake(leftBtn.right + 10, 15, (UI_SCREEN_WIDTH - 60) / 2.0 + 10, 70);
                BaseCellModel *model2 = _cellImgArr[1];
                [topBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:model2.logo] forState:UIControlStateNormal];
                [topBtn addTarget:self action:@selector(topBtnClick) forControlEvents:UIControlEventTouchUpInside];

                [view addSubview:topBtn];
            }
            
            if ([_cellImgArr count] >= 3) {
                
                UIButton *bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                bottomBtn.frame = CGRectMake(leftBtn.right + 10, topBtn.bottom + 10, (UI_SCREEN_WIDTH - 60) / 2.0 + 10, 70);
                BaseCellModel *model3 = _cellImgArr[2];
                [bottomBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:model3.logo] forState:UIControlStateNormal];
                [bottomBtn addTarget:self action:@selector(bottomBtnClick) forControlEvents:UIControlEventTouchUpInside];

                [view addSubview:bottomBtn];

            }

            return view;

        }
        return nil;
    }
    
}

- (void)topBtnClick
{
    if (nil != _currentDate && nil != _groupDate) {
        NSTimeInterval aTimer = [_groupDate timeIntervalSinceDate:_currentDate];
        
//        if (aTimer > 0) {
//            
//            [[tools shared] HUDShowHideText:@"暂未开团" delay:1.5];
//        }else {
            //跳转到团购
            GroupVC *vc = [[GroupVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
//        }
    }
}

- (void)bottomBtnClick
{
    [AppDelegate shareApp].mainTabBar.selectedIndex = 2;
}

- (void)leftBtnClick
{
    BaseCellModel *model = _cellImgArr[0];
    GoodsVC *vc = [[GoodsVC alloc] init];
    vc.goodsId = model.modelId;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        UIView *view = [UIView new];
        return view;
    }
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 15)];
    [img setImage:[UIImage imageNamed:@"bg_down1"]];
    return img;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        return 0.1;
    }
    return 15;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section != 2) {
        return 60;
    }else {
        if ([_cellImgArr count] == 0) {
            return 0.1;
        }
        return 180;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        case 1:
        {
            return 70;
        }
            break;
        case 3:
        {
            return 80;
        }
            break;
        case 4:
        {
            return (UI_SCREEN_WIDTH - 30) / 2.0 + 90;
        }
            break;

            
        default:
            break;
    }
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    switch (section) {
        case 0:
        {
            return [_noticeArr count];
        }
            break;
        case 1:
        {
            return [_homeworkArr count];
        }
            break;
        case 2:
        {
            return 0;
        }
            break;
        case 3:
        {
            return [_courseArr count];
        }
            break;
        case 4:
        {
            return [_goodsArr count] > 0 ? 1 : 0;
        }
            break;
            
        default:
            break;
    }
    
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[BaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dorm_b.png"]];
        
        for (id obj in cell.subviews)
        {
            if ([NSStringFromClass([obj class]) isEqualToString:@"UITableViewCellScrollView"])
                
            {
                UIScrollView *scroll = (UIScrollView *) obj;
                scroll.delaysContentTouches =NO;
                break;
            }
        }
        
    }
    
    cell.indexPath = indexPath;
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    switch (indexPath.section) {
        case 0:
        {
            cell.model = _noticeArr[indexPath.row];
            cell.type = 10;
        }
            break;
        case 1:
        {
            cell.model = _homeworkArr[indexPath.row];
            cell.type = 11;
        }
            break;
        case 2:
        {

        }
            break;
        case 3:
        {
            cell.model = _courseArr[indexPath.row];
            cell.type = 13;
        }
            break;
        case 4:
        {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.model = _goodsArr[0];
            if ([_goodsArr count] == 2) {
                cell.model2 = _goodsArr[1];
            }
            cell.type = 14;
            cell.cellView.tag = 10;
            [cell.cellView addTarget:self action:@selector(goodsClick:) forControlEvents:UIControlEventTouchUpInside];
            cell.cellView2.tag = 11;
            [cell.cellView2 addTarget:self action:@selector(goodsClick:) forControlEvents:UIControlEventTouchUpInside];

        }
            break;
            
        default:
            break;
    }
    
    
    return cell;
}

- (void)goodsClick:(UIButton *)btn
{
    BaseCellModel *model = _goodsArr[btn.tag - 10];
    GoodsVC *vc = [[GoodsVC alloc] init];
    vc.goodsId = model.modelId;
    vc.catId = model.catId;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseCell *cell = (BaseCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.btn1.selected = YES;
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseCell *cell = (BaseCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.btn1.selected = NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    switch (indexPath.section) {
        case 0:
        {
            BaseCellModel *model = _noticeArr[indexPath.row];
            MyWebVC *vc = [[MyWebVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.URLStr = model.url;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            BaseCellModel *model = _homeworkArr[indexPath.row];
            HomeworkVC *vc = [[HomeworkVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.homeworkId = model.modelId;
            vc.homworkModel = model;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;

        case 3:
        {
            if (![User shareUser].userId) {
                LoginVC *vc = [[LoginVC alloc] init];
                vc.type = 1;
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else {
                BaseCellModel *model = _courseArr[indexPath.row];
                LessonsVC *vc = [[LessonsVC alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                vc.lessonsId = model.modelId;
                [self.navigationController pushViewController:vc animated:YES];

            }
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
