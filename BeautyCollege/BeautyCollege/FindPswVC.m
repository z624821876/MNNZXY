//
//  FindPswVC.m
//  BeautyCollege
//
//  Created by 于洲 on 15/4/22.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "FindPswVC.h"
#import "MytextField.h"
#import "IQKeyboardManager.h"
#define NUMBERS @"0123456789\n"
@interface FindPswVC ()

@property (strong, nonatomic) UITextField   *phoneTF;
@property (strong, nonatomic) UITextField   *authcodeTF;
@property (strong, nonatomic) UITextField   *pswTF;
@property (strong, nonatomic) UITextField   *pswTF2;
@property (strong, nonatomic) NSDate        *date;
@end

@implementation FindPswVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [IQKeyboardManager sharedManager].enable = YES;
    self.navigationItem.title = @"找回密码";

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initGUI];
}

- (void)initGUI
{
    CGFloat space = 20 * UI_scaleY;
    CGFloat space1 = 10 * UI_scaleY;
    UIImageView *bgImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 64 + space, UI_SCREEN_WIDTH - 20, 40 * UI_scaleY)];
    [bgImg setImage:[UIImage imageNamed:@"blank_num.png"]];
    [self.view addSubview:bgImg];
    
    _phoneTF = [[UITextField alloc] initWithFrame:CGRectMake(bgImg.left + 5, bgImg.top + 5 * UI_scaleY, bgImg.width - 10, 30 * UI_scaleY)];
    _phoneTF.placeholder = @"手机号";
    [self.view addSubview:_phoneTF];
    
    _authcodeTF = [[MytextField alloc] initWithFrame:CGRectMake(10, bgImg.bottom + space, UI_SCREEN_WIDTH - 20 - 100, 40)];
    _authcodeTF.delegate = self;
    _authcodeTF.tag = 11;
    _authcodeTF.keyboardType = UIKeyboardTypeNumberPad;
    _authcodeTF.placeholder = @"短信验证码";
    _authcodeTF.layer.borderColor = [Util uiColorFromString:@"#e1008c"].CGColor;
    _authcodeTF.layer.borderWidth = 1;
    [self.view addSubview:_authcodeTF];
    
    UIButton *getAuthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    getAuthBtn.backgroundColor = [Util uiColorFromString:@"#e1008c"];
    [getAuthBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [getAuthBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [getAuthBtn addTarget:self action:@selector(getAuthcode) forControlEvents:UIControlEventTouchUpInside];
    getAuthBtn.frame = CGRectMake(_authcodeTF.right, _authcodeTF.top, 100, 40);
    [self.view addSubview:getAuthBtn];
    
    UIImageView *bgImg2 = [[UIImageView alloc] initWithFrame:CGRectMake(10, getAuthBtn.bottom + space, UI_SCREEN_WIDTH - 20, 40 + 40 * UI_scaleY)];
    [bgImg2 setImage:[UIImage imageNamed:@"blank_num.png"]];
    [self.view addSubview:bgImg2];
    
    
    _pswTF = [[UITextField alloc] initWithFrame:CGRectMake(bgImg2.left + 5, bgImg2.top + space1, bgImg2.width - 10, 20)];
    _pswTF.delegate = self;
    _pswTF.placeholder = @"密码";
    [self.view addSubview:_pswTF];
    
    _pswTF2 = [[UITextField alloc] initWithFrame:CGRectMake(_pswTF.left, _pswTF.bottom + space, _pswTF.width, 20)];
    _pswTF2.delegate = self;
    _pswTF2.placeholder = @"确认新密码";
    [self.view addSubview:_pswTF2];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(bgImg2.left, _pswTF.bottom + space1, bgImg2.width, 1)];
    lineView2.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
    [self.view addSubview:lineView2];

    
    UIButton *regesterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    regesterBtn.frame = CGRectMake(15, bgImg2.bottom + space, UI_SCREEN_WIDTH - 30, 30 * UI_scaleY);
    regesterBtn.backgroundColor = [Util uiColorFromString:@"#e1008c"];
    regesterBtn.layer.cornerRadius = 8;
    regesterBtn.layer.masksToBounds = YES;
    [regesterBtn setTitle:@"确认修改" forState:UIControlStateNormal];
    [regesterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [regesterBtn addTarget:self action:@selector(changePassword) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:regesterBtn];
    
}

- (void)changePassword
{
    [self.view endEditing:YES];
    if (_phoneTF.text.length <= 0) {
        [[tools shared] HUDShowHideText:@"请输入手机号" delay:1.5];
        return;
    }
    if (![MyTool viableMobileWith:_phoneTF.text]) {
        [[tools shared] HUDShowHideText:@"您的手机号码格式不正确" delay:1.5];
        return;
    }
    if (_authcodeTF.text.length != 4) {
        [[tools shared] HUDShowHideText:@"请输入4位数字手机验证码" delay:1.5];
        return;
    }
    if (_pswTF.text.length <= 0) {
        [[tools shared] HUDShowHideText:@"请输入密码" delay:1.5];
        return;
    }
    if (_pswTF.text.length < 6) {
        [[tools shared] HUDShowHideText:@"密码长度不能小于6位" delay:1.5];
        return;
    }
    if (![_pswTF2.text isEqualToString:_pswTF.text]) {
        [[tools shared] HUDShowHideText:@"两次密码输入不一致" delay:1.5];
        return;
    }

    [[tools shared] HUDShowText:@"正在提交..."];
    NSString *str = [NSString stringWithFormat:@"mobi/account/changePassword?userName=%@&password=%@&activeCode=%@",_phoneTF.text,_pswTF.text,_authcodeTF.text];
    [[HttpManager shareManger] getWithStr:str ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
        [[tools shared] HUDHide];
        if ([[json objectForKey:@"code"] integerValue] == 0) {
            //修改成功成功
            [[tools shared] HUDShowHideText:@"修改成功" delay:1.5];

            _phoneTF.text = @"";
            _authcodeTF.text = @"";
            _pswTF.text = @"";
            _pswTF2.text = @"";
            
        }else {
            
            [[tools shared] HUDShowHideText:[json objectForKey:@"message"] delay:1.5];
        }
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}

- (void)getAuthcode
{
    [self.view endEditing:YES];
    if (_phoneTF.text.length <= 0) {
        [[tools shared] HUDShowHideText:@"请输入手机号" delay:1.5];
        return;
    }
    if (![MyTool viableMobileWith:_phoneTF.text]) {
        [[tools shared] HUDShowHideText:@"您的手机号码格式不正确" delay:1.5];
        return;
    }
    
    //判断遇上一次时间是不是相差120秒
    NSDate *date2 = [NSDate date];
    NSTimeInterval aTimer = [date2 timeIntervalSinceDate:_date];
    if (_date != Nil) {
        if (aTimer < 120) {
            NSString *str = [NSString stringWithFormat:@"请%.0f秒后在获取",120 - aTimer];
            [[tools shared] HUDShowHideText:str delay:1.5];
            return;
        }
    }
    
    NSString *str = [NSString stringWithFormat:@"mobi/account/sendActiveCodeWithOutCheck?mobile=%@",_phoneTF.text];
    [[HttpManager shareManger] getWithStr:str ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
        if ([[json objectForKey:@"code"] integerValue] == 0) {
            
            [[tools shared] HUDShowHideText:@"获取验证码成功,请注意接收" delay:1.5];
            _date = [NSDate date];
        }else {
            [[tools shared] HUDShowHideText:[json objectForKey:@"message"] delay:1.5];
            
        }
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];


}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - textField  代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@" "]) {
        return NO;
    }
    
    if (textField.tag == 10 || textField.tag == 11) {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""]; //按cs分离出数组,数组按@""分离出字符串
        DDLog(@"%@",[string componentsSeparatedByCharactersInSet:cs]);
        BOOL canChange = [string isEqualToString:filtered];
        return canChange;
    }
    
    return YES;
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
