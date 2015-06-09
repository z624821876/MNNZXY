//
//  AppDelegate.h
//  BeautyCollege
//
//  Created by 于洲 on 15/4/15.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SchoolVC.h"
#import "SchoolmateVC.h"
#import "ClassroomVC.h"
#import "SupermarketVC.h"
#import "DormVC.h"
#import "WXApi.h"
#import "GexinSdk.h"

typedef enum {
    SdkStatusStoped,
    SdkStatusStarting,
    SdkStatusStarted
} SdkStatus;


@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate,GexinSdkDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *mainTabBar;

@property (strong, nonatomic) NSString *openId;
@property (strong, nonatomic) NSString *accessToken;
@property (strong, nonatomic) NSString *unionId;


@property (strong, nonatomic) NSString *deviceToken;
@property (strong, nonatomic) GexinSdk *gexinPusher;
@property (retain, nonatomic) NSString *appKey;
@property (retain, nonatomic) NSString *appSecret;
@property (retain, nonatomic) NSString *appID;
@property (retain, nonatomic) NSString *clientId;
@property (assign, nonatomic) SdkStatus sdkStatus;
@property (assign, nonatomic) int lastPayloadIndex;
@property (retain, nonatomic) NSString *payloadId;


- (void)startSdkWith:(NSString *)appID appKey:(NSString *)appKey appSecret:(NSString *)appSecret;
- (NSInteger)currentPage;
+ (AppDelegate *)shareApp;
- (void)showMainTabBar;
- (void)registerRemoteNotification;
- (void)stopSdk;
- (void)WXlogin;
- (void)QQlogin;
- (void)SinaLogin;
@end

