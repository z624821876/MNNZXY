//
//  AddAddressVC.m
//  BeautyCollege
//
//  Created by 于洲 on 15/5/7.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "AddAddressVC.h"
#import "MyCustomView.h"
#import "IQKeyboardManager.h"

@interface AddAddressVC ()

@property (nonatomic, strong) UIButton          *cityBtn;
@property (nonatomic, strong) UITextView        *addressTV;
@property (nonatomic, strong) NSMutableArray    *tfArray;
@property (nonatomic, strong) MyCustomView      *topView;
@property (nonatomic, strong) NSMutableArray    *cityArray;
@property (nonatomic, strong) BaseCellModel     *currentCity;


@end

@implementation AddAddressVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [IQKeyboardManager sharedManager].enable = YES;
    self.navigationItem.title = @"添加收货地址";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(10, 64 + 15, UI_SCREEN_WIDTH - 20, 120 * UI_scaleY + 180)];
    [img setImage:[[UIImage imageNamed:@"blank_num.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)]];
    [self.view addSubview:img];
    _tfArray = [[NSMutableArray alloc] init];
    _cityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cityBtn.frame = CGRectMake(img.right - 80, img.top + 10 * UI_scaleY, 70, 30);
    _cityBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    _cityBtn.layer.cornerRadius = 5;
    _cityBtn.layer.masksToBounds = YES;
    [_cityBtn setTitle:@"选择省份" forState:UIControlStateNormal];
    [_cityBtn addTarget:self action:@selector(changeCity) forControlEvents:UIControlEventTouchUpInside];
    _cityBtn.backgroundColor = BaseColor;
    [self.view addSubview:_cityBtn];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, _cityBtn.bottom + 9, 40, 20)];
    label.textColor = [UIColor grayColor];
    label.text = @"地址";
    [self.view addSubview:label];
    
    _addressTV = [[UITextView alloc] initWithFrame:CGRectMake(label.right + 5, _cityBtn.bottom, img.width - label.right - 15 + 10, 60)];
    _addressTV.backgroundColor = [UIColor clearColor];
    _addressTV.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:_addressTV];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(img.left, _addressTV.bottom + 10 * UI_scaleY - 0.5, img.width, 0.5)];
    lineView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:lineView];
    
    NSArray *array = @[@"邮编",@"姓名",@"电话"];
    for (NSInteger i = 0; i < 3; i ++) {
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(20, lineView.bottom + 10 * UI_scaleY + (30 + 20 * UI_scaleY) * i, 40, 30)];
        label1.textColor = [UIColor grayColor];
        label1.text = array[i];
        [self.view addSubview:label1];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(label1.right + 5, label1.top, img.width - label1.right - 5, 30)];
        textField.delegate = self;
        [self.view addSubview:textField];
        if (i != 1) {
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }
        [_tfArray addObject:textField];

        UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(img.left, label1.bottom + 10 * UI_scaleY - 0.5, img.width, 0.5)];
        lineView1.backgroundColor = [UIColor grayColor];
        [self.view addSubview:lineView1];
    }
    _cityArray = [[NSMutableArray alloc] init];
    
    NSString *str = @"mobi/ser/getCity?parentId=1";
    [[HttpManager shareManger] getWithStr:str ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
        [[tools shared] HUDHide];
        if ([[json objectForKey:@"code"] integerValue] == 0) {
            NSArray *result = nilOrJSONObjectForKey(json, @"result");
            for (NSDictionary *dic in result) {
                BaseCellModel *model = [[BaseCellModel alloc] init];
                model.name = nilOrJSONObjectForKey(dic, @"name");
                model.modelId = nilOrJSONObjectForKey(dic, @"id");
                [_cityArray addObject:model];
            }
        }
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(15, UI_SCREEN_HEIGHT - 50, UI_SCREEN_WIDTH - 30, 40);
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    btn.backgroundColor = BaseColor;
    [btn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}

- (void)confirm
{
    if (_addressTV.text.length <= 0) {
        [[tools shared] HUDShowHideText:@"请输入你的地址" delay:1.5];
        return;
    }
    UITextField *tf1 = [_tfArray objectAtIndex:0];
    UITextField *tf2 = [_tfArray objectAtIndex:1];
    UITextField *tf3 = [_tfArray objectAtIndex:2];
    if (tf1.text.length <= 0) {
        [[tools shared] HUDShowHideText:@"请输入你的邮编" delay:1.5];
        return;
    }
    
    if (tf2.text.length <= 0) {
        [[tools shared] HUDShowHideText:@"请输入你的姓名" delay:1.5];
        return;
    }
    
    if (tf3.text.length <= 0) {
        [[tools shared] HUDShowHideText:@"请输入你的电话" delay:1.5];
        return;
    }

    if (!_currentCity) {
        [[tools shared] HUDShowHideText:@"请选择省份" delay:1.5];
        return;
    }

    NSString *str = [NSString stringWithFormat:@"mobi/address/doAdd?memberId=%@&name=%@&address=%@&mobile=%@&cityId=%@&provinceId=%@",[User shareUser].userId,tf2.text,_addressTV.text,tf3.text,tf1.text,_currentCity.modelId];
    [[tools shared] HUDShowText:@"正在提交..."];
    [[HttpManager shareManger] getWithStr:str ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
        
        if ([[json objectForKey:@"code"] integerValue] == 0) {
            [[tools shared] HUDShowHideText:@"添加成功" delay:1.5];
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [[tools shared] HUDShowHideText:@"添加失败" delay:1.5];
        }
        
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

- (void)changeCity
{
    _topView = [[MyCustomView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)];
    _topView.backgroundColor = ColorWithRGBA(30.0, 32.0, 40.0, 0.5);
    [[AppDelegate shareApp].window addSubview:_topView];
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(5, 150, UI_SCREEN_WIDTH - 10, 240)];
    [img setImage:[[UIImage imageNamed:@"blank_num.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)]];
    [_topView addSubview:img];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(img.left + 10, img.top + 10, 100, 30)];
    label.textColor = [UIColor grayColor];
    label.text = @"省份";
    [_topView addSubview:label];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(5, img.top + 50, img.width, 140)];
    bgView.backgroundColor = [UIColor whiteColor];
    [_topView addSubview:bgView];
    CGFloat width = (bgView.width) / 7.0;
    for (NSInteger i = 0; i < [_cityArray count]; i ++) {
        NSInteger y = i / 7;
        NSInteger x = i % 7;
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(width * x, 10 + 25 * y, width, 20)];
        BaseCellModel *model = _cityArray[i];
        btn.tag = i;
        [btn setTitle:model.name forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn addTarget:self action:@selector(selectCity:) forControlEvents:UIControlEventTouchUpInside
         ];
        [bgView addSubview:btn];
    }
    
}

- (void)selectCity:(UIButton *)btn
{
    if (btn.tag >= ([_cityArray count] - 3)) {
        
        [[tools shared] HUDShowHideText:@"暂不支持港澳台" delay:1.5];
        return;
    }

    [_topView removeFromSuperview];
    
    _currentCity = [_cityArray objectAtIndex:btn.tag];
    [_cityBtn setTitle:_currentCity.name forState:UIControlStateNormal];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
