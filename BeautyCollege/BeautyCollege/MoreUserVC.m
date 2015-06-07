//
//  MoreUserVC.m
//  BeautyCollege
//
//  Created by 于洲 on 15/5/4.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "MoreUserVC.h"
#import "MJRefresh.h"
#import "ClassmateInfoVC.h"

@interface MoreUserVC ()
@property (nonatomic, strong) NSMutableArray        *dataArray;
@property (nonatomic, assign) NSInteger             currentPage;
@end

@implementation MoreUserVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if (_type == 1) {
        
        self.navigationItem.title = @"推荐用户";
    }else {
        self.navigationItem.title = @"搜寻结果";
    }
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
    NSString *str;
    if (_type == 1) {
        str = @"mobi/index/getRecUser?pageNo=1";
    }else {
        str = [NSString stringWithFormat:@"mobi/user/searchUser?nickname=%@&memberId=%@&pageNo=%ld&pageSize=10&sex=2",_keyword,[User shareUser].userId,_currentPage];
    }
    
    [[HttpManager shareManger] getWithStr:str ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
        [[tools shared] HUDHide];
        if (_type == 2) {
            if (_currentPage == 1) {
                [_dataArray removeAllObjects];
            }
            
        }else {
            [_dataArray removeAllObjects];
        }
        
        if ([[json objectForKey:@"code"] integerValue] == 0) {
            NSDictionary *dic = [json objectForKey:@"result"];
            if ([dic isKindOfClass:[NSDictionary class]]) {
                NSArray *array = [dic objectForKey:@"data"];
                for (NSDictionary *dic in array) {
                    BaseCellModel *model = [[BaseCellModel alloc] init];
                    model.modelId = nilOrJSONObjectForKey(dic, @"id");
                    model.name = nilOrJSONObjectForKey(dic, @"nickname");
                    model.city = nilOrJSONObjectForKey(dic, @"cityName");
                    model.logo = nilOrJSONObjectForKey(dic, @"logo");
                    [_dataArray addObject:model];
                }
                if ([array count] == 0) {
                    _currentPage -= 1;
                    [[tools shared] HUDShowHideText:@"暂无数据" delay:1.5];
                }
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
        _currentPage -= 1;
        if ([_tableView.header isRefreshing]) {
            [_tableView.header endRefreshing];
        }else {
            [_tableView.footer endRefreshing];
        }

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
    
    cell.type = 19;
    cell.model = _dataArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BaseCellModel *model = _dataArray[indexPath.row];
    ClassmateInfoVC *vc = [[ClassmateInfoVC alloc] init];
    vc.ClassmateId = model.modelId;
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
