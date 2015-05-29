//
//  OrderLIstVC.m
//  BeautyCollege
//
//  Created by 于洲 on 15/5/20.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "OrderLIstVC.h"
#import "CommentVC.h"

@interface OrderLIstVC ()
{
    UIView              *_markView;
    UIButton            *_currentBtn;
    NSMutableArray      *_dataArray;
}

@end

@implementation OrderLIstVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationItem.title = @"我的订单";
    self.view.backgroundColor = ColorWithRGBA(218.0, 225.0, 227.0, 1);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc] init];
    [self buildOptionView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 + 40, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 64 - 40) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    UIView *view = [UIView new];
    _tableView.tableFooterView = view;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, UI_SCREEN_WIDTH, 50)];
    [img setImage:[[UIImage imageNamed:@"bg_class_top.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
    [view addSubview:img];
    
    BaseCellModel *model = _dataArray[section];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, UI_SCREEN_WIDTH - 120, 20)];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor grayColor];
    label.text = [NSString stringWithFormat:@"订单号:%@",model.orderNo];
    [view addSubview:label];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, label.bottom, UI_SCREEN_WIDTH - 120, 20)];
    label1.font = [UIFont systemFontOfSize:15];
    label1.textColor = [UIColor grayColor];
    label1.text = model.date;
    [view addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH - 100, 30, 90, 30)];
    label2.font = [UIFont boldSystemFontOfSize:20];
    label2.textColor = BaseColor;
    label2.textAlignment = NSTextAlignmentRight;
    
    switch ([model.status integerValue]) {
        case 0:
        {
            label2.text = @"待付款";

        }
            break;
        case 1:
        {
            label2.text = @"已付款";

        }
            break;
        case 2:
        {
            label2.text = @"已发货";
        }
            break;
        case 3:
        {
            label2.text = @"交易成功";

        }
            break;
        case 9:
        {
            label2.text = @"评论完成";

        }
            break;
        case 6:
        {
            label2.text = @"交易取消";
        }
            break;
            
        default:
            break;
    }
    
    [view addSubview:label2];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, label1.bottom + 4.5, UI_SCREEN_WIDTH, 0.5)];
    lineView.backgroundColor = [UIColor grayColor];
    [view addSubview:lineView];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 60)];
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 60)];
    [img setImage:[[UIImage imageNamed:@"bg_down1"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
    [view addSubview:img];
    
    UIButton *btn = [UIButton buttonWithType: UIButtonTypeCustom];
    btn.frame = CGRectMake(UI_SCREEN_WIDTH - 210, 15, 90, 30);
    btn.backgroundColor = BaseColor;
    [btn setTitle:@"订单详情" forState:UIControlStateNormal];
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    btn.tag = section;
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [view addSubview:btn];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(btn.right + 20, 15, 90, 30);
    btn2.backgroundColor = BaseColor;
    btn2.layer.cornerRadius = 5;
    btn2.layer.masksToBounds = YES;
    btn2.tag = section;
    NSString *str;
    BaseCellModel *model = _dataArray[section];
    switch ([model.status integerValue]) {
        case 0:
        {
            str = @"取消订单";
            
        }
            break;
        case 1:
        {
            str = @"评价订单";
        }
            break;
        case 2:
        {
            str = @"确认收货";
        }
            break;
        case 3:
        {
            str = @"删除订单";
            
        }
            break;
        case 9:
        case 6:
        {
            str = @"";
            btn2.hidden = YES;
        }
            break;
            
        default:
            break;
    }

    [btn2 setTitle:str forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(orderOperation:) forControlEvents:UIControlEventTouchUpInside];
    btn2.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [view addSubview:btn2];
    
    return view;
}

- (void)orderOperation:(UIButton *)btn
{
    CommentVC *vc = [[CommentVC alloc] init];
    
    BaseCellModel *model = _dataArray[0];
    vc.dataArray = model.cateArray;
    [self.navigationController pushViewController:vc animated:YES];
    
    /*
    BaseCellModel *model = _dataArray[btn.tag];
    if ([btn.currentTitle isEqualToString:@"取消订单"]) {
        NSString *str = [NSString stringWithFormat:@"mobi/order/cancelOrder?orderId=%@",model.modelId];
        [[HttpManager shareManger] getWithStr:str ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
            if ([[json objectForKey:@"code"] integerValue] == 0) {
                [[tools shared] HUDShowHideText:@"取消订单成功" delay:1.5];
                [self loadData];
            }
            
        } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            
        }];
    }else if ([btn.currentTitle isEqualToString:@"评价订单"]) {
        
    }else if ([btn.currentTitle isEqualToString:@"确认收货"]) {
        
    }else if ([btn.currentTitle isEqualToString:@"删除订单"]) {
        
    }
 */
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_dataArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    BaseCellModel *model = _dataArray[section];
    return [model.cateArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[BaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    BaseCellModel *model = _dataArray[indexPath.section];
    BaseCellModel *model1 = model.cateArray[indexPath.row];
    cell.model = model1;
    cell.type = 33;
    
    return cell;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self loadData];
}

- (void)loadData
{
    NSArray *typeArray = @[@"all",@"unpay",@"send",@"uncommented"];
    NSString *type = typeArray[_currentBtn.tag];
    NSString *str = [NSString stringWithFormat:@"mobi/order/getOrderList?memberId=%@&status=%@",[User shareUser].userId,type];
    [[tools shared] HUDShowText:@"正在加载..."];
    [[HttpManager shareManger] getWithStr:str ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
        [_dataArray removeAllObjects];
        [[tools shared] HUDHide];
        if ([[json objectForKey:@"code"] integerValue] == 0) {
            NSArray *resultArr = nilOrJSONObjectForKey(json, @"result");
            for (NSDictionary *dict in resultArr) {
                BaseCellModel *model = [[BaseCellModel alloc] init];
                model.modelId = nilOrJSONObjectForKey(dict, @"id");
                model.orderNo = nilOrJSONObjectForKey(dict, @"orderNo");
                model.status = [MyTool getValuesFor:dict key:@"status"];
                model.date = nilOrJSONObjectForKey(dict, @"createTime");
                NSMutableArray *array = [NSMutableArray array];
                NSArray *itemArr = nilOrJSONObjectForKey(dict, @"items");
                
                for (NSDictionary *dic in itemArr) {
                    BaseCellModel *model1 = [[BaseCellModel alloc] init];
                    model1.title = nilOrJSONObjectForKey(dic, @"productName");
                    model1.name = nilOrJSONObjectForKey(dic, @"elements");
                    model1.logo = nilOrJSONObjectForKey(dic, @"productImg");
                    model1.price = [MyTool getValuesFor:dic key:@"totalFee"];
                    model1.count = [MyTool getValuesFor:dic key:@"num"];
                    [array addObject:model1];
                }
                model.cateArray = array;
                
                [_dataArray addObject:model];
            }
            [_tableView reloadData];
        }else {
            [[tools shared] HUDShowText:@"加载失败"];
        }
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];

}

- (void)buildOptionView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, UI_SCREEN_WIDTH, 40)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    NSArray *array = @[@"全部订单",@"待付款",@"待收货",@"待评价"];
    for (NSInteger i = 0; i < 4; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i * UI_SCREEN_WIDTH / 4.0, 0, UI_SCREEN_WIDTH / 4.0, 40);
        [btn setTitle:array[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.tag = i;
        if (i == 0) {
            btn.selected = YES;
            _currentBtn = btn;
        }
        [btn addTarget:self action:@selector(changeOption:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
    }
    
    _markView = [[UIView alloc] initWithFrame:CGRectMake(0, 37, UI_SCREEN_WIDTH / 4.0, 3)];
    _markView.backgroundColor = BaseColor;
    [view addSubview:_markView];
}

- (void)changeOption:(UIButton *)btn
{
    if (btn.selected) {
        return;
    }
    _currentBtn.selected = NO;
    btn.selected = YES;
    _currentBtn = btn;
    
    CGRect rect = _markView.frame;
    rect.origin.x = btn.left;
    _markView.frame = rect;
    [self loadData];
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
