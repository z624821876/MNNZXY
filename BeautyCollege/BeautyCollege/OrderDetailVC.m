//
//  OrderDetailVC.m
//  BeautyCollege
//
//  Created by 于洲 on 15/6/4.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "OrderDetailVC.h"
#import "OrderCell.h"

@interface OrderDetailVC ()
{
    UILabel         *_orderNoLabel;
    UILabel         *_orderTimeLabel;
    UILabel         *_orderStatusLabel;
    UILabel         *_priceLabel;
    UILabel         *_mobileLabel;
    UILabel         *_addressLabel;
    UILabel         *_postFeeLabel;
    UILabel         *_nameLable;
    UILabel         *_CustomerserviceLabel;
    
    UIView          *_bgView;
    UIImageView     *_bgImg;
}
@property (nonatomic, strong) BaseCellModel         *orderInfo;
@property (nonatomic, strong) NSMutableArray        *dataArray;

@end

@implementation OrderDetailVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationItem.title = @"订单详情";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [NSMutableArray array];
    _orderInfo = [[BaseCellModel alloc] init];
    [self initGUI];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self loadData];
}

- (void)loadData
{
    NSString *Str = [NSString stringWithFormat:@"mobi/order/getOrderDetail?orderId=%@",self.orderId];
    [[tools shared] HUDShowText:@"请稍后"];
    [[HttpManager shareManger] getWithStr:Str ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
        [[tools shared] HUDHide];
        if ([[json objectForKey:@"code"] integerValue] == 0) {
            [_dataArray removeAllObjects];
            NSDictionary *dic = nilOrJSONObjectForKey(json, @"result");
            NSDictionary *order = nilOrJSONObjectForKey(dic, @"order");
            NSDictionary *address = nilOrJSONObjectForKey(dic, @"address");
            _orderInfo.orderNo = nilOrJSONObjectForKey(order, @"orderNo");
            _orderInfo.date = nilOrJSONObjectForKey(order, @"createTime");
            _orderInfo.status = [MyTool getValuesFor:order key:@"status"];
            _orderInfo.price = [MyTool getValuesFor:order key:@"totalFee"];
            _orderInfo.discountPrice = [MyTool getValuesFor:order key:@"expressFee"];
            _orderInfo.address = nilOrJSONObjectForKey(address, @"address");
            _orderInfo.name = nilOrJSONObjectForKey(address, @"name");
            _orderInfo.mobile = [MyTool getValuesFor:address key:@"mobile"];
            NSArray *items = nilOrJSONObjectForKey(order, @"items");
            for (NSDictionary *dic in items) {
                BaseCellModel *model1 = [[BaseCellModel alloc] init];
                model1.title = nilOrJSONObjectForKey(dic, @"productName");
                model1.name = nilOrJSONObjectForKey(dic, @"elements");
                model1.logo = nilOrJSONObjectForKey(dic, @"productImg");
                model1.price = [MyTool getValuesFor:dic key:@"totalFee"];
                model1.count = [MyTool getValuesFor:dic key:@"num"];
                [_dataArray addObject:model1];
            }
            [self updateGUI];

        }else {
            [[tools shared] HUDShowHideText:@"加载失败" delay:1.5];
        }
    
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

- (void)updateGUI
{
    _orderNoLabel.text = [NSString stringWithFormat:@"订单号: %@",_orderInfo.orderNo];
    _orderTimeLabel.text = [NSString stringWithFormat:@"订单时间: %@",_orderInfo.date];
    NSString *status;
    switch ([_orderInfo.status integerValue]) {
        case 0:
        {
            status = @"待付款";
        }
            break;
        case 1:
        {
            status = @"已付款";
            
        }
            break;
        case 2:
        {
            status = @"待收货";
        }
            break;
        case 3:
        {
            status = @"待评价";
            
        }
            break;
        case 9:
        {
            status = @"评论完成";
            
        }
            break;
        case 6:
        {
            status = @"交易取消";
        }
            break;
            
        default:
            break;
    }
    NSString *string = [NSString stringWithFormat:@"订单状态: %@",status];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:string];
    [attStr addAttributes:@{NSForegroundColorAttributeName:BaseColor} range:[string rangeOfString:status]];
    _orderStatusLabel.attributedText = attStr;
    
    NSString *priceStr1 = [NSString stringWithFormat:@"￥%.2f",[_orderInfo.price doubleValue]];
    NSString *priceStr2 = [NSString stringWithFormat:@"实付款:%@",priceStr1];
    NSMutableAttributedString *attStr2 = [[NSMutableAttributedString alloc] initWithString:priceStr2];
    [attStr2 addAttributes:@{NSForegroundColorAttributeName:BaseColor} range:[priceStr2 rangeOfString:priceStr1]];
    _priceLabel.attributedText = attStr2;
    
    _addressLabel.text = _orderInfo.address;
    _nameLable.text = _orderInfo.name;
    _mobileLabel.text = _orderInfo.mobile;
    
    _postFeeLabel.text = [NSString stringWithFormat:@"￥%.2f",[_orderInfo.discountPrice doubleValue]];
    
    
    
    for (BaseCellModel *model in _dataArray) {
        OrderCell *cell = [[OrderCell alloc] initWithFrame:CGRectMake(10, _bgImg.top + 40 + 100 * [_dataArray indexOfObject:model], _bgImg.width, 100) withModel:model];
        [_scrollView addSubview:cell];
    }
    
    CGRect rect = _bgImg.frame;
    rect.size.height = 40 + 100 * [_dataArray count] + 10;
    _bgImg.frame = rect;
    
    CGRect rect2 = _bgView.frame;
    rect2.origin.y = _bgImg.bottom + 15;
    _bgView.frame = rect2;
    
    _scrollView.contentSize = CGSizeMake(UI_SCREEN_WIDTH, _bgView.bottom + 20);
}

- (void)initGUI
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 64)];
    [self.view addSubview:_scrollView];
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, UI_SCREEN_WIDTH - 20, 110)];
    [img setImage:[UIImage imageNamed:@"blank_num.png"]];
    [_scrollView addSubview:img];
    
    _orderNoLabel = [[UILabel alloc] initWithFrame:CGRectMake(img.left + 10, img.top + 10, img.width - 20, 20)];
    _orderNoLabel.text = @"订单号:";
    _orderNoLabel.textColor = [UIColor grayColor];
    [_scrollView addSubview:_orderNoLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(img.left, _orderNoLabel.bottom + 10, img.width, 0.5)];
    lineView.backgroundColor = [UIColor grayColor];
    [_scrollView addSubview:lineView];
    
    _orderTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_orderNoLabel.left, lineView.bottom + 10, _orderNoLabel.width, 20)];
    _orderTimeLabel.text = @"订单时间:";
    _orderTimeLabel.textColor = [UIColor grayColor];
    [_scrollView addSubview:_orderTimeLabel];
    
    _orderStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(_orderNoLabel.left, _orderTimeLabel.bottom + 10, _orderNoLabel.width, 20)];
    _orderStatusLabel.text = @"订单状态";
    _orderStatusLabel.textColor = [UIColor grayColor];
    [_scrollView addSubview:_orderStatusLabel];
    
    _bgImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, img.bottom + 15, img.width, 50)];
    [_bgImg setImage:[[UIImage imageNamed:@"blank_num.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)]];
    [_scrollView addSubview:_bgImg];
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_bgImg.left + 10, _bgImg.top + 10, _bgImg.width - 20, 20)];
    _priceLabel.text = @"实付款:";
    [_scrollView addSubview:_priceLabel];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(_bgImg.left, _priceLabel.bottom + 10, _bgImg.width, 0.5)];
    lineView2.backgroundColor = [UIColor grayColor];
    [_scrollView addSubview:lineView2];
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, _bgImg.bottom + 15, UI_SCREEN_WIDTH, 270)];
    [_scrollView addSubview:_bgView];
    
    UIImageView *img2 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, UI_SCREEN_WIDTH - 20, 160)];
    [img2 setImage:[UIImage imageNamed:@"blank_num.png"]];
    [_bgView addSubview:img2];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(img2.left + 10, img2.top + 10, img2.width - 20, 20)];
    label.text = @"收货地址";
    [_bgView addSubview:label];
    
    UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(img2.left, label.bottom + 10, img2.width, 0.5)];
    lineView3.backgroundColor = [UIColor grayColor];
    [_bgView addSubview:lineView3];

    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(img2.left + 10, lineView3.bottom + 20, 40, 20)];
    label2.text = @"地址";
    label2.font = [UIFont systemFontOfSize:15];
    label2.textColor = [UIColor grayColor];
    [_bgView addSubview:label2];
    
    _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(label2.right + 10, lineView3.bottom + 10, img2.right - label2.right - 20, 40)];
    _addressLabel.numberOfLines = 0;
    _addressLabel.textColor = [UIColor grayColor];
    _addressLabel.font = [UIFont systemFontOfSize:15];
    [_bgView addSubview:_addressLabel];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(label2.left, _addressLabel.bottom + 10, 40, 20)];
    label3.text = @"姓名";
    label3.font = [UIFont systemFontOfSize:15];
    label3.textColor = [UIColor grayColor];
    [_bgView addSubview:label3];
    
    _nameLable = [[UILabel alloc] initWithFrame:CGRectMake(_addressLabel.left, label3.top, _addressLabel.width, 20)];
    _nameLable.font = [UIFont systemFontOfSize:15];
    _nameLable.textColor = [UIColor grayColor];
    [_bgView addSubview:_nameLable];
    
    UILabel *lable4 = [[UILabel alloc] initWithFrame:CGRectMake(label3.left, label3.bottom + 10, 40, 20)];
    lable4.text = @"电话";
    lable4.font = [UIFont systemFontOfSize:15];
    lable4.textColor = [UIColor grayColor];
    [_bgView addSubview:lable4];
    
    _mobileLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLable.left, _nameLable.bottom + 10, _nameLable.width, 20)];
    _mobileLabel.font = [UIFont systemFontOfSize:15];
    _mobileLabel.textColor = [UIColor grayColor];
    [_bgView addSubview:_mobileLabel];
    
    UIImageView *img3 = [[UIImageView alloc] initWithFrame:CGRectMake(10, img2.bottom + 15, UI_SCREEN_WIDTH - 20, 40)];
    [img3 setImage:[UIImage imageNamed:@"blank_num.png"]];
    [_bgView addSubview:img3];
    
    UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(img3.left + 10, img3.top + 10, 40, 20)];
    label5.text = @"快递";
    [_bgView addSubview:label5];
    
    _postFeeLabel = [[UILabel alloc] initWithFrame:CGRectMake(img3.right - 100, label5.top, 90, 20)];
    _postFeeLabel.font = [UIFont systemFontOfSize:15];
    _postFeeLabel.textColor = BaseColor;
    _postFeeLabel.textAlignment = NSTextAlignmentRight;
    [_bgView addSubview:_postFeeLabel];
    
    UIImageView *img4 = [[UIImageView alloc] initWithFrame:CGRectMake(10, img3.bottom + 15, UI_SCREEN_WIDTH - 20, 40)];
    [img4 setImage:[UIImage imageNamed:@"blank_num.png"]];
    [_bgView addSubview:img4];

    _CustomerserviceLabel = [[UILabel alloc] initWithFrame:CGRectMake(img4.left + 10, img4.top + 10, img4.width - 20, 20)];
    _CustomerserviceLabel.text = @"客服电话:10086";
    _CustomerserviceLabel.textColor = [UIColor grayColor];
    [_bgView addSubview:_CustomerserviceLabel];
    
    _scrollView.contentSize = CGSizeMake(UI_SCREEN_WIDTH, _bgView.bottom + 20);

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
