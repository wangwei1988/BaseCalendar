//
//  NSDate+Calendar.h
//  日历
//
//  Created by  王伟 on 16/8/16.
//  Copyright © 2016年  王伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Calendar)

//当前日
+ (NSInteger)day:(NSDate *)date;
//当前月
+ (NSInteger)month:(NSDate *)date;
//当前年
+ (NSInteger)year:(NSDate *)date;
//第一天星期几
+ (NSInteger)firstWeekdayInThisMonth:(NSDate *)date;
//当前月总共天数
+ (NSInteger)totaldaysInThisMonth:(NSDate *)date;
//上一月
+ (NSDate *)lastMonth:(NSDate *)date;
//下一月
+ (NSDate*)nextMonth:(NSDate *)date;
@end
