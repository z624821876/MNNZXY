//
//  FeedbackVC.m
//  BeautyCollege
//
//  Created by 于洲 on 15/5/5.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "FeedbackVC.h"

#define NUMBERS @"1234567890\n"

@interface FeedbackVC ()

@property (nonatomic, strong) UITextView        *contentView;
@property (nonatomic, strong) UITextField       *phoneTF;
@property (nonatomic, strong) UILabel           *placeholderLable;

@property (nonatomic, strong) UIButton          *confirmBtn;
@property (nonatomic, strong) UIButton          *cancelBtn;

@end

@implementation FeedbackVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationItem.title = @"意见反馈";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(10, 64 + 15, UI_SCREEN_WIDTH - 20, 200 * UI_scaleY)];
    [img setImage:[UIImage imageNamed:@"comment_2.png"]];
    [self.view addSubview:img];
    
    _contentView = [[UITextView alloc] initWithFrame:CGRectMake(15, 64 + 20, img.width - 10, img.height - 10)];
    _contentView.backgroundColor = [UIColor clearColor];
    _contentView.delegate = self;
    [self.view addSubview:_contentView];
    
    _placeholderLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 64 + 25, img.width - 10, 20)];
    _placeholderLable.text = @"请输入您的反馈意见";
    _placeholderLable.textColor = [UIColor colorWithWhite:0.7 alpha:1];
    [self.view addSubview:_placeholderLable];
    
    UIImageView *img2 = [[UIImageView alloc] initWithFrame:CGRectMake(10, img.bottom + 15, img.width, 20 + 10 * UI_scaleY)];
    [img2 setImage:[UIImage imageNamed:@"comment_2.png"]];
    [self.view addSubview:img2];
    
    _phoneTF = [[UITextField alloc] initWithFrame:CGRectMake(15, img.bottom + 15 + 5 * UI_scaleY, img2.width - 10, 20)];
    _phoneTF.delegate = self;
    _phoneTF.placeholder = @"请输入您的联系方式";
    [self.view addSubview:_phoneTF];
    
    _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _confirmBtn.frame = CGRectMake(img2.left, img2.bottom + 15, (img2.width - 10) / 2.0, 30);
    _confirmBtn.backgroundColor = BaseColor;
    _confirmBtn.tag = 10;
    [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    _confirmBtn.layer.cornerRadius = 5;
    _confirmBtn.layer.masksToBounds = YES;
    [_confirmBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_confirmBtn];
    
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelBtn.frame = CGRectMake(_confirmBtn.right + 10, img2.bottom + 15, (img2.width - 10) / 2.0, 30);
    _cancelBtn.tag = 11;
    _cancelBtn.layer.cornerRadius = 5;
    _cancelBtn.layer.masksToBounds = YES;
    [_cancelBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

    _cancelBtn.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1];
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.view addSubview:_cancelBtn];
    
}

- (void)btnClick:(UIButton *)btn
{
    if (btn.tag == 10) {
        if (_contentView.text.length <= 0) {
            [[tools shared] HUDShowHideText:@"请输入内容" delay:1.5];
            return;
        }
        if (_phoneTF.text.length <= 0) {
            [[tools shared] HUDShowHideText:@"请输入联系方式" delay:1.5];
            return;
        }
        
        NSString *str = [NSString stringWithFormat:@"mobi/user/addFeedBack?memberId=%@&mobile=%@&content=%@",[User shareUser].userId,_phoneTF.text,_contentView.text];
        [[HttpManager shareManger] getWithStr:str ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
            if ([[json objectForKey:@"code"] integerValue] == 0) {
                [[tools shared] HUDShowHideText:@"提交成功" delay:1.5];
                [self.navigationController popViewControllerAnimated:YES];
            }else {
                [[tools shared] HUDShowHideText:@"提交失败" delay:1.5];
            }
        } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            
        }];
        
        
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS]invertedSet];
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""]; //按cs分离出数组,数组按@""分离出字符串
    
    BOOL canChange = [string isEqualToString:filtered];
    
    return canChange;

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        
        _placeholderLable.hidden = NO;
    }else {
        _placeholderLable.hidden = YES;
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
