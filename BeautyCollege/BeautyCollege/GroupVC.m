//
//  GroupVC.m
//  BeautyCollege
//
//  Created by 于洲 on 15/5/26.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "GroupVC.h"
#import "MJRefresh.h"
#import "GoodsVC.h"

@interface GroupVC ()
{
    NSMutableArray      *_dataArray;
    BaseCellModel       *_GroupInfo;
}
@property (nonatomic, assign) NSInteger currentPage;
@end

@implementation GroupVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(15, 32, 20, 20);
    [backBtn setImage:[UIImage imageNamed:@"back_03.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [NSMutableArray array];
    _currentPage = 1;
    _GroupInfo = [[BaseCellModel alloc] init];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, - 0.1, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT + 0.1) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    UIView *view = [UIView new];
    _tableView.tableFooterView = view;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.1)];
    _tableView.tableHeaderView = view2;
    __weak typeof(self) weakSelf = self;
    [_tableView addLegendHeaderWithRefreshingBlock:^{
        weakSelf.currentPage = 1;
        [weakSelf loadData];
    }];
    
    [_tableView addLegendFooterWithRefreshingBlock:^{
        weakSelf.currentPage += 1;
        [weakSelf loadData];
    }];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [_tableView.header beginRefreshing];
}

- (void)loadData
{
    [[tools shared] HUDShowText:@"正在加载"];
    
    NSString *url = @"mobi/index/getAdv?type=4";
    
    [[HttpManager shareManger] getWithStr:url ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
        if ([[json objectForKey:@"code"] integerValue] == 0) {
            NSDictionary *resultDic = nilOrJSONObjectForKey(json, @"result");
            NSArray *array = nilOrJSONObjectForKey(resultDic, @"top");
            NSDictionary *dict = [array firstObject];
            _GroupInfo.logo = nilOrJSONObjectForKey(dict, @"filePath");
            _GroupInfo.content = nilOrJSONObjectForKey(dict, @"content");
        }
        [_tableView reloadData];
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    
    
    //获取商品数据
    NSString *str = [NSString stringWithFormat:@"mobi/pro/getProductList?type=group&category=&keyword=&orderBy=&page=%ld&rows=10",_currentPage];
    [[HttpManager shareManger] getWithStr:str ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
        BOOL isNull = YES;
        if ([[json objectForKey:@"code"] integerValue] == 0) {
            [[tools shared] HUDHide];
            if (_currentPage == 1) {
                [_dataArray removeAllObjects];
            }
            //特价和新品
            NSDictionary *resultDic = nilOrJSONObjectForKey(json, @"result");
            NSArray *data = nilOrJSONObjectForKey(resultDic, @"result");
            for (NSDictionary *dic in data) {
                isNull = NO;
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
        }else {
            [[tools shared] HUDShowHideText:@"加载失败" delay:1.5];
        }
        
        if ([_tableView.header isRefreshing]) {
            [_tableView.header endRefreshing];
        }else {
            [_tableView.footer endRefreshing];
        }
        
        if (isNull) {
            _currentPage -= 1;
        }
        [_tableView reloadData];
        
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

#pragma mark - tableView   delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 150;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc] init];
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 150)];
    [MyTool setImgWithURLStr:_GroupInfo.logo withplaceholderImage:[UIImage imageNamed:@"course_titbg.png"] withImgView:img];
    img.contentMode = UIViewContentModeScaleAspectFill;
    img.clipsToBounds = YES;
    [bgView addSubview:img];
    
//    (15, 32, 20, 20);

    if (_GroupInfo.content.length > 0) {
      CGFloat width = [_GroupInfo.content boundingRectWithSize:CGSizeMake(UI_SCREEN_WIDTH - 90, 30) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size.width;
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(45, 64, width, 30)];
        label1.text = _GroupInfo.content;
        label1.backgroundColor = ColorWithRGBA(30.0, 32.0, 40.0, 0.5);
        label1.textColor = [UIColor whiteColor];
        [bgView addSubview:label1];
    }
    NSString *str = @"午夜团抢购";
    CGFloat width = [str boundingRectWithSize:CGSizeMake(UI_SCREEN_WIDTH - 90, 20) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.width;
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(45, 64 + 30 + 15, width, 20)];
    label2.text = str;
    label2.font = [UIFont systemFontOfSize:15];
    label2.backgroundColor = ColorWithRGBA(30.0, 32.0, 40.0, 0.5);
    label2.textColor = [UIColor whiteColor];
    [bgView addSubview:label2];

    return bgView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BaseCellModel *model = _dataArray[indexPath.row];
    GoodsVC *vc = [[GoodsVC alloc] init];
    vc.goodsId = model.modelId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[BaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    BaseCellModel *model = _dataArray[indexPath.row];
    cell.type = 39;
    cell.model = model;
    cell.cellView.userInteractionEnabled = NO;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (UI_SCREEN_WIDTH - 20) + 70 + 20;
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
