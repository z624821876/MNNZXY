//
//  InvitefriendsVC.m
//  BeautyCollege
//
//  Created by 于洲 on 15/5/29.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "InvitefriendsVC.h"
#import "MJRefresh.h"

@interface InvitefriendsVC ()
@property (nonatomic, assign) NSInteger         currentPage;
@property (nonatomic, strong) NSMutableArray    *dataArray;
@end

@implementation InvitefriendsVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationItem.title = @"我的邀请好友";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _currentPage = 1;
    _dataArray = [NSMutableArray array];

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *view = [UIView new];
    _tableView.tableFooterView = view;
    [self.view addSubview:_tableView];
    
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
    [self loadData];
}

- (void)loadData
{
    
    NSString *str = [NSString stringWithFormat:@"mobi/user/getInviteUser?memberId=%@&pageNo=%ld&pageSize=10",[User shareUser].userId,_currentPage];
    [[tools shared] HUDShowText:@"正在加载..."];
    [[HttpManager shareManger] getWithStr:str ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
        BOOL isNull = YES;
        if ([[json objectForKey:@"code"] integerValue] == 0) {
            [[tools shared] HUDHide];
            if (_currentPage == 1) {
                
                [_dataArray removeAllObjects];
            }
            NSArray *array = nilOrJSONObjectForKey(json, @"result");
            for (NSDictionary *dict in array) {
                isNull = NO;
                BaseCellModel *model = [[BaseCellModel alloc] init];
                model.modelId = nilOrJSONObjectForKey(dict, @"memberId");
                model.logo = nilOrJSONObjectForKey(dict, @"logo");
                model.date = nilOrJSONObjectForKey(dict, @"regTime");
                model.level = [MyTool getValuesFor:dict key:@"level"];
                model.name = nilOrJSONObjectForKey(dict, @"nickName");
                [_dataArray addObject:model];
            }
        }
        if ([_tableView.header isRefreshing]) {
            [_tableView.header endRefreshing];
        }
        
        if (isNull) {
            _currentPage -= 1;
        }
        
        [_tableView reloadData];
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];
}

#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[BaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.type = 40;
    cell.model = _dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
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
