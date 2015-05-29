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

@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *mainTabBar;

@property (strong, nonatomic) NSString *openId;
@property (strong, nonatomic) NSString *accessToken;
@property (strong, nonatomic) NSString *unionId;



- (NSInteger)currentPage;
+ (AppDelegate *)shareApp;



- (void)WXlogin;
- (void)QQlogin;
- (void)SinaLogin;
@end

