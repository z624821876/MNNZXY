//
//  OrderVC.m
//  BeautyCollege
//
//  Created by 于洲 on 15/5/20.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "OrderVC.h"
#import "OrderCell.h"
#import "ChooseAddressVC.h"
#import "PayVC.h"

@interface OrderVC ()
{
    UILabel         *_totalPriceLabel;
    UIView          *_bgView1;
    UIView          *_bgView2;
    UIView          *_bgView3;
    
    UILabel         *_label2_1;
    UILabel         *_label2_2;
    UILabel         *_label2_3;

    UILabel         *_postFeeLable;
    NSMutableArray  *_dataArray;
    CGFloat         _totalPice;
    CGFloat         _postFee;
    BaseCellModel   *currentAddress;
}

@end

@implementation OrderVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationItem.title = @"确认订单";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _totalPice = 0;
    _postFee = 0;
    _dataArray = [[NSMutableArray alloc] init];
    [self buildFooterView];
    [self initGUI];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self loadData];
}

- (void)buildFooterView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, UI_SCREEN_HEIGHT - 40 * UI_scaleY, UI_SCREEN_WIDTH, 40 * UI_scaleY)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    _totalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.width / 2.0, view.height)];
    _totalPriceLabel.textAlignment = NSTextAlignmentCenter;
    _totalPriceLabel.textColor = BaseColor;
    _totalPriceLabel.text = @"合计:0";
    [view addSubview:_totalPriceLabel];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(_totalPriceLabel.right, 0, _totalPriceLabel.width, view.height);
    [btn setImage:[UIImage imageNamed:@"ico_cfmorder.png"] forState:UIControlStateNormal];
    [btn setTitle:@"支付" forState:UIControlStateNormal];
    [btn setTitleColor:BaseColor forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(buy) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
}

    //点击支付
- (void)buy
{
    if (currentAddress == nil || [currentAddress isKindOfClass:[NSNull class]]) {
        [[tools shared] HUDShowHideText:@"请选择地址" delay:1.5];
        return;
    }
    NSString *str;
    if (_type == 1) {
        //直接购买
        str = [NSString stringWithFormat:@"mobi/order/buyNow?memberId=%@&contactId=%@&postFee=%@",[User shareUser].userId,currentAddress.modelId,currentAddress.price];
    }else {
        //购物车
        str = [NSString stringWithFormat:@"mobi/order/order?memberId=%@&contactId=%@&postFee=%@",[User shareUser].userId,currentAddress.modelId,currentAddress.price];
    }
    [[tools shared] HUDShowText:@"生成订单中..."];
    [[HttpManager shareManger] getWithStr:str ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
        [[tools shared] HUDHide];
        if ([[json objectForKey:@"code"] integerValue] == 0) {
            
            NSDictionary *dic = nilOrJSONObjectForKey(json, @"result");
            if ([dic isKindOfClass:[NSDictionary class]]) {
                
                NSString *time = nilOrJSONObjectForKey(dic, @"createTime");
                NSString *orderNo = nilOrJSONObjectForKey(dic, @"orderNo");
                NSString *totalFee = nilOrJSONObjectForKey(dic, @"totalFee");
                NSString *orderId = [MyTool getValuesFor:dic key:@"id"];
                PayVC *vc = [[PayVC alloc] init];
                vc.orderDate = time;
                vc.orderId = orderId;
                vc.orderNo = orderNo;
                vc.totalPrice = totalFee;
                [self.navigationController pushViewController:vc animated:YES];

            }else {

                [[tools shared] HUDShowHideText:[json objectForKey:@"message"] delay:1.5];
            }
            
            
        }else {
            [[tools shared] HUDShowHideText:[json objectForKey:@"message"] delay:1.5];
        }
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];

}


- (void)initGUI
{
    _scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 64 - 40 * UI_scaleY)];
    [self.view addSubview:_scroll];
    _bgView1 = [[UIView alloc] initWithFrame:CGRectMake(10, 10, UI_SCREEN_WIDTH - 20, 100)];
    UIImageView *img =[[UIImageView alloc] initWithFrame:_bgView1.bounds];
    [img setImage:[[UIImage imageNamed:@"blank_num.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
    img.tag = 10086;
    [img setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [_bgView1 addSubview:img];
    [_scroll addSubview:_bgView1];
    
    _bgView2 = [[UIView alloc] initWithFrame:CGRectMake(10, _bgView1.bottom + 10, UI_SCREEN_WIDTH - 20, 210)];
    UIImageView *img2 =[[UIImageView alloc] initWithFrame:_bgView2.bounds];
    [img2 setImage:[[UIImage imageNamed:@"blank_num.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
    [img2 setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [_bgView2 addSubview:img2];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 150, 30)];
    label.font = [UIFont boldSystemFontOfSize:20];
    label.text = @"收货地址";
    [_bgView2 addSubview:label];
    UIImageView *nextImg = [[UIImageView alloc] initWithFrame:CGRectMake(_bgView2.width - 30, 15, 20, 20)];
    nextImg.contentMode = UIViewContentModeScaleAspectFit;
    [nextImg setImage:[UIImage imageNamed:@"add_address.png"]];
    [_bgView2 addSubview:nextImg];
    
    UIButton *nextbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextbtn.frame = CGRectMake(0, 0, _bgView2.width, 50);
    [nextbtn addTarget:self action:@selector(chooseAddress) forControlEvents:UIControlEventTouchUpInside];
    [_bgView2 addSubview:nextbtn];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5, _bgView2.width, 0.5)];
    lineView.backgroundColor = [UIColor grayColor];
    [_bgView2 addSubview:lineView];
    NSArray *array = @[@"地址",@"姓名",@"电话"];
    _label2_1 = [[UILabel alloc] init];
    _label2_1.numberOfLines = 2;
    _label2_2 = [[UILabel alloc] init];
    _label2_3 = [[UILabel alloc] init];
    [_bgView2 addSubview:_label2_1];
    [_bgView2 addSubview:_label2_3];
    [_bgView2 addSubview:_label2_2];
    NSArray *labelArr = @[_label2_1,_label2_2,_label2_3];
    for (NSInteger i = 0; i < 3; i ++) {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, lineView.bottom + 10 + 50 * i, 40, 30)];
        lab.text = array[i];
        lab.font = [UIFont boldSystemFontOfSize:15];
        lab.textAlignment = NSTextAlignmentCenter;
        [_bgView2 addSubview:lab];
        
        UILabel *lab2_0 = labelArr[i];
        lab2_0.frame = CGRectMake(lab.right + 10, lab.top - 5, _bgView2.width - lab.right - 20, 40);
        lab2_0.font = [UIFont systemFontOfSize:15];
    }
    
    [_scroll addSubview:_bgView2];
    
    
    _bgView3 = [[UIView alloc] initWithFrame:CGRectMake(10, _bgView2.bottom + 10, UI_SCREEN_WIDTH - 20, 60)];
    UIImageView *img3 =[[UIImageView alloc] initWithFrame:_bgView3.bounds];
    [img3 setImage:[[UIImage imageNamed:@"blank_num.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
    [img3 setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [_bgView3 addSubview:img3];
    UILabel *lab3_1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 60, 30)];
    lab3_1.text = @"快递费";
    [_bgView3 addSubview:lab3_1];
    
    _postFeeLable = [[UILabel alloc] initWithFrame:CGRectMake(lab3_1.right + 10, 15, _bgView3.width - lab3_1.right - 20, 30)];
    _postFeeLable.textAlignment = NSTextAlignmentRight;
    _postFeeLable.font = [UIFont systemFontOfSize:15];
    _postFeeLable.textColor = BaseColor;
    _postFeeLable.text = @"0";
    [_bgView3 addSubview:_postFeeLable];
    
    [_scroll addSubview:_bgView3];
    
    _scroll.contentSize = CGSizeMake(UI_SCREEN_WIDTH, _bgView3.bottom);
}

- (void)chooseAddress
{
    ChooseAddressVC *vc = [[ChooseAddressVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loadData
{
    NSString *str;
    if (_type == 1) {
        //立即购买
        str = [NSString stringWithFormat:@"mobi/pro/getBuyNow?memberId=%@",[User shareUser].userId];
    }else {
        str = [NSString stringWithFormat:@"mobi/pro/getToBuy?memberId=%@",[User shareUser].userId];
    }
    [[tools shared] HUDShowText:@"请稍后..."];
    [[HttpManager shareManger] getWithStr:str ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
        [[tools shared] HUDHide];
        if ([[json objectForKey:@"code"] integerValue] == 0) {
            [_dataArray removeAllObjects];
            NSDictionary *resultDic = nilOrJSONObjectForKey(json, @"result");
            _totalPice = [[MyTool getValuesFor:resultDic key:@"totalPrice"] doubleValue];
            NSArray *array = nilOrJSONObjectForKey(resultDic, @"cartItemList");
            for (NSDictionary *dic in array) {
                BaseCellModel *model = [[BaseCellModel alloc] init];
                model.modelId = nilOrJSONObjectForKey(dic, @"productId");
                model.title = nilOrJSONObjectForKey(dic, @"productName");
                model.name = nilOrJSONObjectForKey(dic, @"paramName");
                model.count = [MyTool getValuesFor:dic key:@"number"];
                model.price = [MyTool getValuesFor:dic key:@"price"];
                model.logo = nilOrJSONObjectForKey(dic, @"img");
                [_dataArray addObject:model];
            }
            [self updateGUI];
        }else {
            [[tools shared] HUDShowHideText:@"加载失败" delay:1.5];
        }
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    
    NSString *str1 = [NSString stringWithFormat:@"/mobi/address/list?memberId=%@",[User shareUser].userId];
    [[HttpManager shareManger] getWithStr:str1 ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
        if ([[json objectForKey:@"code"] integerValue] == 0) {
            NSMutableArray *addressListArr = [[NSMutableArray alloc] init];
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
                model.price = [MyTool getValuesFor:dic key:@"expressFee"];
                [addressListArr addObject:model];
            }
            if ([addressListArr count] <= 0) {
                return;
            }
                NSString *addressId = [[NSUserDefaults standardUserDefaults] objectForKey:@"addressId"];
                NSString *str = [NSString stringWithFormat:@"modelId == '%@'",addressId];
                NSPredicate *predicate = [NSPredicate predicateWithFormat:str];
                BaseCellModel *model = [[addressListArr filteredArrayUsingPredicate:predicate] firstObject];
                if ([addressListArr containsObject:model]) {
                    currentAddress = model;
                }else {
                    currentAddress = [addressListArr firstObject];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"addressId"];
                }
                [self updateAddress];

            }
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

- (void)updateAddress
{
    _label2_1.text = currentAddress.address;
    _label2_2.text = currentAddress.name;
    _label2_3.text = currentAddress.mobile;
    
    _postFeeLable.text = currentAddress.price;
    _postFee = [currentAddress.price doubleValue];
    NSString *str1 = [NSString stringWithFormat:@"%.2f",_postFee + _totalPice];
    _totalPriceLabel.text = str1;
}

- (void)updateGUI
{
    for (UIView *view in _bgView1.subviews) {
        if (view.tag != 10086) {
            [view removeFromSuperview];
        }
    }
    for (BaseCellModel *model in _dataArray) {
        OrderCell *cell = [[OrderCell alloc] initWithFrame:CGRectMake(0, 10 + 120 * [_dataArray indexOfObject:model], _bgView1.width, 120) withModel:model];
        [_bgView1 addSubview:cell];
    }
    
    CGRect rect = _bgView1.frame;
    rect.size.height = 20 + [_dataArray count] * 120;
    _bgView1.frame = rect;
    
    CGRect rect1 = _bgView2.frame;
    rect1.origin.y = _bgView1.bottom + 10;
    _bgView2.frame = rect1;
    
    CGRect rect2 = _bgView3.frame;
    rect2.origin.y = _bgView2.bottom + 10;
    _bgView3.frame = rect2;

    NSString *str1 = [NSString stringWithFormat:@"%.2f",_postFee + _totalPice];
    _totalPriceLabel.text = str1;
    
    [_scroll setContentSize:CGSizeMake(UI_SCREEN_WIDTH, _bgView3.bottom + 20)];
    
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
