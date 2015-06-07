//
//  PayVC.m
//  BeautyCollege
//
//  Created by 于洲 on 15/5/20.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "PayVC.h"
#import "Order.h"
#import <AlipaySDK/AlipaySDK.h>
#import "DataSigner.h"
#import "TemporaryVC.h"
#import "OrderLIstVC.h"
#import "IQKeyboardManager.h"

@interface PayVC ()
{
    UITextView  *_textView;
    UIButton    *_currentBtn;
}
@end

@implementation PayVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationItem.title = @"支付";
    [IQKeyboardManager sharedManager].enable = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(15, 64 + 20, UI_SCREEN_WIDTH - 30, UI_SCREEN_HEIGHT - 64 - 40)];
    [img setImage:[[UIImage imageNamed:@"blank_num.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)]];
    [self.view addSubview:img];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(img.left + 5, img.top + 10, img.width - 10, 30)];
    label.font = [UIFont systemFontOfSize:15];
    label.text = [NSString stringWithFormat:@"订单号:%@",self.orderNo];
    [self.view addSubview:label];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake( img.left, label.bottom + 10, img.width, 0.5)];
    lineView1.backgroundColor = [UIColor grayColor];
    [self.view addSubview:lineView1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(img.left + 5, lineView1.bottom + 10, label.width, 30)];
    label2.font = [UIFont systemFontOfSize:15];
    
    label2.text = [NSString stringWithFormat:@"订单时间:%@",self.orderDate];
    [self.view addSubview:label2];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(label2.left, label2.bottom + 10, label2.width, 30)];
    label3.textColor = BaseColor;
    label3.font = [UIFont systemFontOfSize:15];
    label3.text = [NSString stringWithFormat:@"实付款:￥%.2f",[self.totalPrice doubleValue]];
    [self.view addSubview:label3];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(img.left, label3.bottom + 10, img.width, 0.5)];
    lineView2.backgroundColor = [UIColor grayColor];
    [self.view addSubview:lineView2];
    
    UILabel *lable4 = [[UILabel alloc] initWithFrame:CGRectMake(label3.left, lineView2.bottom + 10, 80, 30)];
    lable4.text = @"给我留言:";
    lable4.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:lable4];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(lable4.right + 5, lable4.top, label3.width - lable4.right - 5, 100)];
    _textView.delegate = self;
    _textView.font = [UIFont systemFontOfSize:15];
    _textView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_textView];
    
    UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(label3.left, _textView.bottom + 10, 110, 30)];
    label5.text = @"付款方式:";
    label5.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:label5];
    
    NSArray *array = @[@"支付宝",@"银联"];
    for (NSInteger i = 0; i < 2; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(label5.right, label5.top + 35 * i, 200, 30);
        [btn setTitle:array[i] forState:UIControlStateNormal];
        btn.tag = 10 + i;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"reg8.png"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"reg9.png"] forState:UIControlStateSelected];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [btn addTarget:self action:@selector(changePayType:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = CGRectMake(50, label5.bottom + 40 * UI_scaleY, UI_SCREEN_WIDTH - 100, 35);
    btn.backgroundColor = BaseColor;
    [btn setTitle:@"确认支付" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    btn.layer.cornerRadius = 8;
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:@selector(doPay) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)changePayType:(UIButton *)btn
{
    if (btn.selected) {
        btn.selected = NO;
        _currentBtn = nil;
    }else {
        _currentBtn.selected = NO;
        btn.selected = YES;
        _currentBtn = btn;
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
//    CGRect rect = self.view.frame;
//    rect.origin.y = rect.origin.y - _textView.top + 74;
//    self.view.frame = rect;
//    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    return YES;
//    CGRect rect = self.view.frame;
//    rect.origin.y = 0;
//    self.view.frame = rect;
//    return YES;
}

- (void)back
{
    NSArray *array = self.navigationController.viewControllers;
    UIViewController *vc = [array objectAtIndex:array.count - 3];
    [self.navigationController popToViewController:vc animated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
        [self.view endEditing:YES];
}

- (void)doPay
{
    
    if (_currentBtn == nil || [_currentBtn isKindOfClass:[NSNull class]]) {
        [[tools shared] HUDShowHideText:@"请选择支付方式" delay:1.5];
        return;
    }
    
    NSString *str = [NSString stringWithFormat:@"mobi/order/updateOrder?orderId=%@&payMethod=%d&memo=%@",self.orderId,_currentBtn.tag - 10,_textView.text];

    [[HttpManager shareManger] getWithStr:str ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
        
        if ([[json objectForKey:@"code"] integerValue] == 0) {
            if (_currentBtn.tag == 10) {
                
                [self aliPay];
            }else {
                [self unionpay];
            }
        }else {
            [[tools shared] HUDShowHideText:@"提交订单失败" delay:1.5];
        }
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    
}

- (void)unionpay
{
    NSString *str = [NSString stringWithFormat:@"upion/gettn?orderId=%@",self.orderId];
    
    [[HttpManager shareManger] getWithStr:str ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
        if ([[json objectForKey:@"code"] integerValue] == 0) {
            
            NSString *str = nilOrJSONObjectForKey(json, @"result");
            [UPPayPlugin startPay:str mode:@"00" viewController:self delegate:self];
        }

    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            }];

}

-(void)UPPayPluginResult:(NSString*)result
{
    if ([result isEqualToString:@"success"]) {
        [self submitResult];
    }else {
        [[tools shared] HUDShowHideText:@"支付失败" delay:1.5];
    }

}

- (void)aliPay
{
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = @"2088811375507751";
    NSString *seller = @"yuezhang2005@aliyun.com";
    NSString *privateKey = @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAKSdhgdN5TCVcKQjJZxGK9EQzgpOvdrelBMmIUKiNzcSzlLZXx5WCCwPANp5CUBkOQFY5v+WhnIv/rdcVFbSCWeJ8y7jLIGebcGnnLafQxIWB1/3xwK4rQhne7jUJ/2od4Ac/PXBebjMLsNKHYSdY57zxMW3FcPiGqGLUBKK9hz9AgMBAAECgYEAmtrAoZBqgQijvRR/JgJw56wqV1H5kbJ+k4D0Gu3kiT98rj1kGHKQH3pBsEPaKyPc6GKMc3VTpol10WHeyQmu46A1QztICDkmIsCWg8985wE4kd8UuhGs1vJoDAcRyQ5ZzV/wx7g0hhZi2srzjyL/ujY3Rb5XYLLsqCUO7el9AhUCQQDWFQO7eUQiM2bF6fKncMHXo96453RKqskKuv6MW8BmDq6Pazz0/bu1Q5Hj7eFGCSzXtpwGuUwJEvTu4sYIUGKHAkEAxNj1qmmkDZgJsNcI/UVLskFK9V+JfJeoJKMixFiKT5b7ZMq9btNnZDlsbjpTc2UjJt295wCRInnsXCbLl87xWwJBAL/N0is8acPuo6y8f1BvYOzv/9NQY8umGjuH8BoW9lk53EHYxaOGVZAAuwwoi8Xw4IFgNYh8qdgTaOlCukSmqK8CQG9aT/Yblmr+M5Uuv24OUhi/KLkPV0X8wGghRJyPfYYyYXmN2oUj35vpg/YC1owzjSQCUdeoEXHQSK2EYK06qnsCQFnCXbjl62tmHrdf80nACDuwmptfftof/btBuovhnjdBgPVmLtfa/sHCIGw2gsawj67ksjEVPuUAdCU9GN31kp8=";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/

    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = self.orderNo; //订单ID（由商家自行制定）
    order.productName = @"宁波美娘女子学院"; //商品标题
    order.productDescription = @"网上购物"; //商品描述
//    order.amount = self.totalPrice; //商品价格
    order.amount = @"0.01";
    order.notifyURL =  @"http://www.xxx.com"; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"MNNZXY";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            if ([[resultDic objectForKey:@"resultStatus"] integerValue] == 9000) {
                [self submitResult];
            }
        }];
    }
}

- (void)submitResult
{
    NSString *str = [NSString stringWithFormat:@"mobi/order/completeOrder?orderId=%@",self.orderId];
    
    [[HttpManager shareManger] getWithStr:str ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
        
        if ([[json objectForKey:@"code"] integerValue] == 0) {
            [[tools shared] HUDShowHideText:@"支付成功" delay:1.5];
            OrderLIstVC *orderList = [[OrderLIstVC alloc] init];
            orderList.type = 2;
            [self.navigationController pushViewController:orderList animated:YES];            
        }else {
            [[tools shared] HUDShowHideText:[json objectForKey:@"message"] delay:1.5];
        }
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];

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
