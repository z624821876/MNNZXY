//
//  AddressList.m
//  BeautyCollege
//
//  Created by 于洲 on 15/5/7.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "AddressList.h"
#import "AddAddressVC.h"
#import "addressCell.h"

@interface AddressList ()

@property (nonatomic, strong) NSMutableArray        *addressListArr;

@property (nonatomic, assign) NSInteger             selectIndex;

@end

@implementation AddressList

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationItem.title = @"我的收货地址";
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.addressListArr = [NSMutableArray array];
    [self buildFooterView];
    _selectIndex = 10086;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 64, UI_SCREEN_WIDTH - 20, UI_SCREEN_HEIGHT - 64 - 50) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_addressListArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    addressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[addressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.contentView.userInteractionEnabled = YES;
    cell.deleteBnt.tag = indexPath.section;
    cell.selectBtn.tag = indexPath.section + 20;
    if (cell.selectBtn.tag == _selectIndex) {
        cell.selectBtn.selected = YES;
    }else {
        cell.selectBtn.selected = NO;
    }
    cell.model = [_addressListArr objectAtIndex:indexPath.section];
//    cell.selectBtn.backgroundColor = [UIColor redColor];
    
    [cell.selectBtn addTarget:self action:@selector(selectAddress:) forControlEvents:UIControlEventTouchUpInside];
    [cell.deleteBnt addTarget:self action:@selector(deleteAddress:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)deleteAddress:(UIButton *)btn
{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"是否删除此地址" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = btn.tag;
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        BaseCellModel *model = [_addressListArr objectAtIndex:alertView.tag];
        NSString *str = [NSString stringWithFormat:@"mobi/address/delete?id=%@",model.modelId];
        
        [[HttpManager shareManger] getWithStr:str ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
            if ([[json objectForKey:@"code"] integerValue] == 0) {
                
                [[tools shared] HUDShowHideText:@"删除成功" delay:1.5];
                [_addressListArr removeObject:model];
                [_tableView reloadData];
                
            }else {
                [[tools shared] HUDShowHideText:@"删除失败" delay:1.5];
            }
        } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];

        
    }
}

    //选择默认收货地址
- (void)selectAddress:(UIButton *)btn
{
    if (btn.selected) {
        _selectIndex = 10086;
        [_tableView reloadData];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"addressId"];
        return;
    }
    _selectIndex = btn.tag;
    [_tableView reloadData];
    BaseCellModel *model = [_addressListArr objectAtIndex:btn.tag - 20];
    [[NSUserDefaults standardUserDefaults] setObject:model.modelId forKey:@"addressId"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 10 + 60 + 15 * UI_scaleY + (30 + 5 * UI_scaleY) * 2 + 30 + 10 + 30;
}

- (void)viewDidAppear:(BOOL)animated
{
    NSString *str = [NSString stringWithFormat:@"/mobi/address/list?memberId=%@",[User shareUser].userId];
    [[HttpManager shareManger] getWithStr:str ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
        if ([[json objectForKey:@"code"] integerValue] == 0) {
            [_addressListArr removeAllObjects];
            NSArray *array = nilOrJSONObjectForKey(json, @"result");
            for (NSDictionary *dic in array) {
                BaseCellModel *model = [[BaseCellModel alloc] init];
                NSNumber *number = nilOrJSONObjectForKey(dic, @"id");
                model.modelId = [number stringValue];
                model.name = nilOrJSONObjectForKey(dic, @"name");
                model.address = nilOrJSONObjectForKey(dic, @"address");
                NSNumber *postCode = nilOrJSONObjectForKey(dic, @"cityId");
                model.postcode = [postCode stringValue];
                model.mobile = nilOrJSONObjectForKey(dic, @"mobile");
                [_addressListArr addObject:model];
            }
            
            NSString *addressId = [[NSUserDefaults standardUserDefaults] objectForKey:@"addressId"];
            if (addressId != nil && ![addressId isKindOfClass:[NSNull class]]) {
                NSString *str = [NSString stringWithFormat:@"modelId == '%@'",addressId];
                NSPredicate *predicate = [NSPredicate predicateWithFormat:str];
                BaseCellModel *model = [[_addressListArr filteredArrayUsingPredicate:predicate] firstObject];
                if ([_addressListArr containsObject:model]) {
                    _selectIndex = [_addressListArr indexOfObject:model] + 20;
                }else {
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"addressId"];
                }
            }
            [_tableView reloadData];
        }
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

- (void)buildFooterView
{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, UI_SCREEN_HEIGHT - 50, UI_SCREEN_WIDTH, 50)];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 50)];
    [btn setTitle:@"添加新地址" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [footView addSubview:btn];
    [btn addTarget:self action:@selector(addAddress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:footView];
}

- (void)addAddress
{
    AddAddressVC *vc = [[AddAddressVC alloc] init];
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
