//
//  BaseCalendar.m
//  日历
//
//  Created by  王伟 on 16/8/16.
//  Copyright © 2016年  王伟. All rights reserved.
//

#import "BaseCalendar.h"
#import "NSDate+Calendar.h"
#import "BaseCalendarCell.h"
#import "UIView+Extension.h"
#import "UIButton+CalendarBtn.h"
@interface BaseCalendar ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong) UICollectionView *CalendarView;
@property (nonatomic,strong) NSArray *weakDayArray;
@property (nonatomic,strong) NSIndexPath *selectedIndexPath;
@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,strong) UILabel *showDateLabel;

@property (nonatomic,strong) UIButton *backBtn;
@property (nonatomic,strong) UIButton *nextBtn;


@end

@implementation BaseCalendar
static NSString *identifer = @"CalendarCell";
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initHeaderView];
        self.weakDayArray = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
        [self initCalendarView];
    }
    return self;
}

- (void)setDate:(NSDate *)date {
    _date = date;
    [self.CalendarView reloadData];
}

- (void)initHeaderView {
    self.headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 40)];
    self.headerView.backgroundColor = [UIColor greenColor];
    self.showDateLabel = [[UILabel alloc]init];
    self.showDateLabel.frame = CGRectMake((self.width - 160) / 2, 10, 160, 20);
    self.showDateLabel.textAlignment = NSTextAlignmentCenter;
    self.showDateLabel.textColor = [UIColor whiteColor];
    [self.headerView addSubview:self.showDateLabel];
    
    self.backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    [self.backBtn setTitle:@"上一月" forState:UIControlStateNormal];
    [self.backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.backBtn buttonClick:^{
        NSLog(@"上一月");
        self.date = [NSDate lastMonth:self.date];
        self.selectedIndexPath = nil;
        [self.CalendarView reloadData];
        CATransition *animation = [CATransition animation];
        animation.duration = 0.7f;
        animation.type = @"pageUnCurl";//@"pageUnCurl"---pageUnCurl
        animation.subtype = kCATransitionFromBottom;
        animation.timingFunction = UIViewAnimationOptionCurveEaseInOut;
        [self.layer addAnimation:animation forKey:@"animation"];
    }];
    [self.headerView addSubview:self.backBtn];
    
    self.nextBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.width - 80, 0, 80, 40)];
    [self.nextBtn setTitle:@"下一月" forState:UIControlStateNormal];
    [self.nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.nextBtn buttonClick:^{
        NSLog(@"下一月");
        self.date = [NSDate nextMonth:self.date];
        self.selectedIndexPath = nil;
        [self.CalendarView reloadData];
        
        CATransition *animation = [CATransition animation];
        animation.duration = 0.7f;
        animation.type = @"pageCurl";//@"pageUnCurl"---pageUnCurl
        animation.subtype = kCATransitionFromBottom;
        animation.timingFunction = UIViewAnimationOptionCurveEaseInOut;
        [self.layer addAnimation:animation forKey:@"animation"];
    }];
    [self.headerView addSubview:self.nextBtn];
    
    [self addSubview:self.headerView];
}

- (void)initCalendarView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.itemSize = CGSizeMake(self.bounds.size.width / 7, self.bounds.size.width / 7);
    flowLayout.sectionInset = UIEdgeInsetsZero;
    
    self.CalendarView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 40, self.width, self.height - 40) collectionViewLayout:flowLayout];
    self.CalendarView.backgroundColor = [UIColor whiteColor];
    [self.CalendarView registerClass:[BaseCalendarCell class] forCellWithReuseIdentifier:identifer];
    self.CalendarView.delegate = self;
    self.CalendarView.dataSource = self;
    [self addSubview:self.CalendarView];
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return self.weakDayArray.count;
    }
    return 6 * 7; 
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BaseCalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifer forIndexPath:indexPath];
    cell.label.textColor = [UIColor blackColor];
    cell.label.backgroundColor = [UIColor whiteColor];
    if (indexPath.section == 0) {
        cell.label.text = self.weakDayArray[indexPath.row];
        cell.label.textColor = [UIColor purpleColor];
    } else {
        NSInteger totalDays = [NSDate totaldaysInThisMonth:self.date];
        NSInteger firstWeekday = [NSDate firstWeekdayInThisMonth:self.date];
//        NSLog(@"%ld,%ld",totalDays,firstWeekday);
        if (indexPath.row < firstWeekday) {
            cell.label.text = @"";
        } else if (indexPath.row < firstWeekday + totalDays ) {
            cell.label.text = [NSString stringWithFormat:@"%ld",indexPath.row - (firstWeekday - 1)];
        } else {
            cell.label.text = @"";
        }
        
        if ([NSDate month:[NSDate date]] == [NSDate month:self.date]) {
            if (indexPath.row == [NSDate day:self.date]) {
                cell.label.backgroundColor = [UIColor redColor];
            }
        }
        if (indexPath == self.selectedIndexPath) {
            cell.label.backgroundColor = [UIColor yellowColor];
            self.showDateLabel.text = [NSString stringWithFormat:@"%ld-%ld-%ld",(long)[NSDate year:self.date],(long)[NSDate month:self.date],indexPath.row];
        }
        if (self.selectedIndexPath != nil) {
            self.showDateLabel.text = [NSString stringWithFormat:@"%ld-%ld-%ld",(long)[NSDate year:self.date],(long)[NSDate month:self.date],self.selectedIndexPath.row  - (firstWeekday - 1)];
        } else {
            if ([NSDate month:[NSDate date]] == [NSDate month:self.date]) {
                self.showDateLabel.text = [NSString stringWithFormat:@"%ld-%ld-%ld",(long)[NSDate year:self.date],(long)[NSDate month:self.date],[NSDate day:self.date]  - (firstWeekday - 1)];
            } else {
                self.showDateLabel.text = [NSString stringWithFormat:@"%ld-%ld-%d",(long)[NSDate year:self.date],(long)[NSDate month:self.date],1];
            }
            
        }
        if (indexPath.row == 41) {
            if ([self.delegate respondsToSelector:@selector(currentSelectedDate:)]) {
                [self.delegate currentSelectedDate:self.showDateLabel.text];
            };
        }
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 ) {
        return;
    }
    NSInteger totalDays = [NSDate totaldaysInThisMonth:self.date];
    NSInteger firstWeekday = [NSDate firstWeekdayInThisMonth:self.date];
    if (indexPath.row < firstWeekday) {
        return;
    } else if (indexPath.row < firstWeekday + totalDays ) {
        self.selectedIndexPath = indexPath;
    } else {
        return;
    }
    [self.CalendarView reloadData];
    

}

@end
