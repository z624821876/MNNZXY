//
//  MyTool.h
//  BeautyCollege
//
//  Created by 于洲 on 15/4/20.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

@interface MyTool : NSObject<WXApiDelegate>
+ (id)shareTools;
+ (BOOL)isLogin;
+ (BOOL)getUserInfo;

        //验证手机号
+ (BOOL)viableMobileWith:(NSString *)mobileNum;

+ (void)setImgWithURLStr:(NSString *)str withplaceholderImage:(UIImage *)img withImgView:(UIImageView *)imgView;
+ (void)setBtnImgWithURLStr:(NSString *)str withplaceholderImage:(UIImage *)img withImgView:(UIButton *)btn;

        //文本转表情
+ (NSMutableAttributedString *)textTransformEmoji:(NSString *)text;

+ (NSString *)getValuesFor:(NSDictionary *)dic key:(NSString *)str;

@end
