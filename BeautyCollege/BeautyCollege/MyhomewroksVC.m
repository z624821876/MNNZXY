//
//  MyhomewroksVC.m
//  BeautyCollege
//
//  Created by 于洲 on 15/5/29.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "MyhomewroksVC.h"
#import "MJRefresh.h"
#import "HomeworkVC.h"

@interface MyhomewroksVC ()
@property (nonatomic, assign) NSInteger         currentPage;
@property (nonatomic, strong) NSMutableArray    *dataArray;

@end

@implementation MyhomewroksVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationItem.title = @"我发表的作业";
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _currentPage = 1;
    _dataArray = [NSMutableArray array];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
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
    NSString *str = [NSString stringWithFormat:@"mobi/class/getHomework?lessonId=0&pageNo=%ld&type=2&pageSize=10&memberId=%@",_currentPage,_userId];
    
    [[tools shared] HUDShowText:@"正在加载..."];
    [[HttpManager shareManger] getWithStr:str ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
        BOOL isNull = YES;
        if ([[json objectForKey:@"code"] integerValue] == 0) {
            [[tools shared] HUDHide];
            if (_currentPage == 1) {
                
                [_dataArray removeAllObjects];
            }
            NSDictionary *resultDic = nilOrJSONObjectForKey(json, @"result");
            NSDictionary *page = nilOrJSONObjectForKey(resultDic, @"page");
            NSArray *dataArr = nilOrJSONObjectForKey(page, @"data");
            for (NSDictionary *dict in dataArr) {
                isNull = NO;
                NSDictionary *memberDic = nilOrJSONObjectForKey(dict, @"member");
                NSDictionary *blogDic = nilOrJSONObjectForKey(dict, @"blog");
                BaseCellModel *model = [[BaseCellModel alloc] init];
                
                model.likeId = [MyTool getValuesFor:dict key:@"likeId"];
                model.collectId = [MyTool getValuesFor:dict key:@"favouriteId"];
                NSString *time = nilOrJSONObjectForKey(blogDic, @"createTime");
                model.date = [[time componentsSeparatedByString:@" "] firstObject];
                model.modelId = nilOrJSONObjectForKey(blogDic, @"id");
                model.name = nilOrJSONObjectForKey(memberDic, @"nickname");
                model.title = nilOrJSONObjectForKey(blogDic, @"title");
                NSNumber *sexNum = nilOrJSONObjectForKey(memberDic, @"sex");
                model.sex = [sexNum stringValue];
                NSNumber *levelNum = nilOrJSONObjectForKey(memberDic, @"level");
                model.level = [levelNum stringValue];
                model.logo = nilOrJSONObjectForKey(memberDic, @"logo");
                NSNumber *comment = nilOrJSONObjectForKey(blogDic, @"objId2");
                model.commentCount = [comment stringValue];
                NSNumber *likeCount = nilOrJSONObjectForKey(blogDic, @"objId1");
                model.likeCount = [likeCount stringValue];
    
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
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dorm_b.png"]];
    }
    cell.type = 20;
    cell.model = _dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BaseCellModel *model = _dataArray[indexPath.row];
    HomeworkVC *vc = [[HomeworkVC alloc] init];
    vc.homeworkId = model.modelId;
    vc.homworkModel = model;
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
