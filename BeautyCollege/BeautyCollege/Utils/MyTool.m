//
//  MyTool.m
//  BeautyCollege
//
//  Created by 于洲 on 15/4/20.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "MyTool.h"


@implementation MyTool

+ (id)shareTools
{
    static MyTool *tool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[MyTool alloc] init];
    });
    return tool;
}

#pragma mark -- 检查是否已经登录
+ (BOOL)isLogin
{
    NSString *path = [PATH_OF_DOCUMENT stringByAppendingPathComponent:@"MyUser"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        return YES;
    }
    return NO;
}

+ (BOOL)getUserInfo
{
    NSString *path = [PATH_OF_DOCUMENT stringByAppendingPathComponent:@"MyUser"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        
        User *user = [User shareUser];
        User *model = [unarchiver decodeObjectForKey:@"user"];
        [unarchiver finishDecoding];
        user.userId = model.userId;
        user.userName = model.userName;
        user.nickname = model.nickname;
        user.level = model.level;
        user.levelName = model.levelName;
        user.score = model.score;
        user.logo = model.logo;
        user.sex = model.sex;
        user.regLink = model.regLink;
        user.regLinkImg = model.regLinkImg;
        user.signature = model.signature;
        user.cityName = model.cityName;
        return YES;
    }
    return NO;
}

    //验证手机号
+ (BOOL)viableMobileWith:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[2378])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

    //文本转表情
+ (NSMutableAttributedString *)textTransformEmoji:(NSString *)text
{
    if (!text) {
        return nil;
    }
    NSMutableAttributedString *imgStr1 = [[NSMutableAttributedString alloc] initWithString:text];
    NSString *pattern = @"f0[0-9][0-9]";
    NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *resultArray = [re matchesInString:text options:0 range:NSMakeRange(0, text.length)];
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:resultArray.count];
    for(NSTextCheckingResult *match in resultArray) {
        NSRange range = [match range];
        NSString *imgName = [text substringWithRange:range];
        //新建文字附件来存放我们的图片
        NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
        //给附件添加图片
        textAttachment.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",imgName]];
//        textAttachment.bounds = CGRectMake(0, 0, 25, 25);
        //把附件转换成可变字符串，用于替换掉源字符串中的表情文字
        NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
        NSMutableDictionary *imageDic = [NSMutableDictionary dictionaryWithCapacity:2];
        [imageDic setObject:imageStr forKey:@"image"];
        [imageDic setObject:[NSValue valueWithRange:range] forKey:@"range"];
        //把字典存入数组中
        [imageArray addObject:imageDic];
    }
    
    for (NSInteger i = imageArray.count -1; i >= 0; i--)
    {
        NSDictionary *rangeDic = imageArray[i];
        NSRange range22 = [[rangeDic objectForKey:@"range"] rangeValue];
        //进行替换
        [imgStr1 replaceCharactersInRange:range22 withAttributedString:[rangeDic objectForKey:@"image"]];
    }
    return imgStr1;
}


+ (void)setImgWithURLStr:(NSString *)str withplaceholderImage:(UIImage *)img withImgView:(UIImageView *)imgView
{
    NSString *url;
    if ([str hasPrefix:@"http"]) {
        url = str;
    }else {
        url = [NSString stringWithFormat:@"%@%@",sBaseImgUrlStr,str];
    }
    
    [imgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:img];
}

+ (void)setBtnImgWithURLStr:(NSString *)str withplaceholderImage:(UIImage *)img withImgView:(UIButton *)btn
{
    NSString *url;
    if ([str hasPrefix:@"http"]) {
        url = str;
    }else {
        url = [NSString stringWithFormat:@"%@%@",sBaseImgUrlStr,str];
    }
    
    [btn sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal placeholderImage:img];
}


+ (NSString *)getValuesFor:(NSDictionary *)dic key:(NSString *)str
{
    id value = nilOrJSONObjectForKey(dic, str);
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value stringValue];
    }
    return value;
}
@end













