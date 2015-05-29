//
//  SupermarketVC.m
//  BeautyCollege
//
//  Created by 于洲 on 15/4/15.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "SupermarketVC.h"

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
}

@end

@implementation SupermarketVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"baobei_c.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(search)];
    self.navigationItem.rightBarButtonItem = item;
    self.automaticallyAdjustsScrollViewInsets = YES;
}

- (void)search
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    NSLog(@"%f",UI_SCREEN_HEIGHT);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];

}

- (void)initData
{
    _advImgModel = [[BaseCellModel alloc] init];
    _topImgArr = [[NSMutableArray alloc] init];
    _productCount = [[NSMutableArray alloc] initWithObjects:@"0",@"0",@"0," ,nil];
    _dataArray = [[NSMutableArray alloc] init];
}

- (void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:YES];
    
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
                    model.modelId = nilOrJSONObjectForKey(dic, @"advertisementId");
                    [_topImgArr addObject:model];
                }
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
                [_tableView reloadData];
            }
        }
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];

    [self loadDataWithtype:0];
    
    //获取团购图片
    NSString *str3 = @"mobi/index/getAdv?type=3";
    [[HttpManager shareManger] getWithStr:str3 ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
        if ([[json objectForKey:@"code"] integerValue] == 0) {
            NSDictionary *dic = [json objectForKey:@"result"];
            NSArray *topArray = [dic objectForKey:@"top"];
            if ([topArray count] != 0) {
                NSDictionary *dict = [topArray firstObject];
                _advImgModel.logo = nilOrJSONObjectForKey(dict, @"filePath");
                _advImgModel.modelId = nilOrJSONObjectForKey(dict, @"advertisementId");
                [_tableView reloadData];
            }
        }
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    
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
    [[HttpManager shareManger] getWithStr:str3 ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
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
                    NSNumber *priceNumber = nilOrJSONObjectForKey(dic, @"price");
                    NSNumber *discountNumber = nilOrJSONObjectForKey(dic, @"discountPrice");
                    model.price = [priceNumber stringValue];
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
                        NSNumber *number = nilOrJSONObjectForKey(dic, @"parentId");
                        model2.modelId = [number stringValue];
                        [arr addObject:model2];
                    }
                    model.cateArray = arr;
                    [_dataArray addObject:model];
                }
                [_tableView reloadData];
            }
        }
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
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
    }
    
    
    return cell;
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
    [bgView addSubview:searchTF];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(15, img.bottom + 10 * UI_scaleY, img.width, 100);
    [btn sd_setImageWithURL:[NSURL URLWithString:_advImgModel.logo] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"07-超市_15.png"]];
     
    [bgView addSubview:btn];
    
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
