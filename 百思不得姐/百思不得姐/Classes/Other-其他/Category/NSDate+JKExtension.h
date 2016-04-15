//
//  NSDate+JKExtension.h
//  百思不得姐
//
//  Created by 张俊凯 on 16/3/30.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (JKExtension)
-(NSDateComponents *)deltaFrom:(NSDate *)from;
//是否为今年
-(BOOL)isThisYear;
//是否为今天
-(BOOL)isThisToday;
//是否为昨天
-(BOOL)isThisYestoday;

@end
