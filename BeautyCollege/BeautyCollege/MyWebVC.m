//
//  MyWebVC.m
//  BeautyCollege
//
//  Created by 于洲 on 15/5/4.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "MyWebVC.h"

@interface MyWebVC ()

@property (nonatomic, strong) UIWebView         *webView;

@end

@implementation MyWebVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if (_type == 10) {
        
        self.navigationItem.title = @"关于美娘";
    }else {
        self.navigationItem.title = @"美娘公告";
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 64)];
    _webView.scalesPageToFit = YES;
    _webView.delegate = self;
    [self.view addSubview:_webView];
    
    if (_type == 10) {
        
        NSString *str = @"mobi/index/getAboutUs";
        [[tools shared] HUDShowText:@"请稍候..."];
        [[HttpManager shareManger] getWithStr:str ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
            if ([[json objectForKey:@"code"] integerValue] == 0) {
                NSDictionary *dic = nilOrJSONObjectForKey(json, @"result");
                _URLStr = nilOrJSONObjectForKey(dic, @"url");
                NSURL *url = [NSURL URLWithString:_URLStr];
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                [_webView loadRequest:request];

            }
            
        } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];
    }else {
        NSURL *url = [NSURL URLWithString:_URLStr];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [_webView loadRequest:request];
        [[tools shared] HUDShowText:@"请稍候..."];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[tools shared] HUDHide];
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
