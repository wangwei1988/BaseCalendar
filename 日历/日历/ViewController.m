//
//  ViewController.m
//  日历
//
//  Created by  王伟 on 16/8/16.
//  Copyright © 2016年  王伟. All rights reserved.
//

#import "ViewController.h"
#import "BaseCalendar.h"
#import "UIView+Extension.h"
@interface ViewController ()<BaseCalendarDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    BaseCalendar *baseCalendar = [[BaseCalendar alloc]initWithFrame:CGRectMake((self.view.width - 320) / 2, 100, 320 ,400 )];
    baseCalendar.delegate = self;
    baseCalendar.date = [NSDate date];
    [self.view addSubview:baseCalendar];
}

-(void)currentSelectedDate:(NSString *)selectedDate {
    NSLog(@"%@",selectedDate);
}

@end
