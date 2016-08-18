//
//  BaseCalendar.h
//  日历
//
//  Created by  王伟 on 16/8/16.
//  Copyright © 2016年  王伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BaseCalendarDelegate <NSObject>

-(void)currentSelectedDate:(NSString *)selectedDate weekDay:(NSString *)weakDay;

@end

@interface BaseCalendar : UIView
@property (nonatomic,strong) NSDate *date;


@property (nonatomic,weak) id <BaseCalendarDelegate> delegate;


@end
