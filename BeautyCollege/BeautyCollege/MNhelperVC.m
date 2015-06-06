//
//  MNhelperVC.m
//  BeautyCollege
//
//  Created by 于洲 on 15/5/5.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "MNhelperVC.h"

@interface MNhelperVC ()

@property (nonatomic, strong) NSMutableArray        *dataArr;
@property (nonatomic, strong) NSMutableArray        *statusArr;
@property (nonatomic, strong) UIButton              *leftBtn;
@property (nonatomic, strong) UIButton              *rightBtn;

@property (nonatomic, strong) UIView                *markView;
@property (nonatomic, assign) NSInteger             index;

@end

@implementation MNhelperVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationItem.title = @"美娘小助手";
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = ColorWithRGBA(218.0, 225.0, 227.0, 1);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArr = [[NSMutableArray alloc] init];
    _statusArr = [[NSMutableArray alloc] init];
    
    [self buildTopView];

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 + 80, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 64 - 80) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    UIView *view = [UIView new];
    _tableView.tableFooterView = view;
    [self.view addSubview:_tableView];
    [self loadData];
}

- (void)buildTopView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, UI_SCREEN_WIDTH, 60)];
    view.backgroundColor = [UIColor whiteColor];
    
    _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftBtn.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH / 2.0, 60);
    [_leftBtn setTitle:@"社区" forState:UIControlStateNormal];
    _leftBtn.tag = 10;
    _index = 0;
    _leftBtn.selected = YES;
    [_leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_leftBtn addTarget:self action:@selector(changeOption:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_leftBtn];
    
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtn.frame = CGRectMake(_leftBtn.right, 0, _leftBtn.width, 60);
    [_rightBtn setTitle:@"超市" forState:UIControlStateNormal];
    [_rightBtn addTarget:self action:@selector(changeOption:) forControlEvents:UIControlEventTouchUpInside];
    [_rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _rightBtn.tag = 11;
    [view addSubview:_rightBtn];
    
    _markView = [[UIView alloc] initWithFrame:CGRectMake(0, _leftBtn.bottom - 3, _leftBtn.width, 3)];
    _markView.backgroundColor = BaseColor;
    [view addSubview:_markView];
    [self.view addSubview:view];
}

- (void)changeOption:(UIButton *)btn
{
    if (btn.selected) {
        return;
    }

    if (btn.tag == 10) {
        _leftBtn.selected = YES;
        _rightBtn.selected = NO;
        _index = 0;
    }else{
        _leftBtn.selected = NO;
        _rightBtn.selected = YES;
        _index = 1;
    }
    
    CGRect rect = _markView.frame;
    rect.origin.x = UI_SCREEN_WIDTH / 2.0 * _index;
    _markView.frame = rect;
    
    [self loadData];
    
}

- (void)loadData
{
    NSString *str = [NSString stringWithFormat:@"mobi/index/getHelp?type=%ld&pageNo=1&pageSize=100",_index + 1];
    [[HttpManager shareManger] getWithStr:str ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
        if ([[json objectForKey:@"code"] integerValue] == 0) {
            [_dataArr removeAllObjects];
            [_statusArr removeAllObjects];
            NSDictionary *resultDic = nilOrJSONObjectForKey(json, @"result");
            NSArray *array = nilOrJSONObjectForKey(resultDic, @"data");
            for (NSDictionary *dic in array) {
                BaseCellModel *model = [[BaseCellModel alloc] init];
                model.title = nilOrJSONObjectForKey(dic, @"title");
                model.content = nilOrJSONObjectForKey(dic, @"content");
                [_dataArr addObject:model];
                [_statusArr addObject:@"1"];
            }
            [_tableView reloadData];
        }
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[_statusArr objectAtIndex:section] isEqualToString:@"1"]) {
        return 0;
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_dataArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.backgroundColor = ColorWithRGBA(218.0, 225.0, 227.0, 1);
        UILabel *label = [[UILabel alloc] init];
        label.tag = 10000;
        label.numberOfLines = 0;
        [cell.contentView addSubview:label];
    }
    
    BaseCellModel *model = _dataArr[indexPath.section];
    NSString *str = model.content;
    CGFloat size = [str boundingRectWithSize:CGSizeMake(UI_SCREEN_WIDTH - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size.height;
    
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:10000];
    label.frame = CGRectMake(10, 10, UI_SCREEN_WIDTH - 20, size);
    label.text = str;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    BaseCellModel *model = _dataArr[section];
    CGFloat labelHeight = [model.title boundingRectWithSize:CGSizeMake(UI_SCREEN_WIDTH - 60 , 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17]} context:nil].size.height;

    return labelHeight + 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseCellModel *model = _dataArr[indexPath.section];
    NSString *str = model.content;
    CGFloat size = [str boundingRectWithSize:CGSizeMake(UI_SCREEN_WIDTH - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size.height;
    return size + 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    
    UILabel *label = [[UILabel alloc] init];
    BaseCellModel *model = _dataArr[section];
    view.backgroundColor = [UIColor whiteColor];
    CGFloat labelHeight = [model.title boundingRectWithSize:CGSizeMake(UI_SCREEN_WIDTH - 60 , 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17]} context:nil].size.height;
    label.numberOfLines = 0;
    label.frame = CGRectMake(10, 10, UI_SCREEN_WIDTH - 60, labelHeight);
    label.font = [UIFont boldSystemFontOfSize:17];
    label.text = model.title;
    [view addSubview:label];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(UI_SCREEN_WIDTH - 40, labelHeight / 2.0, 20, 20);
    if ([[_statusArr objectAtIndex:section] isEqualToString:@"1"]) {
            //未展开
        [btn setImage:[UIImage imageNamed:@"icon_b.png"] forState:UIControlStateNormal];
    }else {
            //展开
        [btn setImage:[UIImage imageNamed:@"icon_a.png"] forState:UIControlStateNormal];
    }
    [view addSubview:btn];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, labelHeight + 20);
    button.tag = section;
    [button addTarget:self action:@selector(open:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, labelHeight + 19.5, UI_SCREEN_WIDTH, 0.5)];
    lineView.backgroundColor = [UIColor blackColor];
    [view addSubview:lineView];
    
    
    return view;
}

- (void)open:(UIButton *)btn
{
    if ([[_statusArr objectAtIndex:btn.tag] isEqualToString:@"1"]) {
        
        [_statusArr replaceObjectAtIndex:btn.tag withObject:@"2"];
    }else {
        [_statusArr replaceObjectAtIndex:btn.tag withObject:@"1"];

    }
    [_tableView reloadData];
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
