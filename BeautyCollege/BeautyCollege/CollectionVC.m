//
//  CollectionVC.m
//  BeautyCollege
//
//  Created by 于洲 on 15/5/25.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "CollectionVC.h"
#import "MJRefresh.h"
#import "HomeworkVC.h"
#import "GoodsVC.h"

@interface CollectionVC ()
{
    UIView          *_markView;
    NSMutableArray  *_homeworkArray;
    NSMutableArray  *_goodsArray;
}
@property (nonatomic, strong) UIButton      *currentBtn;
@property (nonatomic, assign) NSInteger     currentPage1;
@property (nonatomic, assign) NSInteger     currentPage2;

@end

@implementation CollectionVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationItem.title = @"我的收藏";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _currentPage1 = 1;
    _currentPage2 = 1;
    _goodsArray = [[NSMutableArray alloc] init];
    _homeworkArray = [[NSMutableArray alloc] init];
    [self buildOptionView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 + 50, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 64 - 50) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = ColorWithRGBA(218.0, 225.0, 227.0, 1);
    UIView *view = [UIView new];
    _tableView.tableFooterView = view;
    [self.view addSubview:_tableView];
    
    __weak typeof(self) weakSelf = self;
    [_tableView addLegendFooterWithRefreshingBlock:^{
        if (weakSelf.currentBtn.tag == 10) {
            weakSelf.currentPage1 = 1;
            [weakSelf loadData1];
        }else {
            weakSelf.currentPage2 = 1;
            [weakSelf loadData2];
        }
    }];
    [_tableView addLegendHeaderWithRefreshingBlock:^{
        if (weakSelf.currentBtn.tag == 10) {
            weakSelf.currentPage1 += 1;
            [weakSelf loadData1];
        }else {
            weakSelf.currentPage2 += 1;
            [weakSelf loadData2];
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [[tools shared] HUDShowText:@"正在加载"];
    _currentPage1 = 1;
    _currentPage2 = 1;
    [self loadData1];
    [self loadData2];
}

- (void)refrenshTableView
{
    [[tools shared] HUDHide];
    if ([_tableView.header isRefreshing]) {
        [_tableView.header endRefreshing];
    }else {
        [_tableView.footer endRefreshing];
    }
    [_tableView reloadData];
}

    //作业
- (void)loadData1
{
    NSString *str = [NSString stringWithFormat:@"mobi/class/getFavouriteHomework?memberId=%@&pageNo=%ld&pageSize=10",[User shareUser].userId,_currentPage1];
    [[HttpManager shareManger] getWithStr:str ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
        if (_currentPage1 == 1) {
            [_homeworkArray removeAllObjects];
        }
        BOOL isNull = NO;
        if ([[json objectForKey:@"code"] integerValue] == 0) {
            NSDictionary *resultDic = nilOrJSONObjectForKey(json, @"result");
            NSArray *array = nilOrJSONObjectForKey(resultDic, @"data");
            for (NSDictionary *dict in array) {
                isNull = YES;
                NSDictionary *memberDic = nilOrJSONObjectForKey(dict, @"member");
                NSDictionary *blogDic = nilOrJSONObjectForKey(dict, @"blog");
                BaseCellModel *model = [[BaseCellModel alloc] init];
                model.likeId = [MyTool getValuesFor:dict key:@"likeId"];
                model.collectId = [MyTool getValuesFor:dict key:@"favouriteId"];
                
                NSNumber *num = nilOrJSONObjectForKey(blogDic, @"ct");
                model.date = [num stringValue];
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
                [_homeworkArray addObject:model];
                NSNumber *number = nilOrJSONObjectForKey(blogDic, @"ct");
                model.date = [number stringValue];
                model.job = nilOrJSONObjectForKey(memberDic, @"levelName");
                model.likeId = [MyTool getValuesFor:dict key:@"likeId"];
                model.collectId = [MyTool getValuesFor:dict key:@"favouriteId"];

            }
        }
        if (!isNull) {
            _currentPage1 -= 1;
        }
        [self refrenshTableView];
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _currentPage1 -= 1;
    }];

}
    //宝贝
- (void)loadData2
{
    NSString *str = [NSString stringWithFormat:@"mobi/pro/getFavouriteProduct?memberId=%@&pageNo=%ld&pageSize=10",[User shareUser].userId,_currentPage2];
    [[HttpManager shareManger] getWithStr:str ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
        if (_currentPage2 == 1) {
            [_goodsArray removeAllObjects];
        }
        BOOL isNull = NO;
        if ([[json objectForKey:@"code"] integerValue] == 0) {
            NSDictionary *resultDic = nilOrJSONObjectForKey(json, @"result");
            NSArray *array = nilOrJSONObjectForKey(resultDic, @"result");
            for (NSDictionary *dic in array) {
                BaseCellModel *model = [[BaseCellModel alloc] init];
                model.modelId = nilOrJSONObjectForKey(dic, @"id");
                model.name = nilOrJSONObjectForKey(dic, @"name");
                model.logo = nilOrJSONObjectForKey(dic, @"detailImage");
                model.price = [MyTool getValuesFor:dic key:@"marketPrice"];
                model.discountPrice = [MyTool getValuesFor:dic key:@"price"];
                model.type = [array indexOfObject:dic];
                [_goodsArray addObject:model];
            }
        }
        if (!isNull) {
            _currentPage2 -= 1;
        }
        [self refrenshTableView];

    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _currentPage2 -= 1;
    }];
}

- (void)buildOptionView
{
    UIView *optionView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, UI_SCREEN_WIDTH, 50)];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH / 2.0, 50);
    [leftBtn setTitle:@"作业" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    leftBtn.tag = 10;
    [leftBtn addTarget:self action:@selector(changeOption:) forControlEvents:UIControlEventTouchUpInside];
    [optionView addSubview:leftBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(leftBtn.right, 0, UI_SCREEN_WIDTH / 2.0, 50);
    [rightBtn setTitle:@"宝贝" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    rightBtn.tag = 11;
    [rightBtn addTarget:self action:@selector(changeOption:) forControlEvents:UIControlEventTouchUpInside];
    [optionView addSubview:rightBtn];
    
    
    leftBtn.selected = YES;
    _currentBtn = leftBtn;
    _markView = [[UIView alloc] initWithFrame:CGRectMake(0, 47, leftBtn.width, 3)];
    _markView.backgroundColor = BaseColor;
    [optionView addSubview:_markView];
    
    [self.view addSubview:optionView];
}

- (void)changeOption:(UIButton *)btn
{
    if (btn.selected) {
        return;
    }
    _currentBtn.selected = NO;
    _currentBtn = btn;
    _currentBtn.selected = YES;
    
    CGRect rect = _markView.frame;
    rect.origin.x = _currentBtn.left;
    _markView.frame = rect;
    [_tableView reloadData];
}

#pragma mark - tableView  delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_currentBtn.tag == 10) {
        //作业
        return [_homeworkArray count];
    }else {
        //宝贝
        return ([_goodsArray count] + 1) / 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[BaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if (_currentBtn.tag == 10) {
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.backgroundColor = _tableView.backgroundColor;
        cell.model = _homeworkArray[indexPath.row];
        cell.type = 36;
        cell.btn1.tag = indexPath.row;
        [cell.btn1 addTarget:self action:@selector(deleteHomework:) forControlEvents:UIControlEventTouchUpInside];
    }else {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        NSMutableArray *array = [NSMutableArray array];
        NSInteger num = indexPath.row * 2;
        BaseCellModel *model1 = _goodsArray[num];
        [array addObject:model1];
        [cell.cellView.countBtn addTarget:self action:@selector(deleteGoods:) forControlEvents:UIControlEventTouchUpInside];
        if ((num + 1) < [_goodsArray count]) {
            BaseCellModel *model2 = _goodsArray[num + 1];
            [array addObject:model2];
            [cell.cellView2.countBtn addTarget:self action:@selector(deleteGoods:) forControlEvents:UIControlEventTouchUpInside];
        }
        cell.type = 37;
        cell.modelArray = array;
        
        cell.cellView.tag = num;
        [cell.cellView setTitle:@"l" forState:UIControlStateNormal];
        [cell.cellView setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [cell.cellView addTarget:self action:@selector(goodsClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.cellView2.tag = num;
        [cell.cellView2 setTitle:@"r" forState:UIControlStateNormal];
        [cell.cellView2 setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [cell.cellView2 addTarget:self action:@selector(goodsClick:) forControlEvents:UIControlEventTouchUpInside];

    }
    
    return cell;
}

- (void)goodsClick:(UIButton *)btn
{
    BaseCellModel *model;
    if ([btn.currentTitle isEqualToString:@"l"]) {
        model = _goodsArray[btn.tag];
    }else {
        model = _goodsArray[btn.tag + 1];
    }
    GoodsVC *vc = [[GoodsVC alloc] init];
    vc.goodsId = model.modelId;
    vc.catId = model.catId;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)deleteGoods:(UIButton *)btn
{
    BaseCellModel *model = _goodsArray[btn.tag];
    NSString *urlStr = [NSString stringWithFormat:@"mobi/pro/addFavourite?productId=%@&memberId=%@",model.modelId,[User shareUser].userId];

    [[HttpManager shareManger] getWithStr:urlStr ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
    if ([[json objectForKey:@"code"] integerValue] == 0) {
        [_goodsArray removeObject:model];
        [_tableView reloadData];
    }else {
        [[tools shared] HUDShowHideText:@"操作失败" delay:1.0];
    }
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    }];
}

- (void)deleteHomework:(UIButton *)btn
{
    BaseCellModel *model = _homeworkArray[btn.tag];
    NSString *string = [NSString stringWithFormat:@"mobi/class/addFavourite?memberId=%@&blogId=%@",[User shareUser].userId,model.modelId];
    [[HttpManager shareManger] getWithStr:string ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
        if ([[json objectForKey:@"code"] integerValue] == 0) {
            [_homeworkArray removeObject:model];
            [_tableView reloadData];
        }else {
            [[tools shared] HUDShowHideText:@"操作失败" delay:1.5];
        }
        
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_currentBtn.tag == 10) {
        return 80;
    }else {
        return (UI_SCREEN_WIDTH - 30) / 2.0 + 90;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_currentBtn.tag == 10) {
        
        BaseCellModel *model = _homeworkArray[indexPath.section];
        HomeworkVC *vc = [[HomeworkVC alloc] init];
        vc.homworkModel = model;
        vc.homeworkId = model.modelId;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void)didReceiveMemoryWarning
{
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
