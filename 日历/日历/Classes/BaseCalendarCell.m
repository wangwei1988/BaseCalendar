//
//  BaseCalendarCell.m
//  日历
//
//  Created by  王伟 on 16/8/16.
//  Copyright © 2016年  王伟. All rights reserved.
//

#import "BaseCalendarCell.h"
#import "UIView+Extension.h"
@implementation BaseCalendarCell

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc]init];
        _label.x = self.bounds.size.width / 2 - 14;
        _label.y = self.bounds.size.height / 2 - 14;
        _label.width = 28;
        _label.height = 28;
        _label.textAlignment = NSTextAlignmentCenter;
        _label.layer.cornerRadius = _label.frame.size.width / 2;
        _label.layer.masksToBounds = YES;
        [self.contentView addSubview:_label];
    }
    return _label;
}




@end
