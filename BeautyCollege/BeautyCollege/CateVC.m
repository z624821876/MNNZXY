//
//  CateVC.m
//  BeautyCollege
//
//  Created by 于洲 on 15/5/27.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "CateVC.h"
#import "MJRefresh.h"
#import "GoodsVC.h"

@interface CateVC ()
{
    UITextField         *_searchTF;
    UIView              *_markView;
    UIButton            *_currentBtn;
    NSMutableArray      *_dataArray;
}

@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation CateVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationItem.title = @"全部";
    self.view.backgroundColor = ColorWithRGBA(218.0, 225.0, 227.0, 1);
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"baobei_c.png"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 60, 60);
    [btn setTitle:@"0" forState:UIControlStateNormal];
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
}

    //查看购物车
- (void)shoppingcart
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _currentPage = 1;
    _dataArray = [NSMutableArray array];
    [self buildOptionView];
    CGFloat height = 64 + 30 * UI_scaleY + 30 + 45 + 20;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, height, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self loadData];
    
    NSString *str = [NSString stringWithFormat:@"mobi/pro/getShoppingCartCount?memberId=%@",[User shareUser].userId];
    [[HttpManager shareManger] getWithStr:str ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
        if ([[json objectForKey:@"code"] integerValue] == 0) {

            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setImage:[UIImage imageNamed:@"baobei_c.png"] forState:UIControlStateNormal];
            btn.frame = CGRectMake(0, 0, 60, 60);
            [btn setTitle:[NSString stringWithFormat:@"%@",[json objectForKey:@"result"]] forState:UIControlStateNormal];
            btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
            //    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"baobei_c.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(shoppingcart)];
            self.navigationItem.rightBarButtonItem = item;

        }
        
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

- (void)loadData
{
    NSArray *orderByArr = @[@"sold",@"price",@"hot"];
    NSString *str = [NSString stringWithFormat:@"mobi/pro/getProductList?type=all&category=%@&keywords=%@&orderBy=%@&page=%ld&rows=10",_cateId,_cateTitle,orderByArr[_currentBtn.tag],_currentPage];
    [[tools shared] HUDShowText:@"正在加载..."];
    [[HttpManager shareManger] getWithStr:str ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
        [[tools shared] HUDHide];
        BOOL isNull = YES;
        if ([[json objectForKey:@"code"] integerValue] == 0) {
            if (_currentPage == 1) {
                [_dataArray removeAllObjects];
            }
            NSDictionary *resultDic = nilOrJSONObjectForKey(json, @"result");
            NSArray *array = nilOrJSONObjectForKey(resultDic, @"result");
            for (NSDictionary *dict in array) {
                isNull = NO;
                BaseCellModel *model = [[BaseCellModel alloc] init];
                model.modelId = nilOrJSONObjectForKey(dict, @"id");
                model.logo = nilOrJSONObjectForKey(dict, @"detailImage");
                model.name = nilOrJSONObjectForKey(dict, @"name");
                model.price = [MyTool getValuesFor:dict key:@"price"];
                model.buyedCount = [MyTool getValuesFor:dict key:@"buyedCount"];
                [_dataArray addObject:model];
            }
        }else {
            [[tools shared] HUDShowHideText:[json objectForKey:@"message"] delay:1.0];
        }
        
        if (isNull) {
            _currentPage -= 1;
        }
        [self refrensh];
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _currentPage -= 1;
        [self refrensh];
    }];
}

- (void)refrensh
{
    if ([_tableView.header isRefreshing]) {
        [_tableView.header endRefreshing];
    }else {
        [_tableView.footer endRefreshing];
    }
    [_tableView reloadData];
}

- (void)buildOptionView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, UI_SCREEN_WIDTH, 30 * UI_scaleY + 30 + 45)];
    view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(15, 30 * UI_scaleY, UI_SCREEN_WIDTH - 30, 35)];
    [img setImage:[UIImage imageNamed:@"07-超市_11.png"]];
    img.contentMode = UIViewContentModeScaleAspectFit;
//    img.clipsToBounds = YES;
    [view addSubview:img];
    
    _searchTF = [[UITextField alloc] initWithFrame:CGRectMake(img.left + 40 * UI_scaleX, img.top, img.width - 40 * UI_scaleX - 10, 35)];
    _searchTF.text = _cateTitle;
    _searchTF.delegate = self;
    _searchTF.returnKeyType = UIReturnKeySearch;
    [view addSubview:_searchTF];
    
    NSArray *array = @[@"销量",@"价格",@"人气"];
    for (NSInteger i = 0; i < 3; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(UI_SCREEN_WIDTH / 3.0 * i, img.bottom, UI_SCREEN_WIDTH / 3.0, 40);
        [btn setTitle:array[i] forState:UIControlStateNormal];
        if (i == 0) {
            btn.selected = YES;
            _currentBtn = btn;
        }
        btn.tag = i;
        [btn addTarget:self action:@selector(changeOption:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:20];
        [view addSubview:btn];
    }
    
    _markView = [[UIView alloc] initWithFrame:CGRectMake(0, view.height - 2, UI_SCREEN_WIDTH / 3.0, 2)];
    _markView.backgroundColor = BaseColor;
    [view addSubview:_markView];
    [self.view addSubview:view];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField.text.length > 0) {
        if (![textField.text isEqualToString:_cateTitle]) {
            _cateTitle = textField.text;
            _currentPage = 1;
            [self loadData];
        }
    }
    return YES;
}

- (void)changeOption:(UIButton *)btn
{
    if (btn.selected) {
        return;
    }
    
    btn.selected = YES;
    _currentBtn.selected = NO;
    _currentBtn = btn;
    CGRect rect = _markView.frame;
    rect.origin.x = UI_SCREEN_WIDTH / 3.0 * btn.tag;
    _markView.frame = rect;
    _currentPage = 1;
    [self loadData];
    
}


#pragma mark - tableView   delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[BaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.model = _dataArray[indexPath.row];
    cell.type = 38;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BaseCellModel *model = _dataArray[indexPath.row];
    GoodsVC *vc = [[GoodsVC alloc] init];
    vc.goodsId = model.modelId;
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
