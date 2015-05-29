
//
//  ShareVC.m
//  BeautyCollege
//
//  Created by 于洲 on 15/5/14.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "ShareVC.h"

@interface ShareVC ()
{
    NSArray *UMarr;
    NSDictionary *UMdic;
}

@end

@implementation ShareVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationItem.title = @"我的邀请链接";
    self.view.backgroundColor = ColorWithRGBA(218.0, 225.0, 227.0, 1);

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UMarr = [NSArray arrayWithObjects:
             UMShareToWechatSession,
             UMShareToWechatTimeline,
             nil];
    
    UMdic = [NSDictionary dictionaryWithObjectsAndKeys:
             @"微信好友",UMShareToWechatSession,
             @"微信朋友圈",UMShareToWechatTimeline,
             nil];

    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64 + 20, UI_SCREEN_WIDTH, 40 + 20 * UI_scaleY)];
    [img setImage:[[UIImage imageNamed:@"coursebg_16.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)]];
    [self.view addSubview:img];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(img.left + 15, img.top + 10 * UI_scaleY, img.width - 30, 40)];
    label.numberOfLines = 2;
    label.font = [UIFont systemFontOfSize:15];
    label.text = @"你的邀请链接已生成，没邀请一位好友就可获得10美币，想想还有点小激动呢！赶快行动吧~";
    [self.view addSubview:label];

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((UI_SCREEN_WIDTH - 200 * UI_scaleX) / 2.0, img.bottom + 20, 200 * UI_scaleX, 200 * UI_scaleX)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[User shareUser].regLinkImg]];
    [self.view addSubview:imageView];
 
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(label.left, imageView.bottom + 10 * UI_scaleY, label.width, label.height + 20)];
    label1.numberOfLines = 0;
    label1.font = [UIFont systemFontOfSize:15];
    label1.text = [NSString stringWithFormat:@"我的分享链接:%@",[User shareUser].regLink];
    [self.view addSubview:label1];
    
    UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(label1.left, label1.bottom + 10 * UI_scaleY, label1.width, 30)];
    shareBtn.backgroundColor = BaseColor;
    [shareBtn setTitle:@"一键分享" forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareBtn];
}

- (void)share
{
    [UMSocialData defaultData].extConfig.wechatSessionData.url = [[User shareUser] regLink];
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = [[User shareUser] regLink];
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"54c7576ffd98c5acfd0007ce"
                                      shareText:@"美娘女子学院"
                                     shareImage:[UIImage imageNamed:@"icon.png"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,nil]
                                       delegate:self];
    
//    UIActionSheet * editActionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
//    for (NSString *snsName in UMarr) {
//        NSString *displayName = [UMdic valueForKey:snsName];
//        [editActionSheet addButtonWithTitle:displayName];
//    }
//    
//    [editActionSheet addButtonWithTitle:@"取消"];
//    editActionSheet.cancelButtonIndex = editActionSheet.numberOfButtons - 1;
//    [editActionSheet showInView:self.view];
}

- (void)shareWith:(NSString *)snsName
{
    UIImage *img = [UIImage imageNamed:@"icon.png"];
    [UMSocialData defaultData].extConfig.wechatSessionData.title = @"美娘女子学院";
    [UMSocialData defaultData].extConfig.wechatSessionData.url = [[User shareUser] regLink];
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = [[User shareUser] regLink];
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"美娘女子学院";

    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[snsName] content:@"美娘女子学院" image:img location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity * response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"成功" message:@"分享成功" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
            [alertView show];
        } else if(response.responseCode != UMSResponseCodeCancel) {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"失败" message:@"分享失败" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
            [alertView show];
        }
    }];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex <= 1) {
        
        //分享编辑页面的接口,snsName可以换成你想要的任意平台，例如UMShareToSina,UMShareToWechatTimeline
        NSString *snsName = [UMarr objectAtIndex:buttonIndex];
        [self shareWith:snsName];
        
    }
    
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
