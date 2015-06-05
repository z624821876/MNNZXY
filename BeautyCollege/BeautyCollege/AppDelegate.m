//
//  AppDelegate.m
//  BeautyCollege
//
//  Created by 于洲 on 15/4/15.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "AppDelegate.h"
#import "UMSocialWechatHandler.h"
#import <AlipaySDK/AlipaySDK.h>
#import "GuideVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    [UMSocialData setAppKey:kUMkey];
    [UMSocialWechatHandler setWXAppId:kWXid appSecret:kWXSecret url:@"http://www.umeng.com/social"];
    //微信
    [WXApi registerApp:kWXid];
    //qq
    [UMSocialQQHandler setQQWithAppId:kqqid appKey:kqqkey url:@"http://www.umeng.com/social"];
    
//    //新浪
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
//    [UMSocialSinaSSOHandler openNewSinaSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    [self checkVersion];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor blackColor];
    [self buildMainTabBar];
    NSString *isFirst = [[NSUserDefaults standardUserDefaults] objectForKey:@"isFirst"];
    if ([isFirst isKindOfClass:[NSNull class]] || isFirst == nil) {
        GuideVC *vc = [[GuideVC alloc] init];
        self.window.rootViewController = vc;
    }else {
        [self showMainTabBar];
    }
    
    [self.window makeKeyAndVisible];
    
    
    // [1]:使用APPID/APPKEY/APPSECRENT创建个推实例
    [self startSdkWith:kGTAppId appKey:kGTAppKey appSecret:kGTAppSecret];
    
    // [2]:注册APNS
    [self registerRemoteNotification];
    
    // [2-EXT]: 获取启动时收到的APN
    NSDictionary* message = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (message) {
        NSString *payloadMsg = [message objectForKey:@"payload"];
        NSString *record = [NSString stringWithFormat:@"[APN]%@, %@", [NSDate date], payloadMsg];
        NSLog(@"-------------%@,%@",payloadMsg,record);

    }
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

    
    [MyTool getUserInfo];
    
    
    
    
    return YES;
}

- (void)showMainTabBar
{
    self.window.rootViewController = _mainTabBar;
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL request = [UMSocialSnsService handleOpenURL:url];
    if (request) {
        return YES;
    }
    return [WXApi handleOpenURL:url delegate:self];
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    //如果极简 SDK 不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给 SDK
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
        return YES;
    }
    if ([url.host isEqualToString:@"platformapi"]) {//支付宝钱包快登授权返回 authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
        return YES;
    }
    
    BOOL request = [UMSocialSnsService handleOpenURL:url];
    if (request) {
        return YES;
    }
    return [WXApi handleOpenURL:url delegate:self];
}

+ (AppDelegate *)shareApp
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return app;
}

- (NSInteger)currentPage
{
    return [self.mainTabBar selectedIndex];
}

- (void)buildMainTabBar
{
    _mainTabBar = [[UITabBarController alloc] init];
    SchoolVC *school=[[SchoolVC alloc] init];
    SchoolmateVC *mate = [[SchoolmateVC alloc] init];
    ClassroomVC *room = [[ClassroomVC alloc] init];
    SupermarketVC *market = [[SupermarketVC alloc] init];
    DormVC *dorm = [[DormVC alloc] init];
    
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:school];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:mate];
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:room];
    UINavigationController *nav4 = [[UINavigationController alloc] initWithRootViewController:market];
    UINavigationController *nav5 = [[UINavigationController alloc] initWithRootViewController:dorm];
    
    school.title = @"校园";
    mate.title = @"同学";
    room.title=@"课程";
    market.title=@"超市";
    dorm.title=@"宿舍";
    
    [school.tabBarItem setImage:[[UIImage imageNamed:@"tabicon_1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    school.tabBarItem.selectedImage=[[UIImage imageNamed:@"tabicon_1_s.png"
                                     ] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [mate.tabBarItem setImage:[[UIImage imageNamed:@"tabicon_2.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    mate.tabBarItem.selectedImage=[[UIImage imageNamed:@"tabicon_2_s.png"
                                    ] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [room.tabBarItem setImage:[[UIImage imageNamed:@"tabicon_3.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    room.tabBarItem.selectedImage=[[UIImage imageNamed:@"tabicon_3_s.png"
                                     ] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [market.tabBarItem setImage:[[UIImage imageNamed:@"tabicon_4.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

    market.tabBarItem.selectedImage=[[UIImage imageNamed:@"tabicon_4_s.png"
                       
                                     ] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [dorm.tabBarItem setImage:[[UIImage imageNamed:@"tabicon_5.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

    dorm.tabBarItem.selectedImage=[[UIImage imageNamed:@"tabicon_5_s.png"
                                   ] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    [school.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[UIColor grayColor],[UIFont systemFontOfSize:11], nil]
                                                                        forKeys:[NSArray arrayWithObjects:NSForegroundColorAttributeName,NSFontAttributeName, nil]] forState:UIControlStateNormal];
    
    
    [mate.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[UIColor grayColor],[UIFont systemFontOfSize:11], nil]
                                                                          forKeys:[NSArray arrayWithObjects:NSForegroundColorAttributeName,NSFontAttributeName, nil]] forState:UIControlStateNormal];
    [room.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[UIColor grayColor],[UIFont systemFontOfSize:11], nil]
                                                                          forKeys:[NSArray arrayWithObjects:NSForegroundColorAttributeName,NSFontAttributeName, nil]] forState:UIControlStateNormal];
    [market.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[UIColor grayColor],[UIFont systemFontOfSize:11], nil]
                                                                         forKeys:[NSArray arrayWithObjects:NSForegroundColorAttributeName,NSFontAttributeName, nil]] forState:UIControlStateNormal];
    
    
    [dorm.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[UIColor grayColor],[UIFont systemFontOfSize:11], nil]
                                                                          forKeys:[NSArray arrayWithObjects:NSForegroundColorAttributeName,NSFontAttributeName, nil]] forState:UIControlStateNormal];
    
    [school.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[Util
                                                                                                           colorWithHexString:@"#cf1485"],[UIFont systemFontOfSize:11], nil]
                                                                        forKeys:[NSArray arrayWithObjects:NSForegroundColorAttributeName,NSFontAttributeName, nil]] forState:UIControlStateSelected];
    
    
    [market.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[Util
                                                                                                             colorWithHexString:@"#cf1485"],[UIFont systemFontOfSize:11], nil]
                                                                          forKeys:[NSArray arrayWithObjects:NSForegroundColorAttributeName,NSFontAttributeName, nil]] forState:UIControlStateSelected];
    [mate.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[Util
                                                                                                             colorWithHexString:@"#cf1485"],[UIFont systemFontOfSize:11], nil]
                                                                          forKeys:[NSArray arrayWithObjects:NSForegroundColorAttributeName,NSFontAttributeName, nil]] forState:UIControlStateSelected];
    [room.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[Util
                                                                                                            colorWithHexString:@"#cf1485"],[UIFont systemFontOfSize:11], nil]
                                                                         forKeys:[NSArray arrayWithObjects:NSForegroundColorAttributeName,NSFontAttributeName, nil]] forState:UIControlStateSelected];
    [dorm.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[Util
                                                                                                             colorWithHexString:@"#cf1485"],[UIFont systemFontOfSize:11], nil]
                                                                          forKeys:[NSArray arrayWithObjects:NSForegroundColorAttributeName,NSFontAttributeName, nil]] forState:UIControlStateSelected];
    
    NSArray *array=[[NSArray alloc] initWithObjects:nav1,nav2,nav3,nav4,nav5,nil];
    
    _mainTabBar.viewControllers = array;
    _mainTabBar.tabBar.backgroundColor = [UIColor clearColor];
    _mainTabBar.tabBar.backgroundImage = [UIImage imageNamed:@"navbg.9.png"];
    UIImage *img = [UIImage new];
    [_mainTabBar.tabBar setShadowImage:img];

}

- (void)checkVersion
{
    //异步检查更新版本
    NSString *dateFromData = [NSString stringWithFormat:@"%@", [DateUtil getLocaleDateStr:[NSDate date]]];
    NSString *date = [dateFromData substringWithRange:NSMakeRange(0, 10)];
    NSString *lastVersionCheckDate = [[NSUserDefaults standardUserDefaults] valueForKey:kUserDefaultsLastVersionCheckDate];
    
    if (![lastVersionCheckDate isEqualToString:date])
    {
        NSString *URL = sVersionURL;
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:URL]];
        [request setHTTPMethod:@"GET"];
        [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *resopnse, NSData *data, NSError *error) {
            if (data)
            {
                NSPropertyListFormat format;
                NSDictionary *dict = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:&format error:&error];
                NSString* version;
                NSString* versionInfo;
                for(NSString*  key in dict){
                    version = [[NSString alloc] initWithFormat:@"%@",key];
                    NSMutableArray *templist=[dict objectForKey:key];
                    versionInfo=[templist objectAtIndex:0];
                    break;
                }
                [self performSelectorOnMainThread:@selector(VersionAlert:) withObject:[NSArray arrayWithObjects:version,versionInfo,nil]  waitUntilDone:NO];
                
            }        }];
        [[NSUserDefaults standardUserDefaults] setObject:date forKey:kUserDefaultsLastVersionCheckDate];
    }
}

-(void)VersionAlert:(NSArray *)array{
    if ([array count] != 0) {
        NSString *version = [array objectAtIndex:0];
        NSString *versionInfo = [array objectAtIndex:1];
        
        NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
        NSString *currentVersion = [infoDict objectForKey:@"CFBundleVersion"];
        [[tools shared] HUDHide];
        if (version!=nil&&![version isEqualToString:@""]&&![version isEqualToString:currentVersion]) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"版本%@更新",version] message:versionInfo delegate:self cancelButtonTitle:@"立即更新" otherButtonTitles:@"稍后提醒", nil];
            [alert show];
        }

        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0)
    {
        NSURL *aURL = [NSURL URLWithString:sVersionDownloadURL];
        [[UIApplication sharedApplication] openURL:aURL];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    // [EXT] 切后台关闭SDK，让SDK第一时间断线，让个推先用APN推送
    [self stopSdk];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    [UMSocialSnsService  applicationDidBecomeActive];
    //当程序还在后台运行
    application.applicationIconBadgeNumber = 0;
    [self startSdkWith:kGTAppId appKey:kGTAppKey appSecret:kGTAppSecret];

}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark ---  微信登录
- (void)WXlogin
{
    //构造SendAuthReq结构体
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo" ;
    req.state = @"123" ;
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
}

//微信登陆回调方法
-(void) onResp:(BaseResp*)resp
{
    if (resp.errCode == WXSuccess) {
        if ([resp isKindOfClass:[SendAuthResp class]]) {
            SendAuthResp *sendResp = (SendAuthResp *)resp;
            _mainTabBar.selectedIndex = 0;
            
            //            [[tools shared] HUDShowText:@"正在加载数据..."];
            //登陆成功
            NSString *str = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",kWXid,kWXSecret,sendResp.code];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSURL *zoneUrl = [NSURL URLWithString:str];
                NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
                NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (data) {
                        
                        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                        self.accessToken = [dic objectForKey:@"access_token"];
                        self.unionId = [dic objectForKey:@"unionid"];
                        self.openId = [dic objectForKey:@"openid"];
                        
                        //根据token  获取用户信息
                        [self getUserInfo];
                    }else {
                        [[tools shared] HUDHide];
                    }
                });
            });
        }else {
            if (resp.errCode == WXSuccess) {
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"成功" message:@"分享成功" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
                [alertView show];
            } else {
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"失败" message:@"分享失败" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
                [alertView show];
            }
            
        }
        
    }
}

//根据token 获取用户信息
- (void)getUserInfo
{
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",self.accessToken,self.openId];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                NSString *name = [dic objectForKey:@"nickname"];
                NSString *headimgurl = [dic objectForKey:@"headimgurl"];
                NSString *unionid = [dic objectForKey:@"unionid"];
                NSString *sex = [dic objectForKey:@"sex"];
                [self uploadLoginInfoWithType:1 externalNo:unionid externalName:name token:self.accessToken logo:headimgurl sex:sex];
                //                NSString *str = [NSString stringWithFormat:@"http://3fxadmin.53xsd.com/mobi/account/thirdAccountLog?from=1&externalNo=%@&externalName=%@&token=%@&logo=%@&shopId=%d",self.unionId,name,self.clientId,headimgurl,SHOP_ID];
//                
//                [HttpManager requstWithUrlStr:str WithComplentionBlock:^(id json) {
//                    
//                    if ([[json objectForKey:@"message"] isEqualToString:@"Login Successed"]) {
//                        NSDictionary *dataDic = [json objectForKey:@"result"];
//                        User *user = [User shareUser];
//                        user.name = name;
//                        user.userId = [dataDic objectForKey:@"id"];
//                        user.logo = [dataDic objectForKey:@"logo"];
//                        user.openId = self.unionId;
//                        
//                        NSMutableData *data = [[NSMutableData alloc] init];
//                        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
//                        [archiver encodeObject:user forKey:KuserKey];
//                        [archiver finishEncoding];
//                        NSString *path = [PATH_OF_DOCUMENT stringByAppendingPathComponent:@"MyUser"];
//                        [data writeToFile:path atomically:YES];
//                        
//                        [self submitClientIdWithUserId:user.userId];
//                    }
//                }];
            }
            
        });
    });
}

#pragma mark ---  QQ登录
- (void)QQlogin
{
    //qq登录
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    
    snsPlatform.loginClickHandler(_mainTabBar,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
            
            [self uploadLoginInfoWithType:3 externalNo:snsAccount.usid externalName:snsAccount.userName token:snsAccount.accessToken logo:snsAccount.iconURL sex:@"0"];
        }});
}

#pragma mark ---  新浪登录
- (void)SinaLogin
{
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    
    snsPlatform.loginClickHandler(_mainTabBar,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
            
            [self uploadLoginInfoWithType:3 externalNo:snsAccount.usid externalName:snsAccount.userName token:snsAccount.accessToken logo:snsAccount.iconURL sex:@"0"];
        }
    
    });
}

#pragma mark ---  上传登陆信息
- (void)uploadLoginInfoWithType:(NSInteger)type externalNo:(NSString *)number externalName:(NSString *)name token:(NSString *)token logo:(NSString *)logo sex:(NSString *)sex
{
//    @RequestParam Integer from,//1=weixin,2=weibo,3=qq
//    @RequestParam String externalNo,
//    @RequestParam String externalName,
//    @RequestParam String token,
//    @RequestParam String logo
    
    [[tools shared] HUDShowHideText:@"正在登陆..." delay:1.5];
    NSString *str = [NSString stringWithFormat:@"mobi/account/thirdAccountLog?from=%ld&externalNo=%@&externalName=%@&token=%@&logo=%@&sex=%@",type,number,name,token,logo,sex];
    [[HttpManager shareManger] getWithStr:str ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
        [[tools shared] HUDHide];
        NSInteger code = [[json objectForKey:@"code"] integerValue];
        if (code == 0) {
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
            NSString *str = nilOrJSONObjectForKey(dic, @"signature");
            user.signature = str == nil ? @"" : str;
            user.cityName = nilOrJSONObjectForKey(dic, @"cityName");
            NSMutableData *data = [[NSMutableData alloc] init];
            NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
            [archiver encodeObject:user forKey:@"user"];
            [archiver finishEncoding];
            NSString *path = [PATH_OF_DOCUMENT stringByAppendingPathComponent:@"MyUser"];
            [data writeToFile:path atomically:YES];
            [self submitClientIdWithUserId:nil];
        }else {
            [[tools shared] HUDShowHideText:[json objectForKey:@"message"] delay:1.5];
        }
        
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];

}

#pragma mark - 推送
//注册通知
- (void)registerRemoteNotification
{
#ifdef __IPHONE_8_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        
        UIUserNotificationSettings *uns = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound) categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:uns];
    } else {
        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
    }
#else
    UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge);
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
#endif
    
}

- (NSString *)currentLogFilePath
{
    NSMutableArray * listing = [NSMutableArray array];
    NSString *docsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSArray * fileNames = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:docsDirectory error:nil];
    if (!fileNames) {
        return nil;
    }
    
    for (NSString * file in fileNames) {
        if (![file hasPrefix:@"_log_"]) {
            continue;
        }
        
        NSString * absPath = [docsDirectory stringByAppendingPathComponent:file];
        BOOL isDir = NO;
        if ([[NSFileManager defaultManager] fileExistsAtPath:absPath isDirectory:&isDir]) {
            if (isDir) {
                [listing addObject:absPath];
            } else {
                [listing addObject:absPath];
            }
        }
    }
    
    [listing sortUsingComparator:^(NSString *l, NSString *r) {
        return [l compare:r];
    }];
    
    if (listing.count) {
        return [listing objectAtIndex:listing.count - 1];
    }
    
    return nil;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    //    [_deviceToken release];
    _deviceToken = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"deviceToken:%@", _deviceToken);
    
    // [3]:向个推服务器注册deviceToken
    if (_gexinPusher) {
        [_gexinPusher registerDeviceToken:_deviceToken];
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    // [3-EXT]:如果APNS注册失败，通知个推服务器
    if (_gexinPusher) {
        [_gexinPusher registerDeviceToken:@""];
    }
    
    //    [_viewController logMsg:[NSString stringWithFormat:@"didFailToRegisterForRemoteNotificationsWithError:%@", [error localizedDescription]]];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userinfo
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    // [4-EXT]:处理APN
    //    NSString *payloadMsg = [userinfo objectForKey:@"payload"];
    //    NSString *record = [NSString stringWithFormat:@"[APN]%@, %@", [NSDate date], payloadMsg];
    //    [_viewController logMsg:record];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    // [4-EXT]:处理APN
    NSString *payloadMsg = [userInfo objectForKey:@"payload"];
    NSDictionary *aps = [userInfo objectForKey:@"aps"];
    NSNumber *contentAvailable = aps == nil ? nil : [aps objectForKeyedSubscript:@"content-available"];
    
    //    NSString *record = [NSString stringWithFormat:@"[APN]%@, %@, [content-available: %@]", [NSDate date], payloadMsg, contentAvailable];
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)startSdkWith:(NSString *)appID appKey:(NSString *)appKey appSecret:(NSString *)appSecret
{
    if (!_gexinPusher) {
        _sdkStatus = SdkStatusStoped;
        
        self.appID = appID;
        self.appKey = appKey;
        self.appSecret = appSecret;
        
        _clientId = nil;
        
        NSError *err = nil;
        _gexinPusher = [GexinSdk createSdkWithAppId:_appID
                                             appKey:_appKey
                                          appSecret:_appSecret
                                         appVersion:@"0.0.0"
                                           delegate:self
                                              error:&err];
        if (!_gexinPusher) {
            
        } else {
            _sdkStatus = SdkStatusStarting;
        }
        
    }
}

- (void)stopSdk
{
    if (_gexinPusher) {
        [_gexinPusher destroy];
        
        _gexinPusher = nil;
        
        _sdkStatus = SdkStatusStoped;
        
        
        _clientId = nil;
        
    }
}

- (BOOL)checkSdkInstance
{
    if (!_gexinPusher) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:@"SDK未启动" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        return NO;
    }
    return YES;
}

- (void)setDeviceToken:(NSString *)aToken
{
    if (![self checkSdkInstance]) {
        return;
    }
    
    [_gexinPusher registerDeviceToken:aToken];
}

- (BOOL)setTags:(NSArray *)aTags error:(NSError **)error
{
    if (![self checkSdkInstance]) {
        return NO;
    }
    
    return [_gexinPusher setTags:aTags];
}

- (NSString *)sendMessage:(NSData *)body error:(NSError **)error {
    if (![self checkSdkInstance]) {
        return nil;
    }
    
    return [_gexinPusher sendMessage:body error:error];
}

- (void)bindAlias:(NSString *)aAlias {
    if (![self checkSdkInstance]) {
        return;
    }
    
    return [_gexinPusher bindAlias:aAlias];
}

- (void)unbindAlias:(NSString *)aAlias {
    if (![self checkSdkInstance]) {
        return;
    }
    
    return [_gexinPusher unbindAlias:aAlias];
}

#pragma mark - GexinSdkDelegate
- (void)GexinSdkDidRegisterClient:(NSString *)clientId
{
    // [4-EXT-1]: 个推SDK已注册
    _sdkStatus = SdkStatusStarted;
    
    self.clientId = clientId;
    
    //提交 推送ID
    [self submitClientIdWithUserId:nil];
    
//    DLog(@"-----------------%@",self.clientId);
}

- (void)GexinSdkDidReceivePayload:(NSString *)payloadId fromApplication:(NSString *)appId
{
    //    [[UIApplication sharedApplication] isFirstResponder];
    // [4]: 收到个推消息
    
    self.payloadId = payloadId;
    NSData *payload = [_gexinPusher retrivePayloadById:payloadId];
    NSString *payloadMsg = nil;
    if (payload) {
        payloadMsg = [[NSString alloc] initWithBytes:payload.bytes
                                              length:payload.length
                                            encoding:NSUTF8StringEncoding];
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:payloadMsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    
//    DLog(@"%@",record);
}

- (void)GexinSdkDidSendMessage:(NSString *)messageId result:(int)result {
    // [4-EXT]:发送上行消息结果反馈
}

- (void)GexinSdkDidOccurError:(NSError *)error
{
    // [EXT]:个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
    //    [_viewController logMsg:[NSString stringWithFormat:@">>>[GexinSdk error]:%@", [error localizedDescription]]];
    
//    DLog(@"%@",[NSString stringWithFormat:@">>>[GexinSdk error]:%@", [error localizedDescription]]);
}
    //上传  clientID
- (void)submitClientIdWithUserId:(NSString *)uid
{
    if ([User shareUser].userId != nil && self.clientId != nil) {
        NSString *str = [NSString stringWithFormat:@"getui/saveToken?token=%@&userId=%@&uutype=IOS&type=",self.clientId,[User shareUser].userId];
        [[HttpManager shareManger] getWithStr:str ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
            if ([[json objectForKey:@"message"] isEqualToString:@"success!"]) {
                NSLog(@"上传成功");
            }else {
                [self submitClientIdWithUserId:nil];
            }
        } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self submitClientIdWithUserId:nil];
        }];
    }
}

@end
