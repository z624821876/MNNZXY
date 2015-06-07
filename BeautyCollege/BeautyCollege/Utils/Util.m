//
//  Util.m
//  mlh
//
//  Created by qd on 13-5-10.
//  Copyright (c) 2013年 sunday. All rights reserved.
//

#import "Util.h"


@implementation Util : NSObject

//NSString UTF8转码
+(NSString *)getUTF8Str:(NSString *)str{
    return [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

//不转webview打不开啊。。
+(NSString *)getWebViewUrlStr:(NSString *)urlStr{
    return [urlStr stringByAddingPercentEscapesUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
}

//去掉空格
+(NSString *) stringByRemoveTrim:(NSString *)str{
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

//根据文字、字体、文字区域宽度，得到文字区域高度
+ (CGFloat)heightForText:(NSString*)sText Font:(UIFont*)font forWidth:(CGFloat)fWidth{
    CGSize szContent = [sText sizeWithFont:font constrainedToSize:CGSizeMake(fWidth, CGFLOAT_MAX)
                             lineBreakMode:UILineBreakModeWordWrap];
    return  szContent.height;
}

//根据文字信息和url，得到最终的文字message（总长度不超过140）。 url可以为nil。
-(NSString *)getMessageWithText:(NSString *)text url:(NSString *)url{
    if (text == nil && url == nil) {
        return nil;
    }
    if (text == nil) {
        return url;
    }
    
    //text != nil
    NSMutableString *messageText  = [[NSMutableString alloc] init];
    if (url == nil) {
        int trimlength =  [text length]- 140;
        if (trimlength > 0) {
            [messageText appendFormat:@"%@",[text substringWithRange:NSMakeRange(0, [text length]-trimlength)]];
        }else{
            [messageText appendFormat:@"%@",text];
        }
        NSLog(@"%u%@",[messageText length],messageText);
        return messageText;
    }else{
        int trimlength =  [text length] + [url length] - 140;
        if (trimlength > 0) {
            [messageText appendFormat:@"%@%@",[text substringWithRange:NSMakeRange(0, [text length]-trimlength)],url];
        }else{
            [messageText appendFormat:@"%@%@",text,url];
        }
        NSLog(@"%u%@",[messageText length],messageText);
        return messageText;
    }
    
}

//view根据原来的frame做调整，重新setFrame，fakeRect的4个参数如果<0，则用原来frame的相关参数，否则就用新值。
+ (void) View:(UIView *)view ReplaceFrameWithRect:(CGRect) fakeRect{
    CGRect frame = view.frame;
    CGRect newRect;
    newRect.origin.x = fakeRect.origin.x > 0 ? fakeRect.origin.x : frame.origin.x;
    newRect.origin.y = fakeRect.origin.y > 0 ? fakeRect.origin.y : frame.origin.y;
    newRect.size.width = fakeRect.size.width > 0 ? fakeRect.size.width : frame.size.width;
    newRect.size.height = fakeRect.size.height > 0 ? fakeRect.size.height : frame.size.height;
    [view setFrame:newRect];
}

//view根据原来的bounds做调整，重新setBounds，fakeRect的4个参数如果<0，则用原来bounds的相关参数，否则就用新值。
+ (void) View:(UIView *)view ReplaceBoundsWithRect:(CGRect) fakeRect{
    CGRect bounds = view.bounds;
    CGRect newRect;
    newRect.origin.x = fakeRect.origin.x > 0 ? fakeRect.origin.x : bounds.origin.x;
    newRect.origin.y = fakeRect.origin.y > 0 ? fakeRect.origin.y : bounds.origin.y;
    newRect.size.width = fakeRect.size.width > 0 ? fakeRect.size.width : bounds.size.width;
    newRect.size.height = fakeRect.size.height > 0 ? fakeRect.size.height : bounds.size.height;
    [view setBounds:newRect];
}

//根据@"#eef4f4"得到UIColor
+ (UIColor *) uiColorFromString:(NSString *) clrString
{
	return [Util uiColorFromString:clrString alpha:1.0];
}

//将原始图片draw到指定大小范围，从而得到并返回新图片。能缩小图片尺寸和大小
+ (UIImage*)ScaleImage:(UIImage*)image ToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//将图片保存到document目录下
+ (void)saveDocImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSData* imageData = UIImageJPEGRepresentation(tempImage, 0.4);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    [imageData writeToFile:fullPathToFile atomically:NO];
}

+ (UIColor *) uiColorFromString:(NSString *) clrString alpha:(double)alpha
{
	if ([clrString length] == 0) {
		return [UIColor clearColor];
	}
	
	if ( [clrString caseInsensitiveCompare:@"clear"] == NSOrderedSame) {
		return [UIColor clearColor];
	}
	
	if([clrString characterAtIndex:0] == 0x0023 && [clrString length]<8)
	{
		const char * strBuf= [clrString UTF8String];
		
		NSInteger iColor = strtol((strBuf+1), NULL, 16);
		typedef struct colorByte
		{
			unsigned char b;
			unsigned char g;
			unsigned char r;
		}CLRBYTE;
		CLRBYTE * pclr = (CLRBYTE *)&iColor;
		return [UIColor colorWithRed:((double)pclr->r/255) green:((double)pclr->g/255) blue:((double)pclr->b/255) alpha:alpha];
	}
	return [UIColor blackColor];
}

//字符串转颜色
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    
    if ([cString length] < 6)
        return DEFAULT_VOID_COLOR;
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return DEFAULT_VOID_COLOR;
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

//将浮点数转换为NSString，并设置保留小数点位数
+ (NSString *)getStringFromFloat:(float) f withDecimal:(int) decimalPoint{
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:kCFNumberFormatterDecimalStyle];
    [numberFormatter setMaximumFractionDigits:decimalPoint];

    return  [numberFormatter stringFromNumber:[NSNumber numberWithFloat:f]];
}

//判断字符串为nil或""
+ (BOOL)isNil:(NSString *)str
{
    if (str == nil || [str isEqualToString:@""]) {
        return YES;
    }else{
        return NO;
    }
}

//几秒前，几分钟前，几小时前，几天前
+(NSString *)dateIntervalStr:(NSString *)startDateStr{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date1 = [formatter dateFromString:startDateStr];
    NSDate *date2 = [NSDate date];
    NSTimeInterval aTimer = [date2 timeIntervalSinceDate:date1];
    
    NSString *intervalDateStr = @"";
    if (aTimer < 60) {
        intervalDateStr = [NSString stringWithFormat:@"%.0f 秒前",aTimer];
    }else if (aTimer >= 60 && aTimer < 3600){
        intervalDateStr = [NSString stringWithFormat:@"%.0f 分钟前",aTimer/60];
    }else if (aTimer >= 3600 && aTimer < 3600*24){
        intervalDateStr = [NSString stringWithFormat:@"%.0f 小时前",aTimer/3600];
    }else if (aTimer >= 3600*24){
        intervalDateStr = [NSString stringWithFormat:@"%.0f 天前",aTimer/(3600*24)];
    }
    return intervalDateStr;
}

//几秒前，几分钟前，几小时前，几天前   美娘专用
+(NSString *)MNdateIntervalStr:(NSString *)startDateStr{
    
    NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:[startDateStr doubleValue] / 1000.0];
    
    NSDate *date2 = [NSDate date];
    NSTimeInterval aTimer = [date2 timeIntervalSinceDate:date1];
    
    NSString *intervalDateStr = @"";
    if (aTimer < 60) {
        intervalDateStr = @"刚刚";
    }else if (aTimer >= 60 && aTimer < 3600){
        intervalDateStr = [NSString stringWithFormat:@"%.0f.分钟前",aTimer/60];
    }else if (aTimer >= 3600 && aTimer < 3600*24){
        intervalDateStr = [NSString stringWithFormat:@"%.0f.小时前",aTimer/3600];
    }else if (aTimer >= 3600*24 && aTimer < 3600 * 24 * 7){
        intervalDateStr = [NSString stringWithFormat:@"%.0f.天前",aTimer/(3600*24)];
    }else {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        intervalDateStr = [formatter stringFromDate:date1];
    }
    return intervalDateStr;
}



+ (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

+(UIImage *)imageClips:(UIImage *)oldImage Rect:(CGRect)rect
{
    CGImageRef newImageRef = CGImageCreateWithImageInRect(oldImage.CGImage, rect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    CGImageRelease( newImageRef );
    return newImage;
}

+ (UIImage *)studentImageWithLevel:(NSString *)str
{
    NSLog(@"%@",[NSString stringWithFormat:@"美娘学生级别%@.png",str]);
    return [UIImage imageNamed:[NSString stringWithFormat:@"美娘学生级别%@.png",str]];
}

+ (UIImage *)teacherImageWithLevel:(NSString *)str
{
    return [UIImage imageNamed:[NSString stringWithFormat:@"美娘老师级别%@.png",str]];
}

+ (UIImage *)teacherImageWithLevel2:(NSString *)str
{
    return [UIImage imageNamed:[NSString stringWithFormat:@"teacherlevel%@.png",str]];
}

+ (UIImage *)sexImageWithNSString:(NSString *)str
{
    return [UIImage imageNamed:[NSString stringWithFormat:@"mn-sex-%ld.png",[str integerValue]]];
}

+ (UIImage *)sexImageWithNSString2:(NSString *)str
{
    return [UIImage imageNamed:[NSString stringWithFormat:@"baisesex%@.png",str]];
}
@end
