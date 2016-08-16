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
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    BaseCalendar *baseCalendar = [[BaseCalendar alloc]initWithFrame:CGRectMake(0, 100, self.view.width, self.view.height - 100 )];
    baseCalendar.date = [NSDate date];
    [self.view addSubview:baseCalendar];
}

@end
