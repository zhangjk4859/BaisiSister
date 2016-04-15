//
//  NSDate+JKExtension.m
//  百思不得姐
//
//  Created by 张俊凯 on 16/3/30.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

#import "NSDate+JKExtension.h"

@implementation NSDate (JKExtension)
-(NSDateComponents *)deltaFrom:(NSDate *)from
{

    //创建一个日历
    NSCalendar *calender = [NSCalendar currentCalendar];
    
    //从开始日期 到截止日期的 之间的时间差，给一个格式单元出来，日历帮你计算好，塞到单元里
    //数字没有指针
    NSCalendarUnit  unit = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
    
    return [calender components:unit fromDate:from toDate:self options:0];

}
//是否为今年
-(BOOL)isThisYear
{
    //两个时间的年份拿出来对比就可以了
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    //当前年份拿出来
    NSCalendarUnit nowYear = [calendar component:NSCalendarUnitYear fromDate:[NSDate date]];
    
    //要对比的年份拿出来
    NSCalendarUnit selfYear =[calendar component:NSCalendarUnitYear fromDate:self];
    
    
    return nowYear == selfYear;
}
////是否为今天
//-(BOOL)isThisToday
//{
//    //是否为今天代表三个都要对的上 年 月 日
//    //怎么把三个都取出来呢？有一个对象叫component
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    
//    NSCalendarUnit unit = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay;
//    
//    NSDateComponents *nowCom = [calendar components:unit fromDate:[NSDate date]];
//    NSDateComponents *selfCom = [calendar components:unit fromDate:self];
//    BOOL result = (nowCom.year == selfCom.year)&&(nowCom.month == selfCom.month)&&(nowCom.day == selfCom.day);
//    
//    return result;
//}

//是否为今天第二种方法  比较字符串
-(BOOL)isThisToday
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSString *nowString = [fmt stringFromDate:[NSDate date]];
    NSString *selfString = [fmt stringFromDate:self];
    return [nowString isEqualToString:selfString];
}


//是否为昨天
-(BOOL)isThisYestoday
{
    //先把日期格式化为只有年月日
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    fmt.dateFormat = @"yyyy-MM-dd";
    //先转换成只有年月日的字符串，再转换成时间
    NSDate *nowDate = [fmt dateFromString:[fmt stringFromDate:[NSDate date]]];
    
    NSDate *selfDate = [fmt dateFromString:[fmt stringFromDate:self]];
    
    
    
    //只比较天数，相差一天就是昨天
    NSCalendar *calender = [NSCalendar currentCalendar];
    
    NSCalendarUnit unit = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay;
    
   NSDateComponents *com =  [calender components:unit fromDate:selfDate toDate:nowDate options:0];
    
    BOOL result =  (com.year == 0 && com.month == 0 &&com.day == 1);
    
    return result;
}

@end
