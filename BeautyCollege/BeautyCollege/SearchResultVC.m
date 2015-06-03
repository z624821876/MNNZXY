//
//  SearchResultVC.m
//  BeautyCollege
//
//  Created by 于洲 on 15/6/3.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "SearchResultVC.h"
#import "MJRefresh.h"
#import "ClassmateInfoVC.h"
#import "LessonsVC.h"

@interface SearchResultVC ()

@property (nonatomic, strong) NSMutableArray    *dataArray;
@property (nonatomic, assign) NSInteger         currentPage;
@end

@implementation SearchResultVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if (_searchtype == 1) {
        //课堂
        self.navigationItem.title = @"为你找到如下课堂";
    }else {
        //作业
        self.navigationItem.title = @"搜索结果";
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _currentPage = 1;
    _dataArray = [NSMutableArray array];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    UIView *view = [UIView new];
    _tableView.tableFooterView = view;
    __weak typeof(self) weakSelf = self;
    [_tableView addLegendHeaderWithRefreshingBlock:^{
        
        weakSelf.currentPage = 1;
        [weakSelf loadData];
    }];
    [_tableView addLegendFooterWithRefreshingBlock:^{
        weakSelf.currentPage += 1;
        [weakSelf loadData];
    }];
    
    [self.view addSubview:_tableView];
    [_tableView.header beginRefreshing];
}

- (void)loadData
{
    NSString *str;
    if (_searchtype == 1) {
        str = [NSString stringWithFormat:@"mobi/class/searchLessons?keyword=%@&pageNo=%ld&pageSize=10",self.keyword,_currentPage];
    }else {
        str = [NSString stringWithFormat:@"mobi/user/searchUser?nickname=%@&memberId=%@&pageNo=%ld&pageSize=10",self.keyword,[User shareUser].userId,_currentPage];
    }
    [[tools shared] HUDShowText:@"正在加载..."];
    [[HttpManager shareManger] getWithStr:str ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
        [[tools shared] HUDHide];
        BOOL isNull = YES;
        if ([[json objectForKey:@"code"] integerValue] == 0) {
            if (_currentPage == 1) {
                [_dataArray removeAllObjects];
            }
            NSDictionary *resultDic = nilOrJSONObjectForKey(json, @"result");
            NSArray *array = nilOrJSONObjectForKey(resultDic, @"data");
            for (NSDictionary *dict in array) {
                isNull = NO;
                BaseCellModel *model = [[BaseCellModel alloc] init];
                if (_searchtype == 1) {
                    model.logo = nilOrJSONObjectForKey(dict, @"image");

                    model.title = nilOrJSONObjectForKey(dict, @"title");
                }else {
                    model.logo = nilOrJSONObjectForKey(dict, @"logo");
                    model.city = nilOrJSONObjectForKey(dict, @"cityName");
                    model.name = nilOrJSONObjectForKey(dict, @"nickname");
                }
                model.modelId = nilOrJSONObjectForKey(dict, @"id");
                NSNumber *studentNumber = nilOrJSONObjectForKey(dict, @"studentCount");
                model.studentCount = [studentNumber stringValue];
                NSNumber *homeworkNumber = nilOrJSONObjectForKey(dict, @"todayHomeworkCount");
                model.homeworkCount = [homeworkNumber stringValue];
                [_dataArray addObject:model];
            }
        }else {
            [[tools shared] HUDShowHideText:@"加载失败" delay:1.0];
        }
        if (isNull) {
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

#pragma mark - tableView delegate
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
    
    cell.model = _dataArray[indexPath.row];
    if (_searchtype == 1) {
        cell.type = 13;
    }else {
        cell.type = 19;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_searchtype == 1) {
        return 80;
    }
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BaseCellModel *model = _dataArray[indexPath.row];
    if (_searchtype == 1) {
        LessonsVC *vc = [[LessonsVC alloc] init];
        vc.lessonsId = model.modelId;
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        ClassmateInfoVC *vc = [[ClassmateInfoVC alloc] init];
        vc.ClassmateId = model.modelId;
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
