//
//  Util.h
//  mlh
//
//  Created by qd on 13-5-10.
//  Copyright (c) 2013年 sunday. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Util : NSObject

//字符串转颜色
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert;

//去掉空格
+(NSString *) stringByRemoveTrim:(NSString *)str;

//不转webview打不开啊。。
+(NSString *)getWebViewUrlStr:(NSString *)urlStr;

//NSString UTF8转码
+(NSString *)getUTF8Str:(NSString *)str;

//根据文字、字体、文字区域宽度，得到文字区域高度
+ (CGFloat)heightForText:(NSString*)sText Font:(UIFont*)font forWidth:(CGFloat)fWidth;

//view根据原来的frame做调整，重新setFrame，fakeRect的4个参数如果<0，则用原来frame的相关参数，否则就用新值。
+ (void) View:(UIView *)view ReplaceFrameWithRect:(CGRect) fakeRect;

//view根据原来的bounds做调整，重新setBounds，fakeRect的4个参数如果<0，则用原来bounds的相关参数，否则就用新值。
+ (void) View:(UIView *)view ReplaceBoundsWithRect:(CGRect) fakeRect;

//根据@"#eef4f4"得到UIColor
+ (UIColor *) uiColorFromString:(NSString *) clrString;
+ (UIColor *) uiColorFromString:(NSString *) clrString alpha:(double)alpha;

//将原始图片draw到指定大小范围，从而得到并返回新图片。能缩小图片尺寸和大小
+ (UIImage*)ScaleImage:(UIImage*)image ToSize:(CGSize)newSize;
//将图片保存到document目录下
+ (void)saveDocImage:(UIImage *)tempImage WithName:(NSString *)imageName;

//将浮点数转换为NSString，并设置保留小数点位数
+ (NSString *)getStringFromFloat:(float) f withDecimal:(int) decimalPoint;

//判断字符串为nil或""
+ (BOOL)isNil:(NSString *)str;
//判断时间差
+(NSString *)dateIntervalStr:(NSString *)startDateStr;
    //美娘专用
+(NSString *)MNdateIntervalStr:(NSString *)startDateStr;
//从color生成image
+ (UIImage *)createImageWithColor:(UIColor *)color;

+(UIImage *)imageClips:(UIImage *)oldImage Rect:(CGRect)rect;


    //根据级别生成图片  美娘专用
+ (UIImage *)studentImageWithLevel:(NSString *)str;
+ (UIImage *)teacherImageWithLevel:(NSString *)str;
+ (UIImage *)teacherImageWithLevel2:(NSString *)str;
+ (UIImage *)sexImageWithNSString:(NSString *)str;
+ (UIImage *)sexImageWithNSString2:(NSString *)str;
@end
