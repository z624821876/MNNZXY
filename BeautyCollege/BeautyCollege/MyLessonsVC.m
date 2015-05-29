//
//  MyLessonsVC.m
//  BeautyCollege
//
//  Created by 于洲 on 15/5/29.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "MyLessonsVC.h"
#import "MJRefresh.h"
#import "LessonsVC.h"


@interface MyLessonsVC ()
@property (nonatomic, assign) NSInteger         currentPage;
@property (nonatomic, strong) NSMutableArray    *dataArray;

@end

@implementation MyLessonsVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if (_type == 0) {
        
        self.navigationItem.title = @"我创建的课堂";
    }else {
        self.navigationItem.title = @"我参加的课堂";
    }
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
    NSString *str = [NSString stringWithFormat:@"mobi/class/getMyLesson?classId=&memberId=%@&type=%ld&pageNo=%ld&pageSize=10",_userId,_type,_currentPage];

    [[tools shared] HUDShowText:@"正在加载..."];
    [[HttpManager shareManger] getWithStr:str ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
        BOOL isNull = YES;
        if ([[json objectForKey:@"code"] integerValue] == 0) {
            [[tools shared] HUDHide];
            if (_currentPage == 1) {
                
                [_dataArray removeAllObjects];
            }
            NSDictionary *dic = [json objectForKey:@"result"];
            NSDictionary *dataDic = nilOrJSONObjectForKey(dic, @"date");
            NSArray *array = nilOrJSONObjectForKey(dataDic, @"data");
            for (NSDictionary *dict in array) {
                isNull = NO;
                BaseCellModel *model = [[BaseCellModel alloc] init];
                model.logo = nilOrJSONObjectForKey(dict, @"image");
                model.title = nilOrJSONObjectForKey(dict, @"title");
                model.modelId = nilOrJSONObjectForKey(dict, @"id");
                NSNumber *studentNumber = nilOrJSONObjectForKey(dict, @"studentCount");
                model.studentCount = [studentNumber stringValue];
                NSNumber *homeworkNumber = nilOrJSONObjectForKey(dict, @"todayHomeworkCount");
                model.homeworkCount = [homeworkNumber stringValue];
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
    LessonsVC *vc = [[LessonsVC alloc] init];
    vc.lessonsId = model.modelId;
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
