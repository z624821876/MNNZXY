//
//  DateUtil.h
//  MyCalendar
//
//  Created by jh niu on 12-8-21.
//  Copyright (c) 2012年 sunday. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DateUtil : UIViewController{
    
}
//获取农历
+(NSString*)getChineseCalendarWithDate:(NSDate *)date;
//获取当前周的第一天
+(NSDate *)beginningOfWeek:(NSDate *)date;
//返回当前周的周末
+(NSDate *)endOfWeek:(NSDate *)date;
//获取根据天数前后日期
+ (NSDate *)dateAfterDay:(int)day :(NSDate *)today;
//该日期是该年的第几周
+(int)getWeekOfYear:(NSDate *)date;
//获取年
+(NSUInteger)getYear:(NSDate *)date;
+ (NSUInteger)getDay:(NSDate *)today;
+ (NSDate *)dateFromString:(NSString *)string :(NSString *)stringtype;
+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format;
//农历节日
+(NSString *)getLunarHoliDayDate:(NSDate *)date;
//获取月
+(NSUInteger)getMonth:(NSDate *)date;
+(NSString *)getLunarSpecialDate:(NSDate *)date;
+(NSString*)getChineseCalendarWithfullDate:(NSDate *)date;
//返回该月的第一天
+ (NSDate *)beginningOfMonth:(NSDate *)date;
//该月的最后一天
+(NSDate *)endOfMonth:(NSDate *)date;
+ (NSDate *)dateafterMonth:(int)month :(NSDate *)date;

//得到消除时差差异后的本地date string. 返回值如： "2013-05-20 10:54:13 +0000"
+(NSDate *)getLocaleDateStr:(NSDate *)date;

 
@end
