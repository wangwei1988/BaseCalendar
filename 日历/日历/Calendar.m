//
//  Calendar.m
//  日历
//
//  Created by  王伟 on 16/3/8.
//  Copyright © 2016年  王伟. All rights reserved.
//

#import "Calendar.h"
#import "myCollectionViewCell.h"
@interface Calendar ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSArray *weakDayArray;
@property (nonatomic,strong) NSMutableArray *daysArray;
@property (nonatomic,strong) NSIndexPath *indexPath;
@end

@implementation Calendar
static NSString *identifier = @"Cell";

- (NSMutableArray *)daysArray
{
    if (!_daysArray)
    {
        _daysArray = [NSMutableArray array];
    }
    return _daysArray;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.weakDayArray = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
        self.backgroundColor = [UIColor whiteColor];
        [self addCollectionView];
    }
    return self;
}

- (void)addCollectionView
{
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.itemSize = CGSizeMake(self.bounds.size.width / 7, 50);
    self.collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:flowLayout];
    [self.collectionView registerClass:[myCollectionViewCell class] forCellWithReuseIdentifier:identifier];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self addSubview:self.collectionView];
    
}

#pragma mark -UICollectionViewDelegate/UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return self.weakDayArray.count;
    }
    return 42;//6*7
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    myCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (indexPath.section == 0)
    {
        cell.label.text = self.weakDayArray[indexPath.row];
    }
    else {
        NSInteger daysInThisMonth = [self totaldaysInMonth:_date];
        NSInteger firstWeekday = [self firstWeekdayInThisMonth:_date];
        
        NSInteger day = 0;
        NSInteger i = indexPath.row;
        if (i < firstWeekday) {
            NSLog(@"%ld",(long)firstWeekday);
            [cell.label setText:@""];
            
        }else if (i > firstWeekday + daysInThisMonth - 1){
            [cell.label setText:@""];
        }else{
            day = i - firstWeekday + 1;
            if (day == [self day:_date])
            {
                self.indexPath = indexPath;
                cell.label.backgroundColor = [UIColor redColor];
            }
            NSLog(@"%ld",(long)day);
            [cell.label setText:[NSString stringWithFormat:@"%li",(long)day]];
        }
        [self.daysArray addObject:cell];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return;
    }
    else
    {
        myCollectionViewCell *cell = (myCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        [self.daysArray enumerateObjectsUsingBlock:^(myCollectionViewCell * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.label.backgroundColor = [UIColor whiteColor];
        }];

        myCollectionViewCell *todayCell = (myCollectionViewCell *)[collectionView cellForItemAtIndexPath:self.indexPath];
        todayCell.label.backgroundColor = [UIColor redColor];
        
        if (![cell.label.text isEqualToString:@""])
        {
            cell.label.backgroundColor = [UIColor yellowColor];
        }
    }
}



- (void)setDate:(NSDate *)date
{
    _date = date;
//    [_monthLabel setText:[NSString stringWithFormat:@"%.2d-%i",[self month:date],[self year:date]]];
    [_collectionView reloadData];
}

#pragma mark - date

- (NSInteger)day:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components day];
}


- (NSInteger)month:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components month];
}

- (NSInteger)year:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components year];
}


- (NSInteger)firstWeekdayInThisMonth:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar setFirstWeekday:1];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekday - 1;
}

- (NSInteger)totaldaysInThisMonth:(NSDate *)date{
    NSRange totaldaysInMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return totaldaysInMonth.length;
}

- (NSInteger)totaldaysInMonth:(NSDate *)date{
    NSRange daysInLastMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return daysInLastMonth.length;
}

- (NSDate *)lastMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

- (NSDate*)nextMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

@end
