//
//  User.h
//  BeautyCollege
//
//  Created by 于洲 on 15/4/24.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject<NSCoding>

@property (strong, nonatomic) NSString      *cityName;
@property (strong, nonatomic) NSString      *userId;
@property (strong, nonatomic) NSString      *userName;
@property (strong, nonatomic) NSString      *nickname;
@property (strong, nonatomic) NSString      *level;
@property (strong, nonatomic) NSString      *levelName;
@property (strong, nonatomic) NSString      *score;
@property (strong, nonatomic) NSString      *logo;
@property (strong, nonatomic) NSString      *sex;
@property (strong, nonatomic) NSString      *signature;
+ (User *)shareUser;
    //分享链接
@property (strong, nonatomic) NSString      *regLink;
    //分享二维码
@property (strong, nonatomic) NSString      *regLinkImg;
@end
