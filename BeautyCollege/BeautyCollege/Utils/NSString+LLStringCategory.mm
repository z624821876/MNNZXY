//
//  NSString+LLStringCategory.m
//  wallet2
//
//  Created by ZC on 13-12-11.
//  Copyright (c) 2013年 LianLian. All rights reserved.
//

#import "NSString+LLStringCategory.h"

@implementation NSString (SSStringCategory)


- (NSString *)getImageName		//从一个图片全称种获取它的命名
{
	NSRange searchRange = [self rangeOfString:@"."];
	if (searchRange.location != NSNotFound)
	{
		return [self substringToIndex:searchRange.location];
	}
	else
		return self;
}

- (NSString *)getImageType		//从一个图片全称获取它的类型
{
	NSRange searchRange = [self rangeOfString:@"."];
	if (searchRange.location != NSNotFound)
	{
		return [self substringFromIndex:searchRange.location + 1];
	}
	else
		return @"png";
}

-(NSString *) stringByStrippingHTML //把一个http里面的标签去掉
{
    NSRange r;
    NSString *s = [[self copy] autorelease];
    while ((r = [s rangeOfString:@"<[^>]*>" options:NSRegularExpressionSearch]).location != NSNotFound)
        
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    
    s = [s stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    return s;
    
}

- (NSString *)clearWhiteSpaceAndNewLine{//去除一个String里面的空格跟换行
	return [[self componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
			componentsJoinedByString:@""];
}

- (NSString *)trimString{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (BOOL)isValidRechargeMoney
{
    NSRange range = [self rangeOfString:@"."];
    if (range.length > 0) {
        NSString *behindString = [self substringFromIndex:range.location+range.length];
        NSLog(@"behindString: %@",behindString);
        if (behindString.length > 2) {
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)isPureNumber
{
    NSScanner *scanner = [NSScanner scannerWithString:self];
    
    int number;
    return [scanner scanInt:&number] && [scanner isAtEnd];
    
}

- (BOOL)isValidMobile
{
    if (self.length < 11)
    {
        return NO;
    }
    if (![self isPureNumber])
    {
        return NO;
    }
    
//    if ([self rangeOfString:@"13"].location != 0
//        &&[self rangeOfString:@"15"].location != 0
//        &&[self rangeOfString:@"18"].location != 0
//        &&[self rangeOfString:@"14"].location != 0)
//    {
//        return NO;
//    }
    
    return YES;
}


@end
