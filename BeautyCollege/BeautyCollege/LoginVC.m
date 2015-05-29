
//
//  LoginVC.m
//  BeautyCollege
//
//  Created by 于洲 on 15/4/20.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "LoginVC.h"
#import "RegistVC.h"
#import "FindPswVC.h"

@interface LoginVC ()
{
    UITextField         *_nameTF;
    UITextField         *_pswTF;
    
    UIButton            *_leftBtn;
    UIButton            *_rightBtn;
    
    UIButton            *_loginBtn;
    UIButton            *_registBtn;
    
}

@end

@implementation LoginVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"美娘女子学院";
}

- (void)back
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.mainTabBar.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initGUI];
}

- (void)initGUI
{
    CGFloat space = 20 * UI_scaleY;
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake((UI_SCREEN_WIDTH - 60 * UI_scaleX) / 2.0, 100, 60 * UI_scaleX, 60 * UI_scaleX)];
    [img setImage:[UIImage imageNamed:@"default_avatar.png"]];
    img.layer.cornerRadius = 60 * UI_scaleX / 2.0;
    img.layer.masksToBounds = YES;
    [self.view addSubview:img];
    
    UIImageView *pswImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, img.bottom + space, UI_SCREEN_WIDTH - 20, 90)];
    [pswImg setImage:[UIImage imageNamed:@"blank_num.png"]];
    [self.view addSubview:pswImg];
    
    _nameTF = [[UITextField alloc] initWithFrame:CGRectMake(pswImg.left + 5, pswImg.top + 10, pswImg.width - 10, 30)];
    _nameTF.delegate = self;
    _nameTF.keyboardType = UIKeyboardTypeNumberPad;
    _nameTF.placeholder = @"请输入您的手机号";
    NSString *phoneStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"MNUserPhone"];
    if (![phoneStr isKindOfClass:[NSNull class]] && phoneStr != nil) {
        
        _nameTF.text = phoneStr;
    }
    [self.view addSubview:_nameTF];
    
    _pswTF = [[UITextField alloc] initWithFrame:CGRectMake(_nameTF.left, _nameTF.bottom + 10, _nameTF.width, 30)];
    _pswTF.delegate = self;
    NSString *pswStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"MNUserPsw"];
    if (![pswStr isKindOfClass:[NSNull class]] && pswStr != nil) {
        
        _pswTF.text = pswStr;
    }
    _pswTF.secureTextEntry = YES;
    _pswTF.placeholder = @"请输入您的密码";
    [self.view addSubview:_pswTF];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(pswImg.left, _nameTF.bottom + 2.5, pswImg.width, 1)];
    lineView.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
    [self.view addSubview:lineView];
    
    _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_leftBtn setImage:[UIImage imageNamed:@"reg8.png"] forState:UIControlStateNormal];
    [_leftBtn setImage:[UIImage imageNamed:@"reg9.png"] forState:UIControlStateSelected];
    [_leftBtn setTitle:@"记住密码" forState:UIControlStateNormal];
    _leftBtn.tag = 10;
    [_leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_leftBtn addTarget:self action:@selector(option:) forControlEvents:UIControlEventTouchUpInside];
    _leftBtn.frame = CGRectMake(25, pswImg.bottom + space, 80, 30 * UI_scaleY);
    [self.view addSubview:_leftBtn];
    
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtn.frame = CGRectMake(UI_SCREEN_WIDTH - 80 - 25, pswImg.bottom + space, 80, 30 * UI_scaleY);
    [_rightBtn setTitle:@"找回密码？" forState:UIControlStateNormal];
    _rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _rightBtn.tag = 11;
    [_rightBtn addTarget:self action:@selector(option:) forControlEvents:UIControlEventTouchUpInside];
    [_rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:_rightBtn];
    
    _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginBtn.frame = CGRectMake(10, _rightBtn.bottom + space, (UI_SCREEN_WIDTH - 30) / 2.0, 40);
    [_loginBtn setTitle:@"登陆" forState:UIControlStateNormal];
    [_loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    _loginBtn.backgroundColor = [Util uiColorFromString:@"#e1008c"];
    _loginBtn.layer.cornerRadius = 5;
    _loginBtn.layer.masksToBounds = YES;
    [self.view addSubview:_loginBtn];
    
    _registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _registBtn.frame = CGRectMake(_loginBtn.right + 10, _rightBtn.bottom + space, (UI_SCREEN_WIDTH - 30) / 2.0, 40);
    [_registBtn setTitle:@"注册" forState:UIControlStateNormal];
    _registBtn.backgroundColor = [UIColor grayColor];
    _registBtn.layer.cornerRadius = 5;
    [_registBtn addTarget:self action:@selector(regist) forControlEvents:UIControlEventTouchUpInside];
    _registBtn.layer.masksToBounds = YES;
    [self.view addSubview:_registBtn];

    UIImageView *leftImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, _registBtn.bottom + space + 10, 80, 2)];
    [leftImg setImage:[UIImage imageNamed:@"login4.png"]];
    [self.view addSubview:leftImg];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(leftImg.right, _registBtn.bottom + space, UI_SCREEN_WIDTH - 180, 20)];
    label.text = @"使用第三方账号登陆";
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    UIImageView *rightImg = [[UIImageView alloc] initWithFrame:CGRectMake(label.right, _registBtn.bottom + space + 10, 80, 2)];
    [rightImg setImage:[UIImage imageNamed:@"login5.png"]];
    [self.view addSubview:rightImg];
    NSArray *array = @[@"login6.png",@"login7.png",@"login8.png"];
    
    for (NSInteger i = 0; i < 3; i ++) {
        UIButton *logoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        logoBtn.frame = CGRectMake((UI_SCREEN_WIDTH - (3 * 50 * UI_scaleX) - 40) / 2.0 + 70 * UI_scaleX * i, label.bottom + space - 10, 50 * UI_scaleX, 50 * UI_scaleX);
        logoBtn.tag = 20 + i;
        [logoBtn addTarget:self action:@selector(thirdPartyLogin:) forControlEvents:UIControlEventTouchUpInside];
        [logoBtn setImage:[UIImage imageNamed:array[i]] forState:UIControlStateNormal];
        [self.view addSubview:logoBtn];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField endEditing:YES];
    return YES;
}

- (void)login
{
    
    if (_nameTF.text.length <= 0) {
        [[tools shared] HUDShowHideText:@"请输入手机号" delay:1.5];
        return;
    }
    
    if (![MyTool viableMobileWith:_nameTF.text]) {
        [[tools shared] HUDShowHideText:@"手机格式不正确" delay:1.5];
        return;
    }
    
    if (_pswTF.text.length <= 0) {
        [[tools shared] HUDShowHideText:@"请输入密码" delay:1.5];
        return;
    }
    
    if (_pswTF.text.length < 6) {
        [[tools shared] HUDShowHideText:@"请输入不小于6位的密码" delay:1.5];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:_nameTF.text forKey:@"MNUserPhone"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[tools shared] HUDShowHideText:@"正在登陆..." delay:1.5];
    NSString *str = [NSString stringWithFormat:@"mobi/account/log?password=%@&userName=%@",_pswTF.text,_nameTF.text];
    [[HttpManager shareManger] getWithStr:str ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
        [[tools shared] HUDHide];
        NSInteger code = [[json objectForKey:@"code"] integerValue];
        if (code == 0) {
            
            if (_leftBtn.selected) {
                [[NSUserDefaults standardUserDefaults] setObject:_pswTF.text forKey:@"MNUserPsw"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }else {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"MNUserPsw"];
            }
            
            NSDictionary *dic = [json objectForKey:@"result"];
            User *user = [User shareUser];
            user.userId = nilOrJSONObjectForKey(dic, @"id");
            user.userName = nilOrJSONObjectForKey(dic, @"userName");
            user.nickname = nilOrJSONObjectForKey(dic, @"nickname");
            user.level = nilOrJSONObjectForKey(dic, @"level");
            user.levelName = nilOrJSONObjectForKey(dic, @"levelName");
            user.score = nilOrJSONObjectForKey(dic, @"score");
            user.logo = nilOrJSONObjectForKey(dic, @"logo");
            NSNumber *sexNum = nilOrJSONObjectForKey(dic, @"sex");
            NSString *sex;
            switch ([sexNum integerValue]) {
                case 0:
                {
                    sex = @"女";
                }
                    break;
                case 1:
                {
                    sex = @"无性";
                }
                    break;
                case 2:
                {
                    sex = @"男";
                }
                    break;

                    
                default:
                    break;
            }
            user.sex = sex;
            user.regLink = nilOrJSONObjectForKey(dic, @"regLink");
            user.regLinkImg = nilOrJSONObjectForKey(dic, @"regLinkImg");
            user.signature = nilOrJSONObjectForKey(dic, @"signature");
            user.cityName = nilOrJSONObjectForKey(dic, @"cityName");
            NSMutableData *data = [[NSMutableData alloc] init];
            NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
            [archiver encodeObject:user forKey:@"user"];
            [archiver finishEncoding];
            NSString *path = [PATH_OF_DOCUMENT stringByAppendingPathComponent:@"MyUser"];
            [data writeToFile:path atomically:YES];
            
            [self goBack];
        }else {
            [[tools shared] HUDShowHideText:[json objectForKey:@"message"] delay:1.5];
        }
        
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

- (void)goBack
{
    if (_type == 10) {
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        delegate.mainTabBar.selectedIndex = 4;
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }

    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.mainTabBar.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//注册
- (void)regist
{
    RegistVC *vc = [[RegistVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//第三方登录
- (void)thirdPartyLogin:(UIButton *)btn
{
    [self back];
    switch (btn.tag) {
        case 20:
        {
                //WX登录
            [[AppDelegate shareApp] WXlogin];
        }
            break;
        case 21:
        {
                //qq登录
            [[AppDelegate shareApp] QQlogin];
        }
            break;
        case 22:
        {
            [[AppDelegate shareApp] SinaLogin];

        }
            break;
            
        default:
            break;
    }
    
}

- (void)option:(UIButton *)btn
{
    if (btn.tag == 10) {
        btn.selected = !btn.selected;
    }else {
        //找回密码
        FindPswVC *vc = [[FindPswVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
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
