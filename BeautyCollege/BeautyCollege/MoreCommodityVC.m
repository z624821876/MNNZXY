//
//  MoreCommodityVC.m
//  BeautyCollege
//
//  Created by 于洲 on 15/5/4.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "MoreCommodityVC.h"
#import "MJRefresh.h"
#import "GoodsVC.h"

@interface MoreCommodityVC ()
@property (nonatomic, strong) NSMutableArray            *dataArray;
@property (nonatomic, assign) NSInteger                 currentPage;

@end

@implementation MoreCommodityVC
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationItem.title = @"更多宝贝";
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc] init];
    _currentPage = 1;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    UIView *view = [UIView new];
    _tableView.tableFooterView = view;
    [self.view addSubview:_tableView];
    __weak typeof(self) weakself = self;
    [_tableView addLegendHeaderWithRefreshingBlock:^{
        weakself.currentPage = 1;
        [weakself loadData];
    }];
    
    [_tableView addLegendFooterWithRefreshingBlock:^{
        weakself.currentPage += 1;
        [weakself loadData];
    }];
    
    [_tableView.header beginRefreshing];
}

- (void)loadData
{
    NSString *str3 = [NSString stringWithFormat:@"mobi/pro/getProductList?page=%ld&rows=10&type=",_currentPage];
    [[tools shared] HUDShowText:@"正在加载"];
    [[HttpManager shareManger] getWithStr:str3 ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
        [[tools shared] HUDHide];
        if (_currentPage == 1) {
            [_dataArray removeAllObjects];
        }
        if ([[json objectForKey:@"code"] integerValue] == 0) {
            NSDictionary *dict = nilOrJSONObjectForKey(json, @"result");
            NSArray *array = nilOrJSONObjectForKey(dict, @"result");
            for (NSDictionary *dic in array) {
                BaseCellModel *model = [[BaseCellModel alloc] init];
                model.modelId = nilOrJSONObjectForKey(dic, @"id");
                model.catId = nilOrJSONObjectForKey(dic, @"catId");
                model.title = nilOrJSONObjectForKey(dic, @"name");
                NSNumber *number = nilOrJSONObjectForKey(dic, @"price");
                model.price = [number stringValue];
                model.logo = nilOrJSONObjectForKey(dic, @"detailImage");
                NSNumber *student = nilOrJSONObjectForKey(dic, @"studentCount");
                model.studentCount = student == nil ? @"0" : [student stringValue];
                NSNumber *homework = nilOrJSONObjectForKey(dic, @"todayHomeworkCount");
                model.homeworkCount = homework == nil ? @"0" : [homework stringValue];
                [_dataArray addObject:model];
                
            }
            if ([array count] == 0) {
                _currentPage -= 1;
            }
            
        }else {
            _currentPage -= 1;
        }
        if ([_tableView.header isRefreshing]) {
            [_tableView.header endRefreshing];
        }else {
            [_tableView.footer endRefreshing];
        }
        
        
        [_tableView reloadData];
        
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ([_tableView.header isRefreshing]) {
            [_tableView.header endRefreshing];
        }else {
            [_tableView.footer endRefreshing];
        }
        
        _currentPage -= 1;
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[BaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dorm_b.png"]];
        
    }
    cell.model = _dataArray[indexPath.row];
    cell.type = 22;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BaseCellModel *model = _dataArray[indexPath.row];
    GoodsVC *vc = [[GoodsVC alloc] init];
    vc.goodsId = model.modelId;
    vc.catId = model.catId;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];

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
