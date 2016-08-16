//
//  UIButton+CalendarBtn.h
//  日历
//
//  Created by  王伟 on 16/8/16.
//  Copyright © 2016年  王伟. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^Click)();

@interface UIButton (CalendarBtn)


- (void)buttonClick:(Click)click;
@end
