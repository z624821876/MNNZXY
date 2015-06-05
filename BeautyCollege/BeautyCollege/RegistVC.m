//
//  RegistVC.m
//  BeautyCollege
//
//  Created by 于洲 on 15/4/21.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "RegistVC.h"
#import "MytextField.h"
#import "IQKeyboardManager.h"

#define NUMBERS @"0123456789\n"

@interface RegistVC ()

@property (strong ,nonatomic) UIButton      *currentBtn;


@property (strong ,nonatomic) MytextField   *authcodeTF;
@property (strong ,nonatomic) UITextField   *phoneTF;
@property (strong ,nonatomic) UITextField   *nickNameTF;
@property (strong ,nonatomic) UITextField   *pswTF;
@property (strong ,nonatomic) UITextField   *pswTF2;
@property (strong ,nonatomic) NSDate        *date;

@end

@implementation RegistVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [IQKeyboardManager sharedManager].enable = YES;
    self.navigationItem.title = @"美娘女子学院";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initGUI];
}

- (void)initGUI
{
    
    CGFloat space = 20 * UI_scaleY;
    CGFloat space1 = 10 * UI_scaleY;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((UI_SCREEN_WIDTH - 50) / 2.0, 64 + space, 50, 40)];
    label.text = @"注册";
    label.textColor = [UIColor grayColor];
    label.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:label];
    
    UIImageView *bgImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, label.bottom + space, UI_SCREEN_WIDTH - 20, 40 + 40 * UI_scaleY)];
    [bgImg setImage:[UIImage imageNamed:@"blank_num.png"]];
    [self.view addSubview:bgImg];
    
    _phoneTF = [[UITextField alloc] initWithFrame:CGRectMake(bgImg.left + 5, bgImg.top + space1, bgImg.width - 10, 20)];
    _phoneTF.delegate = self;
    _phoneTF.tag = 10;
    _phoneTF.placeholder = @"手机号码";
//    _phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_phoneTF];
    
    _nickNameTF = [[UITextField alloc] initWithFrame:CGRectMake(_phoneTF.left, _phoneTF.bottom + space, _phoneTF.width, 20)];
    _nickNameTF.delegate = self;
    _nickNameTF.placeholder = @"昵称";
    [self.view addSubview:_nickNameTF];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(bgImg.left, _phoneTF.bottom + space1, bgImg.width, 1)];
    lineView.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
    [self.view addSubview:lineView];

    _authcodeTF = [[MytextField alloc] initWithFrame:CGRectMake(10, bgImg.bottom + space1, UI_SCREEN_WIDTH - 20 - 100, 40)];
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
    
    UIImageView *bgImg2 = [[UIImageView alloc] initWithFrame:CGRectMake(10, getAuthBtn.bottom + space1, UI_SCREEN_WIDTH - 20, 40 + 40 * UI_scaleY)];
    [bgImg2 setImage:[UIImage imageNamed:@"blank_num.png"]];
    [self.view addSubview:bgImg2];
    
    _pswTF = [[UITextField alloc] initWithFrame:CGRectMake(bgImg2.left + 5, bgImg2.top + space1, bgImg2.width - 10, 20)];
    _pswTF.delegate = self;
    _pswTF.placeholder = @"密码";
    [self.view addSubview:_pswTF];
    
    _pswTF2 = [[UITextField alloc] initWithFrame:CGRectMake(_pswTF.left, _pswTF.bottom + space, _pswTF.width, 20)];
    _pswTF2.delegate = self;
    _pswTF2.placeholder = @"确认密码";
    [self.view addSubview:_pswTF2];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(bgImg2.left, _pswTF.bottom + space1, bgImg2.width, 1)];
    lineView2.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
    [self.view addSubview:lineView2];
    
    
    NSArray *array = @[@"girl.png",@"无性.png",@"boy.png"];
    CGFloat width = (UI_SCREEN_WIDTH - 150) / 4.0;
    for (NSInteger i = 0; i < 3; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(width + (width + 50) * i, bgImg2.bottom + space + space1, 20, 20);
        [btn setImage:[UIImage imageNamed:@"reg8.png"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"reg9.png"] forState:UIControlStateSelected];
        btn.tag = 20 + i;
        [btn addTarget:self action:@selector(changeSex:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(btn.right, bgImg2.bottom + space, 25, 40)];
        [img setImage:[UIImage imageNamed:array[i]]];
        [self.view addSubview:img];
        
    }
    
    UIButton *regesterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    regesterBtn.frame = CGRectMake(15, bgImg2.bottom + space + 40 + space, UI_SCREEN_WIDTH - 30, 30 * UI_scaleY);
    regesterBtn.backgroundColor = [Util uiColorFromString:@"#e1008c"];
    regesterBtn.layer.cornerRadius = 8;
    regesterBtn.layer.masksToBounds = YES;
    [regesterBtn setTitle:@"注    册" forState:UIControlStateNormal];
    [regesterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [regesterBtn addTarget:self action:@selector(regist) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:regesterBtn];
}

    //点击获取验证码
- (void)getAuthcode
{
    [self.view endEditing:YES];
    BOOL isMobile = [self authMobile];
    if (isMobile) {
        
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
        
        NSString *str = [NSString stringWithFormat:@"mobi/account/sendActiveCode?mobile=%@",_phoneTF.text];
        [[HttpManager shareManger] getWithStr:str ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
            if ([[json objectForKey:@"code"] integerValue] == 0) {
                
                [[tools shared] HUDShowHideText:@"获取验证码成功,请注意接收" delay:1.5];
                _date = [NSDate date];
            }else if ([[json objectForKey:@"code"]  integerValue] == -1){
                [[tools shared] HUDShowHideText:[json objectForKey:@"此号码已注册"] delay:1.5];

            }else {
                [[tools shared] HUDShowHideText:[json objectForKey:@"message"] delay:1.5];

            }
        } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            
            
        }];
        
    }
}

- (BOOL)authMobile
{
    if (_phoneTF.text.length <= 0) {
        [[tools shared] HUDShowHideText:@"请输入手机号" delay:1.5];
        return NO;
    }
    
    if (![MyTool viableMobileWith:_phoneTF.text]) {
        [[tools shared] HUDShowHideText:@"您的手机号码格式不正确" delay:1.5];
        return NO;
    }
    return YES;
}

- (void)regist
{
    BOOL isMobile = [self authMobile];
    if (!isMobile) {
        return;
    }
    
    if (_nickNameTF.text.length <= 0) {
        [[tools shared] HUDShowHideText:@"请输入昵称" delay:1.5];
        return;
    }
    if (_nickNameTF.text.length < 2) {
        [[tools shared] HUDShowHideText:@"昵称长度不能小于2个字符" delay:1.5];
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
    if (!_currentBtn.selected) {
        [[tools shared] HUDShowHideText:@"请选择性别" delay:1.5];
        return;
    }
    NSInteger sex;
    switch (_currentBtn.tag) {
        case 20:
        {
            sex = 2;
        }
            break;
        case 21:
        {
            sex = 0;
        }
            break;
        case 22:
        {
            sex = 1;
        }
            break;

            
        default:
            break;
    }
    
    [[tools shared] HUDShowText:@"正在注册..."];
    NSString *str = [NSString stringWithFormat:@"mobi/account/reg?userName=%@&password=%@&nickname=%@&sex=%ld&activeCode=%@",_phoneTF.text,_pswTF.text,_nickNameTF.text,sex,_authcodeTF.text];
    [[HttpManager shareManger] getWithStr:str ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
        [[tools shared] HUDHide];
        if ([[json objectForKey:@"code"] integerValue] == 0) {
            //注册成功
            [[tools shared] HUDShowHideText:@"注册成功" delay:1.5];
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            
            [[tools shared] HUDShowHideText:[json objectForKey:@"message"] delay:1.5];
        }
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)changeSex:(UIButton *)btn
{
    btn.selected = YES;
    _currentBtn.selected = NO;
    _currentBtn = btn;
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
