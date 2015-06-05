//
//  ChangePswVC.m
//  BeautyCollege
//
//  Created by 于洲 on 15/5/5.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "ChangePswVC.h"

@interface ChangePswVC ()

@property (nonatomic, strong) UITextField *pswTF1;
@property (nonatomic, strong) UITextField *pswTF2;
@property (nonatomic, strong) UITextField *pswTF3;

@end

@implementation ChangePswVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationItem.title = @"修改密码";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *bgImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 64 + 20 * UI_scaleY, UI_SCREEN_WIDTH - 20, 90 + 30 * UI_scaleY)];
    [bgImg setImage:[UIImage imageNamed:@"blank_num.png"]];
    [self.view addSubview:bgImg];
    
    _pswTF1 = [[UITextField alloc] initWithFrame:CGRectMake(15, bgImg.top + 5 * UI_scaleY, UI_SCREEN_WIDTH - 30, 30)];
    _pswTF1.placeholder = @"原密码:";
    _pswTF1.secureTextEntry = YES;
    _pswTF1.delegate = self;
    [self.view addSubview:_pswTF1];
    
    _pswTF2 = [[UITextField alloc] initWithFrame:CGRectMake(15, _pswTF1.bottom + 10 * UI_scaleY, UI_SCREEN_WIDTH - 30, 30)];
    _pswTF2.placeholder = @"新密码:";
    _pswTF2.secureTextEntry = YES;
    _pswTF2.delegate = self;
    [self.view addSubview:_pswTF2];
    
    _pswTF3 = [[UITextField alloc] initWithFrame:CGRectMake(15, _pswTF2.bottom + 10 * UI_scaleY, UI_SCREEN_WIDTH - 30, 30)];
    _pswTF3.placeholder = @"确认新密码:";
    _pswTF3.secureTextEntry = YES;
    _pswTF3.delegate = self;
    [self.view addSubview:_pswTF3];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(10, _pswTF1.bottom + 5 * UI_scaleY, bgImg.width, 0.5)];
    lineView1.backgroundColor = [UIColor grayColor];
    [self.view addSubview:lineView1];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(10, _pswTF2.bottom + 5 * UI_scaleY, bgImg.width, 0.5)];
    lineView2.backgroundColor = [UIColor grayColor];
    [self.view addSubview:lineView2];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10, bgImg.bottom + 20 * UI_scaleY, bgImg.width, 35);
    [btn setTitle:@"确认修改" forState:UIControlStateNormal];
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:@selector(changePsw) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = BaseColor;
    [self.view addSubview:btn];
}

- (void)changePsw
{
    if (_pswTF1.text.length <= 0) {
        [[tools shared] HUDShowHideText:@"请输入原密码" delay:1.5];
        return;
    }
    
    if (_pswTF1.text.length < 6) {
        [[tools shared] HUDShowHideText:@"原密码小于6位" delay:1.5];
        return;
    }
    
    if (_pswTF2.text.length <= 0) {
        [[tools shared] HUDShowHideText:@"请输入新密码" delay:1.5];
        return;
    }
    
    if (_pswTF2.text.length < 6) {
        [[tools shared] HUDShowHideText:@"新密码小于6位" delay:1.5];
        return;
    }
    
    if (![_pswTF3.text isEqualToString:_pswTF2.text]) {
        [[tools shared] HUDShowHideText:@"两次密码输入不一致,请检查" delay:1.5];
        return;
    }
    
    NSString *phoneStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"MNUserPhone"];
    NSString *str = [NSString stringWithFormat:@"mobi/account/updatePassword?userName=%@&password=%@&oldPassword=%@",phoneStr,_pswTF2.text,_pswTF1.text];
    [[HttpManager shareManger] getWithStr:str ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
    
        if ([[json objectForKey:@"code"] integerValue] == 0) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"MNUserPhone"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"MNUserPsw"];
            [[tools shared] HUDShowHideText:@"修改成功" delay:1.0];
            LoginVC *vc = [[LoginVC alloc] init];
            vc.type = 10;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:10];
            
        }else if ([[json objectForKey:@"code"] integerValue] == -2) {
            [[tools shared] HUDShowHideText:@"原密码错误" delay:1.5];
        }else {
            [[tools shared] HUDShowHideText:@"修改失败" delay:1.5];
        }
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@" "]) {
        return NO;
    }
    
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
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
