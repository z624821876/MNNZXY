//
//  SupermarketVC.m
//  BeautyCollege
//
//  Created by 于洲 on 15/4/15.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "SupermarketVC.h"
#import "GroupVC.h"
#import "CateVC.h"
#import "ShoppingcartVC.h"
#import "GoodsVC.h"

@interface SupermarketVC ()
{
    NSMutableArray          *_topImgArr;
    UIScrollView            *_scrollView;
    UIView                  *_lineView;
    UIButton                *_currentBtn;
    NSMutableArray          *_productCount;
    NSTimer                 *_timer;
    NSInteger               _currentScrollPage;
    UIPageControl           *_pageControl;
    NSMutableArray          *_dataArray;
    BaseCellModel           *_advImgModel;
    UILabel                 *_mLabel;
    UILabel                 *_hLabel;
    UILabel                 *_sLabel;
    UIView                  *_grouppurchaseView;
    MZTimerLabel            *_timelabel;
    NSDate                  *_currentDate;
    NSDate                  *_groupDate;
    NSInteger               _refrenshCount;
}

@end

@implementation SupermarketVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"baobei_c.png"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 60, 60);
    [btn setTitle:@"0" forState:UIControlStateNormal];
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [btn addTarget:self action:@selector(shoppingcart) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;

    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)shoppingcart
{
    ShoppingcartVC *vc = [[ShoppingcartVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)search
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 47) style:UITableViewStyleGrouped];
    NSLog(@"%f",UI_SCREEN_HEIGHT);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _timelabel = [[MZTimerLabel alloc] initWithLabel:nil andTimerType:MZTimerLabelTypeTimer];

}

- (void)initData
{
    _advImgModel = [[BaseCellModel alloc] init];
    _topImgArr = [[NSMutableArray alloc] init];
    _productCount = [[NSMutableArray alloc] initWithObjects:@"0",@"0",@"0," ,nil];
    _dataArray = [[NSMutableArray alloc] init];
}

- (void)stopRefrensh
{
    if (_refrenshCount >= 3) {
        
        [[tools shared] HUDHide];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    [[tools shared] HUDShowText:@"正在加载"];
    _refrenshCount = 0;
    NSString *str0 = [NSString stringWithFormat:@"mobi/pro/getShoppingCartCount?memberId=%@",[User shareUser].userId];
    [[HttpManager shareManger] getWithStr:str0 ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
        
        if ([[json objectForKey:@"code"] integerValue] == 0) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setImage:[UIImage imageNamed:@"baobei_c.png"] forState:UIControlStateNormal];
            btn.frame = CGRectMake(0, 0, 60, 60);
            [btn setTitle:[NSString stringWithFormat:@"%@",[json objectForKey:@"result"]] forState:UIControlStateNormal];
            btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            [btn addTarget:self action:@selector(shoppingcart) forControlEvents:UIControlEventTouchUpInside];

            UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
            self.navigationItem.rightBarButtonItem = item;
            
        }
        
    
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    
        //获取轮播图数据
    NSString *str = @"mobi/index/getAdv?type=2";
    [[HttpManager shareManger] getWithStr:str ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
        if ([[json objectForKey:@"code"] integerValue] == 0) {
            [_topImgArr removeAllObjects];
            if ([[[json objectForKey:@"result"] objectForKey:@"top"] isKindOfClass:[NSArray class]]) {
                NSArray *array = [[json objectForKey:@"result"] objectForKey:@"top"];
                for (NSDictionary *dic in array) {
                    BaseCellModel *model = [[BaseCellModel alloc] init];
                    model.url = nilOrJSONObjectForKey(dic, @"filePath");
                    model.name = nilOrJSONObjectForKey(dic, @"orgName");
                    model.modelId = [MyTool getValuesFor:dic key:@"clickurl"];
                    [_topImgArr addObject:model];
                }
                _refrenshCount += 1;
                [self stopRefrensh];
                [_tableView reloadData];
            }
        }
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    
        //获取商品数
    NSString *str2 = @"mobi/pro/getProductCount";
    [[HttpManager shareManger] getWithStr:str2 ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
        if ([[json objectForKey:@"code"] integerValue] == 0) {
            [_productCount removeAllObjects];
            id data = nilOrJSONObjectForKey(json, @"result");
            if ([data isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = data;
                id discount = nilOrJSONObjectForKey(dic, @"discount");
                [_productCount addObject:discount];
                id nw = nilOrJSONObjectForKey(dic, @"new");
                [_productCount addObject:nw];
                id all = nilOrJSONObjectForKey(dic, @"all");
                [_productCount addObject:all];
                
                _refrenshCount += 1;
                [self stopRefrensh];

                [_tableView reloadData];
            }
        }
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];

    [self loadDataWithtype:_currentBtn.tag - 10];
    
    //获取团购图片
    NSString *str3 = @"mobi/index/getAdv?type=3";
    [[HttpManager shareManger] getWithStr:str3 ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
        if ([[json objectForKey:@"code"] integerValue] == 0) {
            NSDictionary *dic = [json objectForKey:@"result"];
            NSArray *topArray = [dic objectForKey:@"top"];
            NSString *time = [MyTool getValuesFor:dic key:@"startTime"];
            _groupDate = [NSDate dateWithTimeIntervalSince1970:[time doubleValue] / 1000.0];
            if ([topArray count] != 0) {
                NSDictionary *dict = [topArray firstObject];
                _advImgModel.logo = nilOrJSONObjectForKey(dict, @"filePath");
                _advImgModel.modelId = nilOrJSONObjectForKey(dict, @"advertisementId");
                [_tableView reloadData];
                [self updateTime];
            }
        }
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    
}

- (void)updateTime
{
    [_timelabel reset];
    
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
        CGFloat aTimer = [_groupDate timeIntervalSinceDate:inputDate] - 8 * 60 * 60;
        if (aTimer > 0 && aTimer <= 60 * 60 * 24) {
            [_timelabel reset];
            [_timelabel setCountDownTime:aTimer];
            _timelabel.delegate = self;
            [_timelabel start];
        }
        _refrenshCount += 1;
        [self stopRefrensh];
        [_tableView reloadData];
    }
}

- (void)loadDataWithtype:(NSInteger)type
{
    NSString *typeStr;
    switch (type) {
        case 0:
        {
            typeStr = @"discount";
        }
            break;
        case 1:
        {
            typeStr = @"new";
        }
            break;
        default:
            break;
    }
    
    //获取商品数据
    NSString *str3 = [NSString stringWithFormat:@"mobi/pro/getProductList?type=%@&category=&keyword=&orderBy=&page=1&rows=100",typeStr];
    
    if (type == 2) {
        
        str3 = @"mobi/pro/getCategorys";
    }
    [_dataArray removeAllObjects];
    [[tools shared] HUDShowText:@"请稍后..."];
    [[HttpManager shareManger] getWithStr:str3 ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
        [[tools shared] HUDHide];
        if ([[json objectForKey:@"code"] integerValue] == 0) {
            [_dataArray removeAllObjects];
                //特价和新品
            if (type != 2) {
                NSDictionary *resultDic = [json objectForKey:@"result"];
                NSArray *data = [resultDic objectForKey:@"result"];
                for (NSDictionary *dic in data) {
                    BaseCellModel *model = [[BaseCellModel alloc] init];
                    model.title = nilOrJSONObjectForKey(dic, @"name");
                    model.logo = nilOrJSONObjectForKey(dic, @"detailImage");
                    NSNumber *priceNumber = nilOrJSONObjectForKey(dic, @"marketPrice");
                    NSNumber *discountNumber = nilOrJSONObjectForKey(dic, @"price");
                    model.price = [priceNumber stringValue];
                    model.modelId = nilOrJSONObjectForKey(dic, @"id");
                    model.discountPrice = [discountNumber stringValue];
                    [_dataArray addObject:model];
                }
                [_tableView reloadData];
            }else {
                //全部    分类
                NSArray *array = [json objectForKey:@"result"];
                for (NSDictionary *dic in array) {
                    NSDictionary *dataDic = [dic objectForKey:@"category"];
                    NSArray *dataArr = [dic objectForKey:@"childList"];
                    BaseCellModel *model = [[BaseCellModel alloc] init];
                    model.title = nilOrJSONObjectForKey(dataDic, @"name");
                    NSMutableArray *arr = [[NSMutableArray alloc] init];
                    for (NSDictionary *dictionary in dataArr) {
                        BaseCellModel *model2 = [[BaseCellModel alloc] init];
                        model2.title = nilOrJSONObjectForKey(dictionary, @"name");
                        model2.logo = nilOrJSONObjectForKey(dictionary, @"image");
                        NSNumber *number = nilOrJSONObjectForKey(dictionary, @"id");
                        model2.modelId = [number stringValue];
                        [arr addObject:model2];
                    }
                    model.cateArray = arr;
                    [_dataArray addObject:model];
                }
                [_tableView reloadData];
            }
        }else {
            [_tableView reloadData];
            [[tools shared] HUDShowHideText:@"加载失败" delay:1.0];
        }
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_tableView reloadData];
    }];

}

    //图片轮播
- (void)rotate:(NSTimer *)timer
{
    _currentScrollPage += 1;
    if (_currentScrollPage >= [_topImgArr count]) {
        _currentScrollPage = 0;
    }
    
    [_scrollView setContentOffset:CGPointMake(UI_SCREEN_WIDTH * _currentScrollPage, 0) animated:YES];
    
    _pageControl.currentPage = _currentScrollPage;
}

    //切换选项
- (void)changeOption:(UIButton *)btn
{
 
    if (btn.selected == YES) {
        return;
    }
    
    _currentBtn.selected = NO;
    _currentBtn = btn;
    _currentBtn.selected = YES;
    
    CGFloat width = UI_SCREEN_WIDTH / 3.0;
    CGRect rect = _lineView.frame;
    rect.origin.x = width * (btn.tag - 10);
    _lineView.frame = rect;
    
    [self loadDataWithtype:_currentBtn.tag - 10];
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_currentBtn.tag - 10 == 2) {
        return [_dataArray count];
    }
    NSInteger num = [_dataArray count];
    return (num + 1) / 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[BaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if ((_currentBtn.tag - 10) == 2) {
        cell.type = 16;
        cell.model = _dataArray[indexPath.row];
        [cell setBlock2:^(id model){
            if ([model isKindOfClass:[BaseCellModel class]]) {
                BaseCellModel *info = model;
                CateVC *vc = [[CateVC alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                vc.cateId = info.modelId;
                vc.cateTitle = info.title;
                [self.navigationController pushViewController:vc animated:YES];
  
            }
        }];
    }else {
        NSMutableArray *array = [NSMutableArray array];
        NSInteger num = indexPath.row * 2;
        BaseCellModel *model1 = _dataArray[num];
        [array addObject:model1];
        if ((num + 1) < [_dataArray count]) {
            BaseCellModel *model2 = _dataArray[num + 1];
            [array addObject:model2];
        }
        cell.type = 15;
        cell.modelArray = array;
        
        cell.cellView.tag = num;
        cell.cellView2.tag = num + 1;
        [cell.cellView addTarget:self action:@selector(goodsClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.cellView2 addTarget:self action:@selector(goodsClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
}

- (void)goodsClick:(UIButton *)btn
{
    BaseCellModel *model = _dataArray[btn.tag];
    GoodsVC *vc = [[GoodsVC alloc] init];
    vc.goodsId = model.modelId;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat bgHeight = 200 + 20 * UI_scaleY + 20 + 10 * UI_scaleY + 10 * UI_scaleY + 100 + 20 * UI_scaleY + 40 + 10 * UI_scaleY;
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, bgHeight)];
    bgView.backgroundColor = [UIColor whiteColor];
    [_scrollView removeFromSuperview];
    _scrollView = nil;
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 200)];
    _scrollView.pagingEnabled = YES;
    [bgView addSubview:_scrollView];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, _scrollView.bottom - 30, UI_SCREEN_WIDTH, 30)];
    _pageControl.numberOfPages = [_topImgArr count];
    _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    UIColor *color = [Util uiColorFromString:@"#e1008c" alpha:1];
    _pageControl.currentPageIndicatorTintColor = color;
    [bgView addSubview:_pageControl];
    
    if ([_topImgArr count] == 0) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, _scrollView.height);
        [btn setImage:[UIImage imageNamed:@"course_titbg.png"] forState:UIControlStateNormal];
        [_scrollView addSubview:btn];
    }else {
        for (NSInteger i = 0; i < [_topImgArr count]; i ++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(UI_SCREEN_WIDTH * i, 0, UI_SCREEN_WIDTH, _scrollView.height);
            BaseCellModel *model = [_topImgArr objectAtIndex:i];
            btn.tag = i;
            [btn addTarget:self action:@selector(advertisementClick:) forControlEvents:UIControlEventTouchUpInside];
            [btn sd_setImageWithURL:[NSURL URLWithString:model.url] forState:UIControlStateNormal];
            [_scrollView addSubview:btn];
        }
    }
    
    _pageControl.numberOfPages = [_topImgArr count];
    [_scrollView setContentSize:CGSizeMake(UI_SCREEN_WIDTH * [_topImgArr count], _scrollView.height)];
    [_timer invalidate];
    _timer = nil;
    _timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(rotate:) userInfo:nil repeats:YES];
    _currentScrollPage = 0;
    
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(15, _scrollView.bottom + 20 * UI_scaleY, UI_SCREEN_WIDTH - 30, 20 + 10 * UI_scaleY)];
    [img setImage:[UIImage imageNamed:@"07-超市_11.png"]];
    [bgView addSubview:img];
    
    UITextField *searchTF = [[UITextField alloc] initWithFrame:CGRectMake(15 + 25 * UI_scaleX, img.top + 5 * UI_scaleY, UI_SCREEN_WIDTH - (15 + 25 * UI_scaleX) - 25, 20)];
    searchTF.delegate = self;
    searchTF.returnKeyType = UIReturnKeySearch;
    [bgView addSubview:searchTF];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(15, img.bottom + 10 * UI_scaleY, img.width, 100);
    [btn sd_setImageWithURL:[NSURL URLWithString:_advImgModel.logo] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"07-超市_15.png"]];
    [btn addTarget:self action:@selector(pushToGroup) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:btn];
    
    CGFloat time = [_groupDate timeIntervalSinceDate:_currentDate] - 8 * 60 * 60;
    
    if (time > 0) {
        
        _grouppurchaseView = [[UIView alloc] initWithFrame:btn.frame];
        _grouppurchaseView.backgroundColor = ColorWithRGBA(30.0, 32.0, 40.0, 0.8);
        [bgView addSubview:_grouppurchaseView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _grouppurchaseView.width, _grouppurchaseView.height - 30)];
        label.text = @"距离本次开团还有";
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:30];
        [_grouppurchaseView addSubview:label];
    
        if (time <= 60 * 60 * 24) {
            
            CGFloat left = (_grouppurchaseView.width - 90 - 30) / 2.0;
            _hLabel = [[UILabel alloc] initWithFrame:CGRectMake(left, _grouppurchaseView.height - 45, 30, 35)];
            _hLabel.textAlignment = NSTextAlignmentCenter;
            _hLabel.textColor = BaseColor;
            _hLabel.font = [UIFont systemFontOfSize:17];
            _hLabel.backgroundColor = [UIColor whiteColor];
            [_grouppurchaseView addSubview:_hLabel];
            
            UILabel *Label1 = [[UILabel alloc] initWithFrame:CGRectMake(_hLabel.right, _hLabel.top + 15, 15, 20)];
            Label1.text = @":";
            Label1.textColor = [UIColor whiteColor];
            Label1.textAlignment = NSTextAlignmentCenter;
            Label1.font = [UIFont boldSystemFontOfSize:30];
            [_grouppurchaseView addSubview:Label1];
            
            _mLabel = [[UILabel alloc] initWithFrame:CGRectMake(Label1.right, _hLabel.top, 30, 35)];
            _mLabel.textAlignment = NSTextAlignmentCenter;
            _mLabel.textColor = BaseColor;
            _mLabel.font = [UIFont systemFontOfSize:17];
            _mLabel.backgroundColor = [UIColor whiteColor];
            [_grouppurchaseView addSubview:_mLabel];
            
            UILabel *Label2 = [[UILabel alloc] initWithFrame:CGRectMake(_mLabel.right, Label1.top, 15, 20)];
            Label2.text = @":";
            Label2.textColor = [UIColor whiteColor];
            Label2.textAlignment = NSTextAlignmentCenter;
            Label2.font = [UIFont boldSystemFontOfSize:30];
            [_grouppurchaseView addSubview:Label2];
            
            _sLabel = [[UILabel alloc] initWithFrame:CGRectMake(Label2.right, _hLabel.top, 30, 35)];
            _sLabel.textAlignment = NSTextAlignmentCenter;
            _sLabel.textColor = BaseColor;
            _sLabel.font = [UIFont systemFontOfSize:17];
            _sLabel.backgroundColor = [UIColor whiteColor];
            [_grouppurchaseView addSubview:_sLabel];
        }else {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, _grouppurchaseView.height - 45, _grouppurchaseView.width, 35)];
            label.font = [UIFont boldSystemFontOfSize:20];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor whiteColor];
            [_grouppurchaseView addSubview:label];
            label.text = [NSString stringWithFormat:@"%.0f天",time / (60.0 * 60.0 * 24.0)];
        }
    }
    CGFloat width = UI_SCREEN_WIDTH / 3.0;
    NSArray *array = @[@"特价",@"新品",@"全部"];
    for (NSInteger i = 0; i < 3; i ++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(width * i, btn.bottom + 20 * UI_scaleY, width, 20)];
        label.text = [NSString stringWithFormat:@"%@",_productCount[i]];
        //        label.font = [UIFont systemFontOfSize:15];
        label.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:label];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(width * i, label.bottom, width, 20)];
        label2.text = array[i];
        label2.textAlignment = NSTextAlignmentCenter;
        label2.textColor = BaseColor;
        [bgView addSubview:label2];
        DDLog(@"%f",label2.bottom);
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(width *i, btn.bottom + 20 * UI_scaleY, width, 40 + 10 * UI_scaleY);
        button.tag = 10 + i;
        if (button.tag == _currentBtn.tag || button.tag - 10 == _currentBtn.tag) {
            button.selected = YES;
            _currentBtn = button;
        }
        [button addTarget:self action:@selector(changeOption:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:button];
    }
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(width * (_currentBtn.tag - 10), bgView.bottom - 3, width, 3)];
    _lineView.backgroundColor = BaseColor;
    [bgView addSubview:_lineView];
    return bgView;
    
}

- (void)advertisementClick:(UIButton *)btn
{
    if ([_topImgArr count] > 0) {
        BaseCellModel *model = [_topImgArr objectAtIndex:btn.tag];
        GoodsVC *vc = [[GoodsVC alloc] init];
        vc.goodsId = model.modelId;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)pushToGroup
{
    GroupVC *vc = [[GroupVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 200 + 20 * UI_scaleY + 20 + 10 * UI_scaleY + 10 * UI_scaleY + 100 + 20 * UI_scaleY + 40 + 10 * UI_scaleY;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_currentBtn.tag - 10 == 2) {
        BaseCellModel *model = _dataArray[indexPath.row];
        CGFloat height = (UI_SCREEN_WIDTH / 3.0 + 20 + 10) * (([model.cateArray count] + 2) / 3);
        return height + 30;
    }
    return (UI_SCREEN_WIDTH - 30) / 2.0 + 90;
}

-(void)timerLabel:(MZTimerLabel*)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime
{
    [_grouppurchaseView removeFromSuperview];
    [timerLabel reset];
}

-(void)timerLabel:(MZTimerLabel*)timerlabel countingTo:(NSTimeInterval)time timertype:(MZTimerLabelType)timerType
{
    NSString *str = timerlabel.timeLabel.text;
    NSArray *array = [str componentsSeparatedByString:@":"];
    _hLabel.text = array[0];
    _mLabel.text = array[1];
    _sLabel.text = array[2];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if (textField.text.length > 0) {
        CateVC *vc = [[CateVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.cateTitle = textField.text;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    return YES;
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
