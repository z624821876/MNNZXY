//
//  ShoppingcartVC.m
//  BeautyCollege
//
//  Created by 于洲 on 15/5/23.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "ShoppingcartVC.h"
#import "Shopcatcell.h"
#import "OrderVC.h"

@interface ShoppingcartVC ()
{
    NSMutableArray      *_dataArray;
    NSMutableArray      *_typeArray;
    
    UIButton            *_selectBtn;
    UIButton            *_settlementBtn;
    UIButton            *_deleteBtn;
    
    NSString            *_price;
    NSInteger           _type;
}

@end

@implementation ShoppingcartVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationItem.title = @"我的购物袋";
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(set)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)set
{    if (_type == 1) {
        
                _type = 2;
                self.navigationItem.rightBarButtonItem = nil;
                UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(set)];
                self.navigationItem.rightBarButtonItem = item;
                _deleteBtn.hidden = NO;
        [_tableView reloadData];
        
    }else {
        
        if ([_dataArray count] <= 0) {
            return;
        }
        NSMutableArray *array = [NSMutableArray array];
        for (BaseCellModel *model in _dataArray) {
            NSString *str = [NSString stringWithFormat:@"%@:%@",model.modelId,model.count];
            [array addObject:str];
        }
        NSString *idStr = [array componentsJoinedByString:@","];
        NSString *url = [NSString stringWithFormat:@"mobi/pro/changeNumber?memberId=%@&idList=%@",[User shareUser].userId,idStr];
        [[HttpManager shareManger] getWithStr:url ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
            if ([[json objectForKey:@"code"] integerValue] == 0) {
                _type = 1;
                _deleteBtn.hidden = YES;
                self.navigationItem.rightBarButtonItem = nil;
                UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(set)];
                self.navigationItem.rightBarButtonItem = item;
                [_tableView reloadData];
                
            }else {
                [[tools shared] HUDShowHideText:@"操作失败" delay:1.5];
            }
            
        } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            
        }];

        
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _type = 1;
    _dataArray = [NSMutableArray array];
    _typeArray = [NSMutableArray array];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 64 + 20, UI_SCREEN_WIDTH - 20, UI_SCREEN_HEIGHT - 64 - 20 - 40) style:UITableViewStylePlain];
    UIView *view = [UIView new];
    _tableView.tableFooterView = view;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [self buildFootView];
}

- (void)selectGoods:(UIButton *)btn
{
    NSInteger i;
    if (btn.selected) {
        i = 1;
    }else {
        i = 2;
    }
    for (BaseCellModel *model in _dataArray) {
        
        model.type = i;
    }
    btn.selected = !btn.selected;
    [_tableView reloadData];
}

- (void)deleteGoods
{
    NSString *str = [NSString stringWithFormat:@"type == 2"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:str];
    NSArray *array = [_dataArray filteredArrayUsingPredicate:predicate];
    if ([array count] <= 0) {
        return;
    }
    [[tools shared] HUDShowText:@"正在删除..."];
    NSMutableArray *idArray = [NSMutableArray array];
    for (BaseCellModel *model in array) {
        [idArray addObject:model.modelId];
        [_dataArray removeObject:model];
    }
    NSString *idString = [idArray componentsJoinedByString:@","];
    NSString *url = [NSString stringWithFormat:@"mobi/pro/removeShoppingCart?memberId=%@&cartItemIds=%@",[User shareUser].userId,idString];
    [[HttpManager shareManger] getWithStr:url ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
        if ([[json objectForKey:@"code"] integerValue] == 0) {
            [[tools shared] HUDShowHideText:@"删除成功" delay:1.5];
            for (BaseCellModel *model in array) {
                [_dataArray removeObject:model];
            }
            [_tableView reloadData];
        }else {
            [[tools shared] HUDShowHideText:@"删除失败" delay:1.5];

        }
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

- (void)buildFootView
{
    _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectBtn.frame = CGRectMake(0, UI_SCREEN_HEIGHT - 40, UI_SCREEN_WIDTH / 2.0, 40);
    [_selectBtn setTitle:@"全选" forState:UIControlStateNormal];
    [_selectBtn addTarget:self action:@selector(selectGoods:) forControlEvents:UIControlEventTouchUpInside];
    [_selectBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_selectBtn setImage:[UIImage imageNamed:@"reg8.png"] forState:UIControlStateNormal];
    [_selectBtn setImage:[UIImage imageNamed:@"reg9.png"] forState:UIControlStateSelected];
    [self.view addSubview:_selectBtn];
    _selectBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);

    _settlementBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _settlementBtn.frame = CGRectMake(_selectBtn.right, _selectBtn.top, _selectBtn.width, 40);
    [_settlementBtn setTitle:@"结算(￥0)" forState:UIControlStateNormal];
    [_settlementBtn setTitleColor:BaseColor forState:UIControlStateNormal];
    [_settlementBtn setImage:[UIImage imageNamed:@"pay.png"] forState:UIControlStateNormal];
    [_settlementBtn addTarget:self action:@selector(settlement:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_settlementBtn];
    
    _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _deleteBtn.frame = CGRectMake(0, _selectBtn.top, UI_SCREEN_WIDTH, 40);
    [_deleteBtn setImage:[UIImage imageNamed:@"shopCat-delete.png"] forState:UIControlStateNormal];
    _deleteBtn.backgroundColor = [UIColor whiteColor];
    [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    _deleteBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    _deleteBtn.hidden = YES;
    [_deleteBtn addTarget:self action:@selector(deleteGoods) forControlEvents:UIControlEventTouchUpInside];
    [_deleteBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.view addSubview:_deleteBtn];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, _selectBtn.top, UI_SCREEN_WIDTH, 0.5)];
    view.backgroundColor = [UIColor grayColor];
    [self.view addSubview:view];
}

- (void)settlement:(UIButton *)btn
{
    NSString *str = [NSString stringWithFormat:@"type == 2"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:str];
    NSArray *array = [_dataArray filteredArrayUsingPredicate:predicate];
    if ([array count] <= 0) {
        [[tools shared] HUDShowHideText:@"请选择商品" delay:1.5];
        return;
    }
    NSMutableArray *toBuyList = [NSMutableArray array];
    for (BaseCellModel *model in array) {
        [toBuyList addObject:model.modelId];
    }
    NSString *List = [toBuyList componentsJoinedByString:@","];
    NSString *url = [NSString stringWithFormat:@"mobi/pro/saveToBuy?memberId=%@&toBuyList=%@",[User shareUser].userId,List];
    [[tools shared] HUDShowText:@"请稍候..."];
    [[HttpManager shareManger] getWithStr:url ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {

        if ([[json objectForKey:@"code"] integerValue] == 0) {
            [[tools shared] HUDHide];
            OrderVC *vc = [[OrderVC alloc] init];
            vc.type = 2;
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            [[tools shared] HUDShowHideText:@"提交失败" delay:1.5];
        }
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self loadData];
}

- (void)loadData
{
    [[tools shared] HUDShowText:@"正在加载..."];
    NSString *str = [NSString stringWithFormat:@"mobi/pro/getShoppingCart?memberId=%@",[User shareUser].userId];
    [[HttpManager shareManger] getWithStr:str ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
        if ([[json objectForKey:@"code"] integerValue] == 0) {
            [[tools shared] HUDHide];
            [_dataArray removeAllObjects];
            [_typeArray removeAllObjects];
            NSDictionary *resultDic = nilOrJSONObjectForKey(json, @"result");
            NSArray *array = nilOrJSONObjectForKey(resultDic, @"cartItemList");
            for (NSDictionary *dict in array) {
                _price = [MyTool getValuesFor:resultDic key:@"totalPrice"];
                //                shoppingCartId
                BaseCellModel *model = [[BaseCellModel alloc] init];
                model.title = nilOrJSONObjectForKey(dict, @"productName");
                model.modelId = nilOrJSONObjectForKey(dict, @"id");
                model.name = nilOrJSONObjectForKey(dict, @"paramName");
                model.logo = nilOrJSONObjectForKey(dict, @"img");
                model.price = [MyTool getValuesFor:dict key:@"price"];
                model.count = [MyTool getValuesFor:dict key:@"number"];
                model.type = 1;
                [_dataArray addObject:model];
                [_typeArray addObject:@"1"];
            }
            NSString *price = [NSString stringWithFormat:@"结算(%.2f)",[_price doubleValue]];
            [_settlementBtn setTitle:price forState:UIControlStateNormal];
            [_tableView reloadData];
        }else {
            [[tools shared] HUDShowHideText:@"加载失败" delay:1.5];
        }
        
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseCellModel *model = _dataArray[indexPath.row];
    if (model.type == 1) {
        model.type = 2;
    }else {
        model.type = 1;
    }
    [_tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Shopcatcell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        
        cell = [[Shopcatcell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.type = _type;
    cell.model = [_dataArray objectAtIndex:indexPath.row];
    cell.reduceBtn.tag = indexPath.row;
    cell.addBtn.tag = indexPath.row;
    [cell.reduceBtn addTarget:self action:@selector(changeCount:) forControlEvents:UIControlEventTouchUpInside];
    [cell.addBtn addTarget:self action:@selector(changeCount:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)changeCount:(UIButton *)btn
{
    BaseCellModel *model = _dataArray[btn.tag];
    if ([btn.currentTitle isEqualToString:@"r"] && [model.count isEqualToString:@"1"]) {
        return;
    }
    NSInteger i;
    if ([btn.currentTitle isEqualToString:@"r"]) {
        i = -1;
    }else {
        i = +1;
    }
    
    NSInteger count = [model.count integerValue];
    model.count = [NSString stringWithFormat:@"%ld",count + i];
    [_tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
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
